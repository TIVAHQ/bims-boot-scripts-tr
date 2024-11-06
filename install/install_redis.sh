#!/bin/bash

REDIS_HOST="10.158.0.9"
REDIS_PORT="6379"

# Archivo de log
LOG_FILE="/var/log/bims_boot.log"
touch $LOG_FILE
chmod 644 $LOG_FILE

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

    # Reiniciar el servicio httpd para aplicar los cambios
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Reiniciando Apache para aplicar configuración de Redis" >> $LOG_FILE
    systemctl restart httpd
else
    echo "Redis ya está configurado como manejador de sesiones en php.ini."
fi


