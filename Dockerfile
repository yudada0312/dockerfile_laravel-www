FROM php:7.2.14-fpm-alpine3.8
LABEL maintainer="yudada <yudada0312@gmail.com>"

ENV TIME_ZONE Asia/Shanghai
ENV WORKDIR /var/www/html

RUN apk update && apk upgrade && apk add bash git && apk add --no-cache tzdata && echo "${TIME_ZONE}" > /etc/timezone && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime
COPY php.ini /usr/local/etc/php
COPY entrypoint.sh /var

# Install PHP extensions

RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install bcmath
# install gd lib
RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
  docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j${NPROC} gd && \
  apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev
RUN chmod u+x /var/entrypoint.sh

WORKDIR ${WORKDIR}
CMD ["/bin/sh", "-c","/var/entrypoint.sh"]
