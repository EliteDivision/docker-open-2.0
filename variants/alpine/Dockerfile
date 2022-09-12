FROM alpine:3.15.4

# Timezone
ENV TZ Europe/Rome

# ENV Vars, must be all set by user on start
ENV DOMAIN_FRONTEND="frontend"
ENV DOMAIN_BACKEND="backend"
ENV PHP_VERSION="7.0"

# Install software requirements
RUN apk add --no-cache \
    php7-fpm \
    php7-mcrypt \
    php7-soap \
    php7-json \
    php7-dom \
    php7-pdo \
    php7-zip \
    php7-mysqli \
    php7-apcu \
    php7-bcmath \
    php7-gd \
    php7-odbc \
    php7-pdo_mysql \
    php7-xmlreader \
    php7-xmlrpc \
    php7-curl \
    php7-apache2 \
    supervisor \
    nginx \
    mariadb-client \
    logrotate \
    python3 \
    py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
    awscli \
    && rm -rf /var/cache/apk/*

# Extra Software
RUN wget -O "wkhtmltopdf.deb" "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb" && \
    dpkg -i wkhtmltopdf.deb && \
    rm wkhtmltopdf.deb

# Application base source code
COPY --chown=www-data:www-data app /var/www/app

# Copy Services Files
COPY docker/entrypoint.sh /
COPY docker/service/ /service/

COPY docker/cron/ /etc/cron.d/

COPY docker/apache/ /etc/apache2/

COPY docker/logrotate/ /etc/logrotate.d/

COPY docker/php/php.ini /etc/php/${PHP_VERSION}/fpm/conf.d/30-customs.ini
COPY docker/php/php.ini /etc/php/${PHP_VERSION}/apache2/conf.d/30-customs.ini
COPY docker/php/php.pool /etc/php/${PHP_VERSION}/fpm/pool.d/zz_custom.conf

COPY docker/supervisor/ /etc/supervisor/conf.d/

# Post Processes
RUN chmod +x /entrypoint.sh && \
    mkdir -p /run/php

# Optional ENV Vars
ENV ENABLE_CRON="true"
ENV ENABLE_APACHE="true"
ENV ENABLE_PHP="true"

# Ports
EXPOSE 443

# Set entrypoint and default command.
CMD "/entrypoint.sh"
