if [ "$ENABLE_SHIBD" = "false" ] ; then
    rm /etc/supervisor/conf.d/shibd.conf
else
    service shibd restart
    service shibd stop
fi