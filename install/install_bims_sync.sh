#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando comando bims_sync" >> /var/log/bims_boot.log
cp -f $BOOT_SCRIPTS_PATH/sbin/bims_sync /usr/sbin/bims_sync;
chmod 755 /usr/sbin/bims_sync;