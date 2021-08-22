FROM golang:1.17

RUN apt-get update && \
    apt-get -qq install -y make git gnupg unzip

RUN apt-get -qq clean && \
    truncate -s 0 /var/log/*log