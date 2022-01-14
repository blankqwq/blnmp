ARG NODE_DOCKER_VERSION
FROM node:${NODE_DOCKER_VERSION}
LABEL maintainer="blankqwq <github.com/blankqwq>"
RUN npm install -g cnpm --registry=https://registry.npmmirror.com
WORKDIR /data/code
EXPOSE 8080
