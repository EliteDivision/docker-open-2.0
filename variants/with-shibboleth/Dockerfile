FROM elitedivision/open-2.0:latest

# Install software requirements
RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    libapache2-mod-shib \
    && apt-get clean \
    && apt-get autoclean

# Apache Section
RUN a2enmod \
    shib

COPY docker/service/ /service/
COPY supervisor/ /etc/supervisor/conf.d/

# Optional ENV Vars
ENV ENABLE_SHIBD="true"