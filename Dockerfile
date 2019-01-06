FROM php:alpine
LABEL maintainer="yudada <yudada0312@gmail.com>"

RUN apk update && apk upgrade && apk add bash git
COPY entrypoint.sh /var

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install bcmath
RUN chmod u+x /var/entrypoint.sh

WORKDIR /var/www
CMD ["/bin/sh", "-c","/var/entrypoint.sh"]
