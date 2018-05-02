FROM python:slim-stretch

RUN apt-get update && \
    apt-get -y install \
      sudo \
      wget \
      git \
      gcc \
      g++ \
      make \
      curl \
      file \
      xz-utils \
      mecab-ipadic \
      mecab-ipadic-utf8

WORKDIR /tmp/downloads
RUN git clone --depth 1 https://github.com/taku910/mecab.git && \
    git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    git clone https://github.com/attardi/wikiextractor

WORKDIR /tmp/downloads/mecab/mecab
RUN ./configure  --enable-utf8-only && \
    make && \
    make check && \
    make install

WORKDIR /tmp/downloads/mecab-ipadic-neologd
# install neologd to /usr/local/lib/mecab/dic/mecab-ipadic-neologd
RUN ./bin/install-mecab-ipadic-neologd -n -y && \
    ln -s /usr/local/lib/mecab/dic /var/mecab-dic


WORKDIR /
RUN rm -rf /tmp/downloads && \
    apt-get purge -y --auto-remove \
      wget \
      git \
      gcc \
      g++ \
      make \
      curl \
      file \
      xz-utils
