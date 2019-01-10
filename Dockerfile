FROM node

MAINTAINER Guolin.Pan

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y wget

WORKDIR /
RUN mkdir -p /stackedit
RUN wget https://github.com/benweet/stackedit/archive/v5.13.0.tar.gz
RUN tar -xzf v5.13.0.tar.gz

WORKDIR /stackedit-5.13.0
RUN npm install

EXPOSE 3000

CMD node server.js
