if [ "$ENABLE_APACHE" = "false" ] ; then
    rm /etc/supervisor/conf.d/apache.conf
else
    #Override Apache Vhost Domains
    sed -i "s/FRONTEND/${DOMAIN_FRONTEND}/" /etc/apache2/sites-available/000-default.conf
    sed -i "s/BACKEND/${DOMAIN_BACKEND}/" /etc/apache2/sites-available/000-default.conf

    # Generate Self-Signed Certificate
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/httpd.key \
    -subj "/C=IT/ST=Italy/L=Generic/O=Private/OU=Systems/CN=com.private/emailAddress=security@company.it" \
    -out /etc/ssl/private/httpd.crt

    # Debug
    apache2ctl configtest

    # Force  stop services
    systemctl disable apache2.service
    service apache2 stop
fi