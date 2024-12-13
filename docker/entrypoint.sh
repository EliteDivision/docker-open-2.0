#!/usr/bin/env bash

# Exit immediately on non-zero return codes.
set -e

# Move to Application directory
cd /var/www/app/

# Fix custom scripts
dos2unix /service/*.sh > /dev/null 2>&1

# Impor custom phases
for f in /service/*.sh; do source $f; done

# Supervisor is the service manager
exec supervisord -n -c /etc/supervisor/supervisord.conf