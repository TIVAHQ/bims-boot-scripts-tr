#!/bin/bash

LOG_FILE="/var/log/bims_boot.log"
BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Boot Script Iniciado" >> $LOG_FILE

############################################################################################################
# Se instala redis (incluir luego en el servidor modelo)
# bash $BOOT_SCRIPTS_PATH/install/install_redis.sh
############################################################################################################

############################################################################################################
# Se actualiza php.ini
# bash $BOOT_SCRIPTS_PATH/install/install_phpini.sh
############################################################################################################

############################################################################################################
# Se instala el comando bims_sync
# bash $BOOT_SCRIPTS_PATH/install/install_bims_sync.sh
############################################################################################################

############################################################################################################
# Se instala el watchdog del bucket de Google Cloud Storage
# bash $BOOT_SCRIPTS_PATH/install/install_bims_check_cloud_storage.sh
############################################################################################################

############################################################################################################
# Se instala app/tmp/upload en Google Cloud Storage
# bash $BOOT_SCRIPTS_PATH/install/install_bims_dirs.sh
############################################################################################################

############################################################################################################
# Se instala el actualizado del script de booteo
# bash $BOOT_SCRIPTS_PATH/install/install_bims_update_boot_scripts.sh
############################################################################################################

############################################################################################################
# Se instala el comando bims_cron_1 y se programa su ejecución cada 1 minuto
# ˝bash $BOOT_SCRIPTS_PATH/install/install_bims_cron.sh
############################################################################################################

############################################################################################################
# Se baja mysqld
killall -9 mysqld
# [ "$(hostname)" == "saas-web2-r0nf" ] && killall -9 httpd && systemctl restart httpd
# service httpd restart;
############################################################################################################

############################################################################################################
# Se instala Google Cloud Logging
bash $BOOT_SCRIPTS_PATH/install/install_gc_logging.sh

rm -rf /var/www/vhosts/secure.bimsapp.com/public/app/tmp/cache/models/*
rm -rf /var/www/vhosts/secure.bimsapp.com/public/app/tmp/cache/persistent/*

echo "$(date '+%Y-%m-%d %H:%M:%S') - Boot Script Finalizado" >> /var/log/bims_boot.log
