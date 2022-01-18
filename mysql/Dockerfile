ARG MYSQL_VERSION=5.7
FROM mysql:${MYSQL_VERSION}
LABEL maintainer="blankqwq <github.com/blankqwq>"

ARG CHANGE_SOURCE=true
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from deb.debian.org to aliyun source
    sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    sed -i 's/security-cdn.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
;fi
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 467B942D3A79BD29
## Update Ubuntu
RUN  apt-get update -yqq&&  apt-get install -yqq --no-install-recommends apt-utils
#安装ping
RUN apt-get install -yqq dialog iputils-ping net-tools vim

RUN mkdir -p /var/logs/mysql/ && chmod 777 /var/log/mysql
COPY ./conf/mysql.conf /etc/mysql/conf.d/my.cnf
RUN chmod 0444 /etc/mysql/conf.d/my.cnf

CMD ["mysqld"]
EXPOSE 3306