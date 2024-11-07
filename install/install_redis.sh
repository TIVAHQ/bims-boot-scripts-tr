#!/bin/bash

REDIS_HOST="10.158.0.9"
REDIS_PORT="6379"

# Archivo de log
LOG_FILE="/var/log/bims_boot.log"

# Bandera para indicar si se necesita reiniciar Apache
RESTART_NEEDED=0

# Verificar e instalar Redis si no está instalado
if ! rpm -q redis &>/dev/null; then
    echo "Instalando Redis..."
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando redis" >> $LOG_FILE
    yum install redis -y
else
    echo "Redis ya está instalado."
fi

# Verificar e instalar php-redis si no está instalado
if ! php -m | grep -q "^redis$"; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando php-redis" >> $LOG_FILE
    yum install php-redis -y
else
    echo "php-redis ya está instalado."
fi

# # Verificar y configurar Redis como manejador de sesiones en php.ini
# if ! grep -q "^session.save_handler = redis$" /etc/php.ini; then
#     echo "Configurando php.ini para usar Redis como manejador de sesiones..."
#     echo "$(date '+%Y-%m-%d %H:%M:%S') - Configurando php.ini para usar Redis como manejador de sesiones" >> $LOG_FILE

#     # Asegurar que la configuración de session.save_handler exista y sea redis
#     if grep -q "^session.save_handler" /etc/php.ini; then
#         sed -i 's/^session.save_handler = .*/session.save_handler = redis/' /etc/php.ini
#     else
#         echo "session.save_handler = redis" >> /etc/php.ini
#     fi

#     # Asegurar que session.save_path esté configurado correctamente
#     if grep -q "^session.save_path" /etc/php.ini; then
#         sed -i 's|^session.save_path = .*|session.save_path = "tcp://'"$REDIS_HOST"':'"$REDIS_PORT"'"|' /etc/php.ini
#     else
#         echo 'session.save_path = "tcp://'"$REDIS_HOST"':'"$REDIS_PORT"'"' >> /etc/php.ini
#     fi

#     # Señalar que se necesita reiniciar Apache
#     RESTART_NEEDED=1
#     echo "$(date '+%Y-%m-%d %H:%M:%S') - Se aplicaron cambios en php.ini para Redis." >> $LOG_FILE
# else
#     echo "Redis ya está configurado como manejador de sesiones en php.ini."
# fi

# Archivo de configuración de Apache
CONFIG_FILE="/etc/httpd/conf.d/php.conf"

# Eliminar líneas con "session.save_handler" o "session.save_path"
if grep -Eq "session.save_handler|session.save_path" "$CONFIG_FILE"; then
    sed -i '/session.save_handler/d' "$CONFIG_FILE"
    sed -i '/session.save_path/d' "$CONFIG_FILE"
    echo "Líneas con 'session.save_handler' o 'session.save_path' eliminadas en $CONFIG_FILE"
    RESTART_NEEDED=1
else
    echo "No se encontraron líneas con 'session.save_handler' o 'session.save_path' en $CONFIG_FILE"
fi

# Reiniciar Apache solo si hubo cambios
if [ $RESTART_NEEDED -eq 1 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Reiniciando Apache para aplicar cambios en la configuración." >> $LOG_FILE
    systemctl restart httpd
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - No se detectaron cambios, no se reiniciará Apache." >> $LOG_FILE
fi
