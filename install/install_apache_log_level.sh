#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"

# Se verifica si existe el archivo /etc/httpd/conf.d/log_level.conf
if [ ! -f "/etc/httpd/conf.d/log_level.conf" ]; then
    touch /etc/httpd/conf.d/log_level.conf
fi;

# Si difiere del archivo de configuración, se reemplaza
if ! diff -q /etc/httpd/conf.d/log_level.conf $BOOT_SCRIPTS_PATH/etc/httpd/conf.d/log_level.conf &>/dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando el LogLevel de Apache" >> /var/log/bims_boot.log
    cp -f $BOOT_SCRIPTS_PATH/etc/httpd/conf.d/log_level.conf /etc/httpd/conf.d/log_level.conf
    killall -9 httpd
    systemctl restart httpd
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - El LogLevel de Apache ya está actualizado" >> /var/log/bims_boot.log
fi