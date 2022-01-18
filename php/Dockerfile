ARG PHP_DOCKER_VERSION
FROM php:${PHP_DOCKER_VERSION}-fpm
LABEL maintainer="blankqwq <github.com/blankqwq>"
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND noninteractive
ARG CHANGE_SOURCE=true

RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from deb.debian.org to aliyun source
    sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    sed -i 's/security-cdn.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
;fi
## Update Ubuntu
RUN  apt-get update -yqq&& pecl channel-update pecl.php.net && apt-get install -yqq --no-install-recommends apt-utils dialog
#安装ping
RUN apt-get install -yqq dialog iputils-ping net-tools vim
## mcrypt
RUN apt-get install -y libmcrypt-dev libzip-dev zip unzip libssl-dev libmemcached-dev curl

RUN if [ $(php -r "echo PHP_MAJOR_VERSION;") != "8" ]; then \
    pecl install mcrypt && docker-php-ext-enable mcrypt ; \
    fi
## GD
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libjpeg-dev libwebp-dev
RUN docker-php-ext-configure gd
RUN docker-php-ext-install -j$(nproc) gd
RUN php -r 'var_dump(gd_info());'


RUN docker-php-ext-install pcntl
RUN docker-php-ext-install opcache
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli

# Required by composer
RUN apt-get -y install \
            git \
            zlib1g-dev

###########################################################################
# GETTEXT:
###########################################################################

ARG INSTALL_GETTEXT=true

RUN if [ ${INSTALL_GETTEXT} = true ]; then \
    apt-get install -y zlib1g-dev libicu-dev g++ libpq-dev libssl-dev gettext && \
    docker-php-ext-install gettext \
;fi
###########################################################################
# BZ2:
###########################################################################

ARG INSTALL_BZ2=true
RUN if [ ${INSTALL_BZ2} = true ]; then \
  apt-get -y install libbz2-dev; \
  docker-php-ext-install bz2 \
;fi

###########################################################################
# xDebug:
###########################################################################

RUN if [ ${INSTALL_XDEBUG} = true ]; then \
  # Install the xdebug extension
  if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
    pecl install xdebug-2.5.5; \
  else \
    if [ $(php -r "echo PHP_MINOR_VERSION;") = "0" ]; then \
      pecl install xdebug-2.9.0; \
    else \
      pecl install xdebug; \
    fi \
  fi && \
  docker-php-ext-enable xdebug \
;fi

# Copy xdebug configuration for remote debugging
RUN mkdir -m 777 -p ~/xdebug/phpstorm/tmp/profiling/
COPY ./conf/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN sed -i "s/xdebug.remote_autostart=0/xdebug.remote_autostart=1/" /usr/local/etc/php/conf.d/xdebug.ini && \
    sed -i "s/xdebug.remote_enable=0/xdebug.remote_enable=1/" /usr/local/etc/php/conf.d/xdebug.ini && \
    sed -i "s/xdebug.cli_color=0/xdebug.cli_color=1/" /usr/local/etc/php/conf.d/xdebug.ini


###########################################################################
# PHP REDIS EXTENSION
###########################################################################

ARG INSTALL_PHPREDIS=true

RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
    # Install Php Redis Extension
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
      pecl install -o -f redis-4.3.0; \
    else \
      pecl install -o -f redis; \
    fi \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
;fi

###########################################################################
# PHP swoole:
###########################################################################
ARG INSTALL_SWOOLE=true
ARG SWOOLE_VERSION=4.7.0
RUN set -eux; \
    if [ ${INSTALL_SWOOLE} = true ]; then \
      # Install Php Swoole Extension
      if   [ $(php -r "echo PHP_VERSION_ID - PHP_RELEASE_VERSION;") = "50600" ]; then \
        pecl install swoole-2.0.10; \
      elif [ $(php -r "echo PHP_VERSION_ID - PHP_RELEASE_VERSION;") = "70000" ]; then \
        pecl install swoole-4.3.5; \
      elif [ $(php -r "echo PHP_VERSION_ID - PHP_RELEASE_VERSION;") = "70100" ]; then \
        pecl install swoole-4.5.11; \
      else \
        pecl install swoole-${SWOOLE_VERSION}; \
      fi; \
      docker-php-ext-enable swoole; \
      php -m | grep -q 'swoole'; \
    fi

###########################################################################
# Xhprof:
###########################################################################

ARG INSTALL_XHPROF=false

RUN if [ ${INSTALL_XHPROF} = true ]; then \
    # Install the php xhprof extension
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = 7 ]; then \
      curl -L -o /tmp/xhprof.tar.gz "https://github.com/tideways/php-xhprof-extension/archive/v5.0.1.tar.gz"; \
    else \
      curl -L -o /tmp/xhprof.tar.gz "https://codeload.github.com/phacility/xhprof/tar.gz/master"; \
    fi \
    && mkdir -p xhprof \
    && tar -C xhprof -zxvf /tmp/xhprof.tar.gz --strip 1 \
    && ( \
        cd xhprof \
        && phpize \
        && ./configure \
        && make \
        && make install \
    ) \
    && rm -r xhprof \
    && rm /tmp/xhprof.tar.gz \
;fi

#COPY ./xhprof.ini /usr/local/etc/php/conf.d

#RUN if [ ${INSTALL_XHPROF} = false ]; then \
#    rm /usr/local/etc/php/conf.d/xhprof.ini \
#;fi

###########################################################################
# PHP Memcached:
###########################################################################

ARG INSTALL_MEMCACHED=false
RUN if [ ${INSTALL_MEMCACHED} = true ]; then \
    # Install the php memcached extension
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
      pecl install memcached-2.2.0; \
    else \
      pecl install memcached-3.1.3; \
    fi \
    && docker-php-ext-enable memcached \
;fi


USER root

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

# Configure non-root user.
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

RUN groupmod -o -g ${PGID} www-data && \
    usermod -o -u ${PUID} -g www-data www-data


# Install composer
RUN curl -sS https://getcomposer.org/installer \
| php -- --install-dir=/usr/bin/ --filename=composer

RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
# Configure locale.
ARG LOCALE=POSIX
ENV LC_ALL ${LOCALE}
CMD ["php-fpm"]
EXPOSE 9000 9501
WORKDIR /data/code