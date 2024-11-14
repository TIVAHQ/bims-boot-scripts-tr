#!/bin/bash

rm -rf /var/www/vhosts/bims.app/public/app/tmp/upload;
ln -s /mnt/bims-bucket-1/saas/tmp/upload /var/www/vhosts/bims.app/public/app/tmp/upload;
chmod 777 /var/www/vhosts/bims.app/public/app/tmp/upload;

rm -rf /var/www/vhosts/bims.app/public/app/tmp/logs;
ln -s /mnt/bims-bucket-1/saas/tmp/logs /var/www/vhosts/bims.app/public/app/tmp/logs;
chmod 777 /var/www/vhosts/bims.app/public/app/tmp/logs;
