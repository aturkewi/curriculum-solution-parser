FROM ruby:2.5

RUN apt-get update -yqq
RUN apt-get install -yqq python-pip
RUN pip install jupyter

COPY ./parser.rb /usr/local/bin/parser.rb
RUN chmod +x /usr/local/bin/parser.rb
