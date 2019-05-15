FROM ruby:2.5

COPY ./parser.rb /usr/local/bin/parser.rb
RUN chmod +x /usr/local/bin/parser.rb
