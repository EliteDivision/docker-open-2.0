if [ "$ENABLE_PHP" = "false" ] ; then
    rm /etc/supervisor/conf.d/php.conf
else
    sed -i "s/PHP_VERSION/${PHP_VERSION}/" /etc/supervisor/conf.d/php.conf
fi