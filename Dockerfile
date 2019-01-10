FROM ubuntu:18.04

MAINTAINER "Pan Guolin"

RUN apt-get update \
    && apt-get install -y curl git \
    && curl -sL https://deb.nodesource.com/setup_0.12 | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/benweet/stackedit.git

WORKDIR /stackedit

RUN npm install \
    && npm install bower \
    && node_modules/bower/bin/bower install --production --config.interactive=false --allow-root

EXPOSE 3000

CMD nodejs server.js
