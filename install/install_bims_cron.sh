#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"
cp -f $BOOT_SCRIPTS_PATH/cron/bims_boot /etc/cron.d/;
systemctl restart crond;
echo "$(date '+%Y-%m-%d %H:%M:%S') - Se ha instalado el comando bims_boot" >> /var/log/bims_boot.log
