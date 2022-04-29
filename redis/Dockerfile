ARG REDIS_VERSION=5.0
FROM redis:${REDIS_VERSION}

ARG CHANGE_SOURCE=true
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from deb.debian.org to aliyun source
    sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    sed -i 's/security-cdn.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
;fi
## Update Ubuntu
RUN  apt-get update -yqq&&  apt-get install -yqq --no-install-recommends apt-utils
#安装ping
RUN apt-get install -yqq dialog iputils-ping net-tools vim

EXPOSE 6379
CMD ["redis-server"]