#!/bin/bash

role=${CONTAINER_ROLE:-app}

if [ "$role" = "app" ]; then

    php-fpm

elif [ "$role" = "queue" ]; then

    echo "Running the queue..."
    php artisan queue:work --verbose --tries=3 --timeout=90

elif [ "$role" = "scheduler" ]; then

    while [ true ]
    do
      php artisan schedule:run --verbose --no-interaction &
      sleep 5
    done

else
    echo "Could not match the container role \"$role\""
    exit 1
fi