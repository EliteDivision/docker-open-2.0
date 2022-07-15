#!/usr/bin/env bash

# Exit immediately on non-zero return codes.
set -e

# Move to Application directory
cd /var/www/app/

# Impor custom phases
for f in /service/; do source $f; done

# Supervisor is the service manager
exec supervisord -n