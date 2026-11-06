for INI in /etc/php/${PHP_VERSION}/fpm/conf.d/30-customs.ini /etc/php/${PHP_VERSION}/apache2/conf.d/30-customs.ini ; do
    sed -i "s/PHP_UPLOAD_MAX_FILESIZE/${PHP_UPLOAD_MAX_FILESIZE}/" $INI
    sed -i "s/PHP_POST_MAX_SIZE/${PHP_POST_MAX_SIZE}/" $INI
done

if [ "$ENABLE_PHP" = "false" ] ; then
    rm /etc/supervisor/conf.d/php.conf
    rm /etc/supervisor/conf.d/healthcheck.conf
else
    sed -i "s/PHP_VERSION/${PHP_VERSION}/" /etc/supervisor/conf.d/php.conf
    sed -i "s/PHP_VERSION/${PHP_VERSION}/" /etc/apache2/conf-enabled/95-php.conf
    sed -i "s/PHP_MAX_CHILDREN/${PHP_MAX_CHILDREN}/" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
fi