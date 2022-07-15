if [ "$ENABLE_CRON" = "false" ] ; then
    rm /etc/supervisor/conf.d/cron.conf
fi