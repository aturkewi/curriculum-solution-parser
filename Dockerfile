FROM ruby:2.5

RUN apt-get update -yqq
RUN apt-get install -yqq python-pip
RUN pip install jupyter

RUN git config --global user.email "aviturkewitz@hotmail.com"
RUN git config --global user.name "Bizzaro Avidor"

COPY ./parser.rb /usr/local/bin/parser.rb
RUN chmod +x /usr/local/bin/parser.rb
