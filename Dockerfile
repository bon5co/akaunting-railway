# Akaunting 3.1.21 wrapper for Railway.
#
# Wraps the official `-v` image (the variant that keeps the release archive in
# /tmp and unpacks it at runtime only when the webroot is empty, which is what
# makes a Railway volume over /var/www/html work).
#
# Everything the deploy form should not ask for is baked here as ENV: a literal
# defaultValue is dropped by templateGenerate and would publish as a blank
# required field.
# APP_INSTALLED is deliberately NOT baked: with it already true at install time
# CreateCompany::authorize() evaluates plan limits and `php artisan install`
# dies with "Not able to create a new user.". The installer writes
# APP_INSTALLED=true into the .env on the volume, which is what the
# in-container scheduler reads.
FROM akaunting/akaunting:3.1.21-v@sha256:0289239e38f5b21efafb152ae8d828735d38fed8477d4fb277d472f8ea3fde09

ENV APP_ENV=production \
    APP_DEBUG=false \
    APP_NAME=Akaunting \
    APP_LOCALE=en-US \
    APP_SCHEDULE_TIME=09:00 \
    LOG_CHANNEL=stderr \
    DB_CONNECTION=mysql \
    DB_PORT=3306 \
    DB_NAME=akaunting \
    DB_DATABASE=akaunting \
    DB_USERNAME=akaunting \
    DB_PREFIX=ak_ \
    CACHE_DRIVER=file \
    SESSION_DRIVER=file \
    QUEUE_CONNECTION=sync \
    MODEL_CACHE_ENABLED=true \
    FIREWALL_ENABLED=true \
    COMPANY_NAME="My Company" \
    ADMIN_EMAIL=admin@example.com \
    SCHEDULE_INTERVAL=60 \
    TZ=Etc/UTC

COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod +x /usr/local/bin/railway-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
