#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts-tr"

# Si existe una diferencia entre los archivos $BOOT_SCRIPTS_PATH/cron/bims_boot y /etc/cron.d/bims_boot, se actualiza el cron
if [ -f /etc/cron.d/bims_boot ]; then
    diff $BOOT_SCRIPTS_PATH/cron/bims_boot /etc/cron.d/bims_boot > /dev/null;
    if [ $? -ne 0 ]; then
        cp -f $BOOT_SCRIPTS_PATH/cron/bims_boot /etc/cron.d/;
        systemctl restart crond;
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Se actualizó el cron" >> /var/log/bims_boot.log
    fi
fi

# cp -f $BOOT_SCRIPTS_PATH/cron/bims_boot /etc/cron.d/;

# # Se desinstalan crons que se ejecutarán directo en g2
# rm -f /etc/cron.d/getbims;
# rm -f /etc/cron.d/certbot;
# rm -f /etc/cron.d/saas_sama2;
# rm -f /etc/cron.d/backups_clientes;
# rm -f /etc/cron.d/gcloud;

# systemctl restart crond;
# echo "$(date '+%Y-%m-%d %H:%M:%S') - Se actualizó el cron" >> /var/log/bims_boot.log
