#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando comando bims_cron_1" >> /var/log/bims_boot.log
cp -f $BOOT_SCRIPTS_PATH/sbin/bims_cron_1 /usr/sbin/bims_cron_1;
chmod 755 /usr/sbin/bims_cron_1;
echo "$(date '+%Y-%m-%d %H:%M:%S') - Añadiendo bims_cron_1 al cron" >> /var/log/bims_boot.log
echo "* * * * * root /usr/sbin/bims_cron_1" >> /etc/crond.d/bims_cron_1;