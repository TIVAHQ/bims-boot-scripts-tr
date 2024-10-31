#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando comando bims_update_boot_scripts" >> /var/log/bims_boot.log
cp -f $BOOT_SCRIPTS_PATH/sbin/bims_update_boot_scripts /usr/sbin/bims_update_boot_scripts;
chmod 755 /usr/sbin/bims_update_boot_scripts;