ARG PHP_VERSION='7.0'
FROM elitedivision/open-2.0:${PHP_VERSION}

# ShibbolethSP
ENV SP_FRONTEND_ID="frontend"
ENV SP_FRONTEND_IAM_ID="frontend_iam"
ENV SP_BACKEND_ID="backend"
ENV SP_BACKEND_IAM_ID="backend_iam"

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