ARG MYSQL_VERSION=5.7
FROM mysql:${MYSQL_VERSION}
LABEL maintainer="blankqwq <github.com/blankqwq>"
ENV MYSQL_ROOT_PASSWORD=123456

ARG TZ=PRC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && chown -R mysql:root /var/lib/mysql/
COPY ./conf/mysql.conf /etc/mysql/conf.d/my.cnf
RUN chmod 0444 /etc/mysql/conf.d/my.cnf

CMD ["mysqld"]

EXPOSE 3306