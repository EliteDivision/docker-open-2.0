if [ "$ENABLE_PHP" = "false" ] ; then
    rm /etc/supervisor/conf.d/php.conf
else
    sed -i "s/PHP_VERSION/${PHP_VERSION}/" /etc/supervisor/conf.d/php.conf
    sed -i "s/PHP_VERSION/${PHP_VERSION}/" /etc/apache2/conf-enabled/95-php.conf
fi