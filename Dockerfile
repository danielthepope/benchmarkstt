FROM python:3.7-alpine

LABEL maintainer "EBU <ai-stt@list.ebu.ch>"

RUN apk --update add python py-pip openssl ca-certificates py-openssl wget
RUN apk --update add --virtual build-dependencies libffi-dev openssl-dev python-dev py-pip build-base
RUN python -m pip install --upgrade pip setuptools wheel

WORKDIR /app

COPY setup.py VERSION README.rst /app/
RUN mkdir -p ./src/benchmarkstt
RUN python -m pip install -e '.[test]'
COPY . /app/
RUN python -m pip install --no-deps -e '.'

ENTRYPOINT [ "/bin/sh" ]
