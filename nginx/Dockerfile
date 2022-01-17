ARG NGINX_INSTALL_VERSION
FROM nginx:${NGINX_INSTALL_VERSION}

LABEL maintainer="blankqwq <github.com/blankqwq>"
ENV DEBIAN_FRONTEND noninteractive
ARG CHANGE_SOURCE=true

RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from deb.debian.org to aliyun source
    sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    sed -i 's/security-cdn.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
;fi
## Update Ubuntu
RUN  apt-get update -yqq&&  apt-get install -yqq --no-install-recommends apt-utils dialog
#安装ping
RUN apt-get install -yqq dialog iputils-ping net-tools vim
RUN groupadd -f www && useradd -g www www
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80 443
STOPSIGNAL SIGTERM

