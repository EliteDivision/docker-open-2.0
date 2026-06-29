if [ "$ENABLE_CRON" = "false" ] ; then
    rm /etc/supervisor/conf.d/cron.conf
fi

# Cron jobs don't inherit the container environment, so inject the audit
# cleanup retention (age in days) into the crontab before cron starts.
sed -i "s|\${AUDIT_CLEANUP_AGE}|${AUDIT_CLEANUP_AGE:-540}|g" /etc/cron.d/global