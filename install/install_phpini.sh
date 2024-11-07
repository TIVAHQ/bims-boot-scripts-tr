BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"
LOG_FILE="/var/log/bims_boot.log"

# Verifica si hay diferencias entre /etc/php.ini y $BOOT_SCRIPTS_PATH/etc/php.ini
if ! diff -q /etc/php.ini $BOOT_SCRIPTS_PATH/etc/php.ini &>/dev/null; then
    echo "Actualizando /etc/php.ini..."
    cp -f $BOOT_SCRIPTS_PATH/etc/php.ini /etc/php.ini
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Se actualizó /etc/php.ini" >> $LOG_FILE
    systemctl restart httpd
else
    echo "/etc/php.ini ya está actualizado."
fi