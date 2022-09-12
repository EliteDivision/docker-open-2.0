ARG PHP_VERSION='7.0'

FROM debian:buster-slim

# Timezone
ENV TZ Europe/Rome

# ENV Vars, must be all set by user on start
ENV DOMAIN_FRONTEND="frontend"
ENV DOMAIN_BACKEND="backend"

# Install software requirements
RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    lsb-release \
    wget \
    && apt-get clean \
    && apt-get autoclean \
    && wget -O "/etc/apt/trusted.gpg.d/php.gpg" "https://packages.sury.org/php/apt.gpg" \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    apache2 \
    cron \
    fontconfig \
    #git \
    libapache2-mod-php${PHP_VERSION} \
    libfontenc1 \
    libxrender1 \
    logrotate \
    mariadb-client \
    #nginx \
    ntp \
    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mcrypt \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-apcu \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-imagick \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-intl \
    procps \
    supervisor \
    unzip \
    xfonts-75dpi \
    xfonts-base \
    xfonts-utils \
    xfonts-encodings \
    && apt-get clean \
    && apt-get autoclean

# Apache Section
RUN a2enmod \
    ssl \
    php${PHP_VERSION} \
    headers \
    alias \
    include \
    negotiation \
    proxy \
    proxy_http \
    rewrite \
    session \
    vhost_alias \
    && update-alternatives --set php /usr/bin/php${PHP_VERSION}

# Extra Software
RUN wget -O "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -R awscliv2.zip ./aws && \
    wget -O "wkhtmltopdf.deb" "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb" && \
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