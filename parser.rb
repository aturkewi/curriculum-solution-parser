#!/usr/bin/env ruby
require 'json'

def parse(cell)
  original_code_array = cell["source"]

  memo = {start: nil, end: nil}
  original_code_array.each_with_index do |line, index|
    memo[:start] = index if /#BEGIN/ =~ line
    memo[:end] = index if /#END/ =~ line
  end

  indent = original_code_array[memo[:start] + 1].match(/^\s+/)
  insert = indent[0] + "pass"
  original_code_array.slice!(memo[:start], memo[:end])

  cell["source"] = original_code_array.insert(memo[:start], insert)
  cell
end

filename = "./index.ipynb"
file = File.open filename
json = JSON.load file

puts json

new_json = json["cells"].map do |cell|
  if cell["cell_type"] == "code"
    parse(cell)
  else
    cell
  end
end

puts new_json
