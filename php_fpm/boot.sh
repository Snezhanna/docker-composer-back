#!/usr/bin/env bash

/usr/local/bin/composer.phar install -d /var/www/html
/usr/local/bin/composer.phar dump-autoload -d /var/www/html

vars='\$REMOTE_DEBUG_HOST \$REMOTE_DEBUG_PORT \$FILE_SIZE_MAX'

export REMOTE_DEBUG_HOST=${REMOTE_DEBUG_HOST} \
       REMOTE_DEBUG_PORT=${REMOTE_DEBUG_PORT} \
       FILE_SIZE_MAX=${FILE_SIZE_MAX}

envsubst "$vars" < "/usr/local/etc/php/conf.d/99-xdebug.ini.tpl" > "/usr/local/etc/php/conf.d/99-xdebug.ini"
envsubst "$vars" < "/usr/local/etc/php/php.ini-development.tpl" > "/usr/local/etc/php/php.ini-development"
envsubst "$vars" < "/usr/local/etc/php/php.ini-production.tpl" > "/usr/local/etc/php/php.ini-production"
envsubst "$vars" < "/usr/local/etc/php-fpm.conf.tpl" > "/usr/local/etc/php-fpm.conf"

php artisan migrate

/usr/sbin/start-cron.sh
php-fpm --allow-to-run-as-root
