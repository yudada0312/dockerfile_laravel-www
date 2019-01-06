#!/bin/bash

role=${CONTAINER_ROLE:-app}

if [ "$role" = "app" ]; then

    php /var/www/artisan serve --port=80 --host=0.0.0.0

elif [ "$role" = "queue" ]; then

    echo "Running the queue..."
    php /var/www/artisan queue:work --verbose --tries=3 --timeout=90

elif [ "$role" = "scheduler" ]; then

    while [ true ]
    do
      php /var/www/artisan schedule:run --verbose --no-interaction &
      sleep 60
    done

else
    echo "Could not match the container role \"$role\""
    exit 1
fi
