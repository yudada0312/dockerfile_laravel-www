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
      t=`date +%-S`
      if [ $(($t%10)) = "0" ]; then
        date +"%Y-%m-%d %T"
        php artisan schedule:run &
        sleep 10
        else
        sleep 1
      fi
    done

else
    echo "Could not match the container role \"$role\""
    exit 1
fi