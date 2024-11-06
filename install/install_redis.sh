#!/bin/bash

REDIS_HOST="10.158.0.9"
REDIS_PORT="6379"

# Archivo de log
LOG_FILE="/var/log/bims_boot.log"
touch $LOG_FILE
chmod 644 $LOG_FILE

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

# Verificar y configurar Redis como manejador de sesiones en php.ini
if ! grep -q "^session.save_handler = redis$" /etc/php.ini; then
    echo "Configurando php.ini para usar Redis como manejador de sesiones..."
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Configurando php.ini para usar Redis como manejador de sesiones" >> $LOG_FILE

    # Asegurar que la configuración de session.save_handler exista y sea redis
    if grep -q "^session.save_handler" /etc/php.ini; then
        sed -i 's/^session.save_handler = .*/session.save_handler = redis/' /etc/php.ini
    else
        echo "session.save_handler = redis" >> /etc/php.ini
    fi

    # Asegurar que session.save_path esté configurado correctamente
    if grep -q "^session.save_path" /etc/php.ini; then
        sed -i 's|^session.save_path = .*|session.save_path = "tcp://'"$REDIS_HOST"':'"$REDIS_PORT"'"|' /etc/php.ini
    else
        echo 'session.save_path = "tcp://'"$REDIS_HOST"':'"$REDIS_PORT"'"' >> /etc/php.ini
    fi

    # Señalar que se necesita reiniciar Apache
    RESTART_NEEDED=1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Se aplicaron cambios en php.ini para Redis." >> $LOG_FILE
else
    echo "Redis ya está configurado como manejador de sesiones en php.ini."
fi

# Archivo de configuración de Apache
CONFIG_FILE="/etc/httpd/conf.d/php.conf"

# Líneas a buscar y comentar
LINE1='php_value session.save_handler "files"'
LINE2='php_value session.save_path "/var/lib/php/session"'

# Función para comentar una línea si no está comentada
comment_line_if_uncommented() {
    local line="$1"
    local file="$2"
    # Verifica si la línea existe sin comentar y la comenta si es necesario
    if grep -Fxq "$line" "$file"; then
        sed -i "s|^$line|# $line|" "$file"
        echo "Comentada la línea: $line"
        RESTART_NEEDED=1
    else
        echo "La línea ya está comentada o no existe: $line"
    fi
}

# Comentar las líneas si es necesario
comment_line_if_uncommented "$LINE1" "$CONFIG_FILE"
comment_line_if_uncommented "$LINE2" "$CONFIG_FILE"

# Reiniciar Apache solo si hubo cambios
if [ $RESTART_NEEDED -eq 1 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Reiniciando Apache para aplicar cambios en la configuración." >> $LOG_FILE
    systemctl restart httpd
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - No se detectaron cambios, no se reiniciará Apache." >> $LOG_FILE
fi
