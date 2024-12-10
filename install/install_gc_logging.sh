#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"

# Directorio de configuración de google-fluentd
DIR="/etc/google-fluentd/config.d/"

# Archivo de configuración de google-fluentd
DEST_FILE="$DIR/bims.conf"

# Archivo fuente de configuración de google-fluentd
SOURCE_FILE="$BOOT_SCRIPTS_PATH/etc/google-fluentd/bims.conf"

LOG_FILE="/var/log/bims_boot.log"

# Verificar si google-fluentd está instalado
if ! command -v google-fluentd &> /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - google-fluentd no está instalado. Procediendo a instalarlo..." >> "$LOG_FILE"

    # Descargar el script para agregar el repositorio de logging agent
    curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Se ha descargado el script para agregar el repositorio de logging agent." >> "$LOG_FILE"

    # Ejecutar el script para agregar el repositorio
    bash add-logging-agent-repo.sh
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Se ha agregado el repositorio de logging agent." >> "$LOG_FILE"

    # Instalar google-fluentd y esperar su finalización
    if yum install -y google-fluentd >> "$LOG_FILE" 2>&1; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Se ha instalado google-fluentd." >> "$LOG_FILE"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Error al instalar google-fluentd." >> "$LOG_FILE"
        exit 1
    fi

    # Iniciar el servicio google-fluentd y esperar a que esté activo
    systemctl start google-fluentd
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Intentando iniciar google-fluentd." >> "$LOG_FILE"
    if ! systemctl is-active --quiet google-fluentd; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - El servicio google-fluentd no pudo iniciarse correctamente." >> "$LOG_FILE"
        exit 1
    fi
    echo "$(date '+%Y-%m-%d %H:%M:%S') - google-fluentd se ha instalado y se ha iniciado correctamente." >> "$LOG_FILE"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - google-fluentd ya está instalado." >> "$LOG_FILE"
fi

# Verificar si el archivo ya existe
if ! diff -q $DEST_FILE $SOURCE_FILE &>/dev/null; then
    rm -f "$DEST_FILE"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - El archivo $DEST_FILE tiene modificaciones. Procediendo a reemplazarlo desde $SOURCE_FILE..." >> "$LOG_FILE"

    # Crear el directorio si no existe
    if [ ! -d "$DIR" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - El directorio $DIR no existe. Creándolo..." >> "$LOG_FILE"
        mkdir -p "$DIR"
    fi

    # Copiar el archivo
    if [ -f "$SOURCE_FILE" ]; then
        cp "$SOURCE_FILE" "$DEST_FILE"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Archivo copiado correctamente a $DEST_FILE." >> "$LOG_FILE"

        # Reiniciar el servicio google-fluentd y esperar a que esté activo
        systemctl restart google-fluentd
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Intentando reiniciar google-fluentd." >> "$LOG_FILE"
        if ! systemctl is-active --quiet google-fluentd; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - El servicio google-fluentd no pudo iniciarse correctamente." >> "$LOG_FILE"
            exit 1
        fi
        echo "$(date '+%Y-%m-%d %H:%M:%S') - google-fluentd se ha reiniciado correctamente." >> "$LOG_FILE"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - El archivo fuente $SOURCE_FILE no existe. No se pudo copiar." >> "$LOG_FILE"
    fi
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - El archivo $DEST_FILE se encuentra actualizado." >> "$LOG_FILE"
fi
