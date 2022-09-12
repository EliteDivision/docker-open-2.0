ARG php_version='7.0'

FROM elitedivision/open-2.0:latest-$php_version

# Install software requirements
RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    libapache2-mod-shib \
    && apt-get clean \
    && apt-get autoclean

# Apache Section
RUN a2enmod \
    shib

COPY service/ /service/
COPY supervisor/ /etc/supervisor/conf.d/
COPY apache/ /etc/apache2/

# Optional ENV Vars
ENV ENABLE_SHIBD="true"

# PHP Versioning
ENV PHP_VERSION=$php_version