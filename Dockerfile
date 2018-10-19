FROM rogercastaneda/nginx-php71:0.1

LABEL version="php71"
LABEL maintainer="roger.castaneda@bonzzu.com"

RUN apk add --no-cache mysql-client openssh-client rsync git && \
  composer global require drush/drush:8.1.17 
ENV PATH="/root/.composer/vendor/bin:${PATH}"

