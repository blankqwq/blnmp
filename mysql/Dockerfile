ARG MYSQL_VERSION=5.7
FROM mysql:${MYSQL_VERSION}
LABEL maintainer="blankqwq <github.com/blankqwq>"


RUN mkdir -p /var/logs/mysql/ && chmod 777 /var/logs/mysql
COPY ./conf/mysql.conf /etc/mysql/conf.d/my.cnf
RUN chmod 0444 /etc/mysql/conf.d/my.cnf

CMD ["mysqld"]
EXPOSE 3306