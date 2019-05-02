#!/bin/bash

role=${CONTAINER_ROLE:-app}

if [ "$role" = "app" ]; then

    php-fpm

elif [ "$role" = "queue" ]; then

    echo "Running the queue..."
    php artisan queue:work --verbose --tries=3 --timeout=90

elif [ "$role" = "scheduler" ]; then
    echo "Running the scheduler..."
    echo "* * * * *  cd $WORKDIR && php artisan schedule:run >> /var/schedule.log 2>&1" >> /etc/crontabs/root
    crond
    cd /var/ && touch schedule.log
    tail -f /var/schedule.log
else
    echo "Could not match the container role \"$role\""
    exit 1
fi