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
      jq \
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

WORKDIR /tmp/downloads/wikiextractor
RUN wget https://dumps.wikimedia.org/jawiki/latest/jawiki-latest-pages-articles.xml.bz2
# COPY jawiki-20180420-pages-articles-multistream.xml.bz2 /tmp/downloads/wikiextractor/jawiki-latest-pages-articles.xml.bz2
RUN python setup.py install && \
    mkdir -p /var/wikipedia/ja && \
    WikiExtractor.py -b 1M -o - --json jawiki-latest-pages-articles.xml.bz2 | jq -r .text | grep -ve '^$' | split -l 3000 - /var/wikipedia/ja/wiki_
# RUN find /var/wikipedia/ja -type f | wc -l

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
