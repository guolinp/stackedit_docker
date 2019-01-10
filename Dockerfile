FROM node

MAINTAINER Guolin.Pan

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y wget

WORKDIR /
RUN git clone https://github.com/benweet/stackedit.git

WORKDIR /stackedit
RUN npm install \
    && npm install bower \
    && node_modules/bower/bin/bower install --production --config.interactive=false --allow-root

EXPOSE 3000

CMD node server.js
