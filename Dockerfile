# OS Selection
ARG OS_CODENAME="bookworm"

FROM debian:${OS_CODENAME}-slim

# Build Args
ARG OS_CODENAME
ARG PHP_VERSION="8.4"

#System ENV Vars
ENV OS_CODENAME=$OS_CODENAME
ENV PHP_VERSION=$PHP_VERSION

# Timezone
ENV TZ Europe/Rome

# ENV Vars, must be all set by user on start
ENV DOMAIN_FRONTEND="frontend"
ENV DOMAIN_BACKEND="backend"
ENV ENC_KEY="changeme"

# ENV Vars to Enable/Disable Services
ENV ENABLE_CRON="true"
ENV ENABLE_APACHE="true"
ENV ENABLE_PHP="true"

# Elastic Search
ENV ES_USER="_ESUSER"
ENV ES_PASS="_ESPASS"
ENV ES_HOST="_ESHOST"
ENV ES_PORT="_ESPORT"

# S3
ENV S3_BUCKET="_S3BUCKET"
ENV S3_SECRET_KEY="_S3SECRET"
ENV S3_ACCESS_KEY="_S3ACCESS"

# Distribution
ENV CDN_BASE_URL="_CDN_BASE_URL"

# Redis
ENV REDIS_HOST="_REDIS_HOST"
ENV REDIS_PORT="_REDIS_PORT"

# Install software requirements
RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    apt-transport-https \
    ca-certificates \
    #curl \
    gnupg2 \
    wget \
    && apt-get clean \
    && apt-get autoclean \
    && wget -O "/etc/apt/trusted.gpg.d/php.gpg" "https://packages.sury.org/php/apt.gpg" \
    && echo "deb https://packages.sury.org/php/ ${OS_CODENAME} main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    apache2 \
    cron \
    dos2unix \
    fontconfig \
    #git \
    libapache2-mod-security2 \
    #libapache2-mod-php${PHP_VERSION} \
    libfontenc1 \
    libwebp-dev \
    libxrender1 \
    lmodern \
    logrotate \
    mariadb-client \
    #nginx \
    ntp \
    pandoc \
    php${PHP_VERSION} \
    php${PHP_VERSION}-apcu \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-imagick \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-ldap \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    python3-pip \
    #procps \
    supervisor \
    texlive-latex-base \
    texlive-latex-recommended \
    unzip \
    xfonts-75dpi \
    xfonts-base \
    xfonts-utils \
    xfonts-encodings \
    && apt-get clean \
    && apt-get autoclean

# Apache Section
RUN a2enmod \
    alias \
    deflate \
    headers \
    include \
    mpm_event \
    negotiation \
    proxy \
    proxy_fcgi \
    proxy_http \
    rewrite \
    session \
    ssl \
    vhost_alias \
    && update-alternatives --set php /usr/bin/php${PHP_VERSION}

# Extra Software
RUN pip install awscli --upgrade --break-system-packages

# Application base source code
COPY --chown=www-data:www-data app /var/www/app

# Copy Services Files
COPY docker/entrypoint.sh /
COPY docker/service/ /service/

COPY docker/cron/ /etc/cron.d/

COPY docker/apache/ /etc/apache2/

COPY docker/logrotate/ /etc/logrotate.d/

COPY docker/php/php.ini /etc/php/${PHP_VERSION}/fpm/conf.d/30-customs.ini
COPY docker/php/cli.ini /etc/php/${PHP_VERSION}/cli/conf.d/30-customs.ini
COPY docker/php/php.ini /etc/php/${PHP_VERSION}/apache2/conf.d/30-customs.ini
COPY docker/php/php.pool /etc/php/${PHP_VERSION}/fpm/pool.d/zz_custom.conf

COPY docker/supervisor/ /etc/supervisor/conf.d/

# Post Processes
RUN chmod +x /entrypoint.sh && \
    mkdir -p /run/php

# Ports
EXPOSE 80 443

# Set entrypoint and default command.
CMD "/entrypoint.sh"