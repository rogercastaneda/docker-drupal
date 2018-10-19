# install nginx alpine version
# https://hub.docker.com/r/unblibraries/nginx-php/
FROM unblibraries/nginx-php:alpine-php7

LABEL version="0.1"
LABEL description="Basic nginx image with ssl for local development projects with php56x"
LABEL maintainer="roger.castaneda@bonzzu.com"

# https://github.com/codecasts/php-alpine
# php-bcmath php-bz2 php-calendar php-ctype php-curl php-dba
# php-dom php-embed php-enchant php-exif php-ftp php-gd
# php-gettext php-gmp php-iconv php-imap php-intl php-json
# php-ldap php-litespeed php-mbstring php-mcrypt php-mysqli
# php-mysqlnd php-odbc php-opcache php-openssl php-pcntl
# php-pdo php-pdo_dblib php-pdo_mysql php-pdo_pgsql php-pdo_sqlite
# php-pear php-pgsql php-phar php-phpdbg php-posix php-pspell
# php-session php-shmop php-snmp php-soap php-sockets php-sqlite3
# php-sysvmsg php-sysvsem php-sysvshm php-tidy php-wddx php-xml
# php-xmlreader php-xmlrpc php-xsl php-zip php-zlib

# enabled by parent docker image
# php5-fpm php5-json php5-zlib php5-xml php5-phar php5-gd php5-iconv php5-mcrypt curl php5-curl php5-openssl
RUN \
  apk add --no-cache php7 php7-fpm php7-pdo_mysql php7-zip php7-xml php7-simplexml php7-xmlreader php7-mbstring php7-apcu php7-xmlrpc php7-memcached php7-dom php7-tokenizer php7-xmlwriter
#   apk add --update openssh openssl php php5-pdo_mysql php5-zip php5-simplexml php5-xmlreader php-mbstring php5-apcu php5-xmlrpc php5-memcached php5-dom 
RUN \
  apk add --update openssh openssl && \
  mkdir -p /etc/nginx/ssl && \
  openssl genrsa -out /etc/nginx/ssl/dummy.key 2048 && \
  openssl req -new -key /etc/nginx/ssl/dummy.key -out /etc/nginx/ssl/dummy.csr -subj "/C=GB/L=London/O=Company Ltd/CN=docker" && \
  openssl x509 -req -days 3650 -in /etc/nginx/ssl/dummy.csr -signkey /etc/nginx/ssl/dummy.key -out /etc/nginx/ssl/dummy.crt

RUN apk add --no-cache mysql-client openssh-client rsync git 
RUN composer global require drush/drush:8.1.17 
ENV PATH="/root/.composer/vendor/bin:${PATH}"


WORKDIR /app
COPY nginx-app-7.conf /etc/nginx/conf.d/app.conf

# expose container port
EXPOSE 80 443
