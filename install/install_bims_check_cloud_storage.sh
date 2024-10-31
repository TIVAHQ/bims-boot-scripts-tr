#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando watchdog del bucket de Google Cloud Storage" >> /var/log/bims_boot.log
cp -f ./sbin/bims_check_cloud_storage /usr/sbin/bims_check_cloud_storage;
chmod 755 /usr/sbin/bims_check_cloud_storage;
echo "$(date '+%Y-%m-%d %H:%M:%S') - Añadiendo bims_check_cloud_storage al cron" >> /var/log/bims_boot.log
echo "* * * * * root /usr/sbin/bims_check_cloud_storage >> /var/log/check_mount.log 2>&1" >> /etc/crond.d/bims_check_cloud_storage;