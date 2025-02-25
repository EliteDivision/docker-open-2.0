if [ "$ENABLE_SHIBD" = "false" ] ; then
    rm /etc/supervisor/conf.d/shibd.conf
else
    # Setup AppID
    sed -i "s/SP_FRONTEND_ID/${SP_FRONTEND_ID}/" /etc/apache2/sites-available/000-default.conf
    sed -i "s/SP_FRONTEND_IAM_ID/${SP_FRONTEND_IAM_ID}/" /etc/apache2/sites-available/000-default.conf

    sed -i "s/SP_BACKEND_ID/${SP_BACKEND_ID}/" /etc/apache2/sites-available/000-default.conf
    sed -i "s/SP_BACKEND_IAM_ID/${SP_BACKEND_IAM_ID}/" /etc/apache2/sites-available/000-default.conf

    #Reset Service (thanks debian...)
    service shibd restart
    service shibd stop
fi