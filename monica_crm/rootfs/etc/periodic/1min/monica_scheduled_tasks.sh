#!/bin/sh

date >> /share/cron.log
/usr/bin/php81 /var/www/monica/artisan schedule:run >> /share/cron.log 2>&1