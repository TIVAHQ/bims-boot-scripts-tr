#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando watchdog del bucket de Google Cloud Storage" >> /var/log/bims_boot.log
cp -f $BOOT_SCRIPTS_PATH/sbin/bims_check_cloud_storage /usr/sbin/bims_check_cloud_storage;
chmod 755 /usr/sbin/bims_check_cloud_storage;