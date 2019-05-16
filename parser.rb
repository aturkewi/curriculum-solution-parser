#!/usr/bin/env ruby
require 'json'

def parse(cell)
  original_code_array = cell["source"]

  memo = {start: nil, end: nil}
  original_code_array.each_with_index do |line, index|
    memo[:start] = index if /#BEGIN/ =~ line
    memo[:end] = index if /#END/ =~ line
  end

  if memo[:start] && memo[:end]
    puts "updating..."
    indent = original_code_array[memo[:start] + 1].match(/^\s+/)
    insert = indent[0] + "pass"
    original_code_array.slice!(memo[:start], memo[:end])

    cell["source"] = original_code_array.insert(memo[:start], insert)
  end

  cell
end

filename = "./index.ipynb"
file = File.open filename
json = JSON.load file

new_json = json["cells"].map do |cell|
  if cell["cell_type"] == "code"
    parse(cell)
  else
    cell
  end
end

# We will need to ensure that this branch _actually_ exists at some point
system("git checkout master")
system("rm index.ipynb")
system("touch index.ipynb")
File.write("index.ipynb", new_json)

system("jupyter nbconvert --to markdown index.ipynb")
system("mv index.md README.md")

system("git add .")
system("git commit -m 'update lab'")
system("git push -q https://${GITHUB_OAUTH_TOKEN}@github.com/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}.git master -f")
