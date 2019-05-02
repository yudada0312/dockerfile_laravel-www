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
RUN chmod u+x /var/entrypoint.sh

WORKDIR ${WORKDIR}
CMD ["/bin/sh", "-c","/var/entrypoint.sh"]
