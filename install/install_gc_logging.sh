#!/bin/bash

BOOT_SCRIPTS_PATH="/opt/install/bims-boot-scripts"

# Directorio de configuración de google-fluentd
DIR="/etc/google-fluentd/config.d/"

# Archivo de configuración de google-fluentd
DEST_FILE="$DIR/bims.conf"

# Archivo fuente de configuración de google-fluentd
SOURCE_FILE="$BOOT_SCRIPTS_PATH/etc/google-fluentd/bims.conf"

# Verificar si google-fluentd está instalado
if ! command -v google-fluentd &> /dev/null; then
    echo "google-fluentd no está instalado. Procediendo a instalarlo..."
    echo "$(date '+%Y-%m-%d %H:%M:%S') - google-fluentd no está instalado. Procediendo a instalarlo..." >> /var/log/bims_boot.log

    # Descargar el script para agregar el repositorio de logging agent
    curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh

    # Ejecutar el script para agregar el repositorio
    sudo bash add-logging-agent-repo.sh

    # Instalar google-fluentd
    sudo yum install -y google-fluentd

    # Iniciar el servicio google-fluentd
    sudo systemctl start google-fluentd

    echo "google-fluentd se ha instalado y se ha iniciado correctamente."
    echo "$(date '+%Y-%m-%d %H:%M:%S') - google-fluentd se ha instalado y se ha iniciado correctamente." >> /var/log/bims_boot.log
else
    echo "google-fluentd ya está instalado."
    echo "$(date '+%Y-%m-%d %H:%M:%S') - google-fluentd ya está instalado." >> /var/log/bims_boot.log
fi




# Verificar si el archivo ya existe
if [ ! -f "$DEST_FILE" ]; then
    echo "El archivo $DEST_FILE no existe. Procediendo a copiarlo desde $SOURCE_FILE..."
    
    # Crear el directorio si no existe
    if [ ! -d "$DIR" ]; then
        echo "El directorio $DIR no existe. Creándolo..."
        sudo mkdir -p "$DIR"
    fi
    
    # Copiar el archivo
    if [ -f "$SOURCE_FILE" ]; then
        sudo cp "$SOURCE_FILE" "$DEST_FILE"
        echo "Archivo copiado correctamente a $DEST_FILE."
        sudo systemctl restart google-fluentd
    else
        echo "El archivo fuente $SOURCE_FILE no existe. No se pudo copiar."
    fi
else
    echo "El archivo $DEST_FILE ya existe. No se realizó ninguna acción."
fi



