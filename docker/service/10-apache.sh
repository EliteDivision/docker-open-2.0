if [ "$ENABLE_APACHE" = "false" ] ; then
    rm /etc/supervisor/conf.d/apache.conf
else
    #Override Apache Vhost Domains
    sed -i "s/FRONTEND/${DOMAIN_FRONTEND}/" /etc/apache2/sites-available/000-default.conf
    sed -i "s/BACKEND/${DOMAIN_BACKEND}/" /etc/apache2/sites-available/000-default.conf

    # Generate Self-Signed Certificate
    openssl genrsa -out /etc/ssl/private/httpd.key 3072 > /dev/null 2>&1

    openssl req -new -sha256 \
        -out /etc/ssl/private/httpd.csr \
        -key /etc/ssl/private/httpd.key \
        -subj "/C=IT/ST=Italy/L=Generic/O=Private/OU=Systems/CN=com.private/emailAddress=security@company.it" \
         > /dev/null 2>&1

    openssl x509 -req -days 365 -outform PEM \
        -in /etc/ssl/private/httpd.csr \
        -signkey /etc/ssl/private/httpd.key \
        -out /etc/ssl/private/httpd.crt > /dev/null 2>&1

    # Debug
    echo "Checking Apache2 Syntax"
    apache2ctl configtest

    # Force  stop services
    systemctl disable apache2.service > /dev/null 2>&1 | true
    service apache2 stop > /dev/null 2>&1 | true
fi