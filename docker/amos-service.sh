#!/usr/bin/env bash

# Exit immediately on non-zero return codes.
set -e

# First Configuration
CONFIGFILE=/root/.installed

# Move to Application directory
cd /var/www/app/

# Impor custom phases
source /amos-service-phase-one.sh

if [ -f "$CONFIGFILE" ]; then
    echo "Already Configured. $CONFIGFILE"
	  cat $CONFIGFILE
else 
    # Debug message
    echo "First Time Setup"

    #Override Apache Domains
    sed -i "s/FRONTEND/${DOMAIN_FRONTEND}/" /etc/apache2/sites-available/000-default.conf
    sed -i "s/BACKEND/${DOMAIN_BACKEND}/" /etc/apache2/sites-available/000-default.conf

    #Enable Sevices
    if [ "$ENABLE_CRON" = "false" ] ; then
        rm /etc/supervisor/conf.d/cron.conf
    fi

    if [ "$ENABLE_APACHE" = "false" ] ; then
        rm /etc/supervisor/conf.d/apache.conf
    else
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/httpd.key \
        -subj "/C=IT/ST=Italy/L=Generic/O=Private/OU=Systems/CN=com.private/emailAddress=security@company.it" \
        -out /etc/ssl/private/httpd.crt
    fi

    if [ "$ENABLE_PHP" = "false" ] ; then
        rm /etc/supervisor/conf.d/php.conf
    fi

    # For Debug
    #echo "Apache Configs"
    #cat /etc/apache2/sites-available/000-default.conf
    echo "Supervisor Configs"
    cat /etc/supervisor/conf.d/supervisord.conf

    # Give the time to mount FS
    sleep 10

    # Debug
    echo "Configtest"
    apache2ctl configtest
    df -h > /var/www/app/common/uploads/diskUsage.log
    mount > /var/www/app/common/uploads/mount.log

    # Impor custom phases
    source /amos-service-one-time.sh

    # End first setup
    echo "DONE" > $CONFIGFILE

    # Debug message
    echo "Configuration Completed FIRST TIME SETUP"
fi

# Force  stop services
echo "Force-stop Services"
systemctl disable apache2.service
service apache2 stop

# Impor custom phases
echo "Phase Two"
source /amos-service-phase-two.sh

exec supervisord -n