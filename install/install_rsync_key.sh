#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando key para rsync" >> /var/log/bims_boot.log
rm -rf /root/rsync;
cp -R $BOOT_SCRIPTS_PATH/rsync /root/rsync;