FROM ubuntu:latest

RUN mkdir /app
WORKDIR /app
ADD . /app

RUN apt-get update
RUN apt-get install -y curl
RUN curl -sSL https://get.haskellstack.org/ | sh
RUN stack build
