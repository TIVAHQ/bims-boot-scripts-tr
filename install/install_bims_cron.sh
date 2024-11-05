#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"
cp -f $BOOT_SCRIPTS_PATH/cron/bims_boot /etc/cron.d/;

# Se desinstalan crons que se ejecutarán directo en g2
rm -f /etc/cron.d/getbims;
rm -f /etc/cron.d/certbot;
rm -f /etc/cron.d/saas_sama2;
rm -f /etc/cron.d/backups_clientes;
rm -f /etc/cron.d/gcloud;

systemctl restart crond;
echo "$(date '+%Y-%m-%d %H:%M:%S') - Se ha instalado el comando bims_boot" >> /var/log/bims_boot.log
