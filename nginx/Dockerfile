FROM nginx:1.17

LABEL maintainer="blankqwq <github.com/blankqwq>"

COPY ./conf/nginx.conf /etc/nginx/
RUN groupadd -f www && useradd -g www www
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80 443
STOPSIGNAL SIGTERM

