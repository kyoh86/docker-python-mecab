FROM kyoh86/python-mecab

RUN apt-get update && \
    apt-get -y install \
      wget \
      jq \
      git

WORKDIR /tmp/downloads
RUN git clone https://github.com/attardi/wikiextractor

WORKDIR /tmp/downloads/wikiextractor
RUN wget https://dumps.wikimedia.org/jawiki/latest/jawiki-latest-pages-articles.xml.bz2
# COPY jawiki-20180420-pages-articles-multistream.xml.bz2 /tmp/downloads/wikiextractor/jawiki-latest-pages-articles.xml.bz2
RUN python setup.py install && \
    mkdir -p /var/wikipedia/ja && \
    WikiExtractor.py -b 1M -o - --json jawiki-latest-pages-articles.xml.bz2 | jq -r .text | grep -ve '^$' | split -a 3 -l 3000 - /var/wikipedia/ja/wiki_
# RUN find /var/wikipedia/ja -type f | wc -l

WORKDIR /
RUN rm -rf /tmp/downloads && \
    apt-get purge -y --auto-remove \
      wget \
      jq \
      git
