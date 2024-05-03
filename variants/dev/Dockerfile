ARG PHP_VERSION='7.0'
FROM elitedivision/open-2.0:${PHP_VERSION}

# Install composer for development
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"