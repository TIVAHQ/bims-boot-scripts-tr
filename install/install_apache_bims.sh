#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"

# Se verifica si existe el archivo /etc/httpd/conf.d/bims.app.conf
if [ ! -f "/etc/httpd/conf.d/bims.app.conf" ]; then
    touch /etc/httpd/conf.d/bims.app.conf
fi;

# Si difiere del archivo de configuración, se reemplaza
if ! diff -q /etc/httpd/conf.d/bims.app.conf $BOOT_SCRIPTS_PATH/etc/httpd/conf.d/bims.app.conf &>/dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Configurando Apache para bims.app" >> /var/log/bims_boot.log
    rm -f /etc/httpd/conf.d/bims.app.conf
    cp -f $BOOT_SCRIPTS_PATH/etc/httpd/conf.d/bims.app.conf /etc/httpd/conf.d/bims.app.conf
    killall -9 httpd
    systemctl restart httpd
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Configuración de Apache para bims.app ya está actualizada" >> /var/log/bims_boot.log
fi