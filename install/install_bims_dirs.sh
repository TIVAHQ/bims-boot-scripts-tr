#!/bin/bash

MOUNT_POINT="/mnt/bims-bucket-1/saas/tmp/upload"
SYMLINK_PATH="/var/www/vhosts/bims.app/public/app/tmp/upload"
SLEEP_INTERVAL=10

# while true; do
#     if mountpoint -q $(dirname "$MOUNT_POINT") && [ -d "$MOUNT_POINT" ]; then
        rm -rf "$SYMLINK_PATH"
        ln -s "$MOUNT_POINT" "$SYMLINK_PATH"
        chmod 777 "$SYMLINK_PATH"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Se instaló $SYMLINK_PATH > $MOUNT_POINT" >> /var/log/bims_boot.log
#         break
#     else
#         sleep "$SLEEP_INTERVAL"
#     fi
# done

# rm -rf /var/www/vhosts/bims.app/public/app/tmp/upload;
# ln -s /mnt/bims-bucket-1/saas/tmp/upload /var/www/vhosts/bims.app/public/app/tmp/upload;
# chmod 777 /var/www/vhosts/bims.app/public/app/tmp/upload;

# rm -rf /var/www/vhosts/bims.app/public/app/tmp/logs;
# ln -s /mnt/bims-bucket-1/saas/tmp/logs /var/www/vhosts/bims.app/public/app/tmp/logs;
# chmod 777 /var/www/vhosts/bims.app/public/app/tmp/logs;

if [ -L "/var/www/vhosts/bims.app/public/app/tmp/logs" ]; then
    rm -rf /var/www/vhosts/bims.app/public/app/tmp/logs;
    mkdir /var/www/vhosts/bims.app/public/app/tmp/logs;
    chmod 777 /var/www/vhosts/bims.app/public/app/tmp/logs;
fi

# rm -f /var/www/vhosts/bims.app/public/app/tmp/cache/models/*;
# rm -f /var/www/vhosts/bims.app/public/app/tmp/cache/persistent/*;

# dummy