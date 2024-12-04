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
    echo "$(date '+%Y-%m-%d %H:%M:%S') - google-fluentd no está instalado. Procediendo a instalarlo..." >> /var/log/bims_boot.log

    # Descargar el script para agregar el repositorio de logging agent
    curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Se ha descargado el script para agregar el repositorio de logging agent." >> /var/log/bims_boot.log

    # Ejecutar el script para agregar el repositorio
    bash add-logging-agent-repo.sh
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Se ha agregado el repositorio de logging agent." >> /var/log/bims_boot.log

    # Instalar google-fluentd
    yum install -y google-fluentd
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Se ha instalado google-fluentd." >> /var/log/bims_boot.log

    # Iniciar el servicio google-fluentd
    systemctl start google-fluentd
    echo "$(date '+%Y-%m-%d %H:%M:%S') - google-fluentd se ha instalado y se ha iniciado correctamente." >> /var/log/bims_boot.log
else
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



