#!/bin/bash

URL="http://127.0.0.1/ping"
MAX_RETRIES=3
SLEEP_TIME=30
TIMEOUT=10
SUPERVISOR_USER="dummy"
SUPERVISOR_PASS="dummy"

fail_count=0

echo "Starting healthcheck monitor for PHP-FPM..."

sleep 30

while true; do
    sleep $SLEEP_TIME
    
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -m $TIMEOUT "$URL")
    
    if [ "$STATUS_CODE" = "200" ]; then
        if [ $fail_count -gt 0 ]; then
            echo "Healthcheck recovered (Status: $STATUS_CODE)."
            fail_count=0
        fi
    else
        fail_count=$((fail_count+1))
        echo "Healthcheck failed. Status code: ${STATUS_CODE:-TIMEOUT} ($fail_count/$MAX_RETRIES)"
        
        if [ $fail_count -ge $MAX_RETRIES ]; then
            echo "Healthcheck failed $MAX_RETRIES times. Restarting PHP-FPM via supervisor..."
            supervisorctl -u "$SUPERVISOR_USER" -p "$SUPERVISOR_PASS" restart php-fpm
            fail_count=0
            
            sleep 15
        fi
    fi
done
