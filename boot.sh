#!/bin/bash

echo "$(date '+%Y-%m-%d %H:%M:%S') - Boot Script Iniciado" >> /var/log/bims_boot.log

BOOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

############################################################################################################
# Se instala el key para rsync
echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando key para rsync" >> /var/log/bims_boot.log
rm -rf /root/rsync;
cp -R ./rsync /root/rsync;
############################################################################################################

############################################################################################################
# Se instala el comando bims_sync
echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando comando bims_sync" >> /var/log/bims_boot.log
cp -f ./sbin/bims_sync /usr/sbin/bims_sync;
chmod 755 /usr/sbin/bims_sync;
############################################################################################################

############################################################################################################
# Se añade la ejecución del comando bims_sync al cron cada 5 minutos
echo "$(date '+%Y-%m-%d %H:%M:%S') - Añadiendo bims_sync al cron" >> /var/log/bims_boot.log
echo "*/5 * * * * root /usr/sbin/bims_sync";
############################################################################################################

############################################################################################################
# Se instala el comando bims_cron_1 y se programa su ejecución cada 1 minuto
echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando comando bims_cron_1" >> /var/log/bims_boot.log
cp -f ./sbin/bims_cron_1 /usr/sbin/bims_cron_1;
chmod 755 /usr/sbin/bims_cron_1;
echo "$(date '+%Y-%m-%d %H:%M:%S') - Añadiendo bims_cron_1 al cron" >> /var/log/bims_boot.log
echo "* * * * * root /usr/sbin/bims_cron_1";
############################################################################################################

echo "$(date '+%Y-%m-%d %H:%M:%S') - Boot Script Finalizado" >> /var/log/bims_boot.log
