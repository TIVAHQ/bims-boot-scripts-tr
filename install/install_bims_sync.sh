#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando key para rsync" >> /var/log/bims_boot.log
# rm -rf /root/rsync;
# Se crea el directorio /root/rsync si no existe
# mkdir -p /root/rsync;
# Se copian los archivos de configuración de rsync
rm -rf /root/rsync/rsync;
cp -f $BOOT_SCRIPTS_PATH/rsync/exclusions.txt /root/rsync/exclusions.txt;

cp -R $BOOT_SCRIPTS_PATH/rsync /root/rsync;
chmod 600 /root/rsync/rsync_key

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando comando bims_sync" >> /var/log/bims_boot.log
cp -f $BOOT_SCRIPTS_PATH/sbin/bims_sync /usr/sbin/bims_sync;
chmod 755 /usr/sbin/bims_sync;