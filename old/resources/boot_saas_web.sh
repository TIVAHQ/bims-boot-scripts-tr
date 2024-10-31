#!/bin/bash

#########################################################################################################
GITHUB_TOKEN="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"; # Expira el Domingo 15 de Diciembre de 2024
REPO_URL="https://$GITHUB_TOKEN@github.com/TIVAHQ/bims.git"
WEB_DIR="/var/www/vhosts/bims.app/public";
IMG_UPLOAD_DIR="/mnt/g2_upload";
BOOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
#########################################################################################################

#########################################################################################################
# Se actualizan los archivos
if [ ! -d "$WEB_DIR" ]; then
    echo "El directorio $WEB_DIR no existe. Creando directorios..."
    mkdir -p $WEB_DIR
    git clone $REPO_URL $WEB_DIR
else
    cd $WEB_DIR
    echo "Haciendo git pull..."
    if git pull origin main; then
        echo "Git pull exitoso."
    else
        echo "Error al hacer git pull."
        exit 1
    fi
fi
#########################################################################################################

#########################################################################################################
# REEEMPLAZAR ESTE ENFOQUE POR NFS
# Se monta el directorio remoto via sshfs
# Si no existe el directorio IMG_UPLOAD_DIR, se crea
if [ ! -d $IMG_UPLOAD_DIR ]; then
  mkdir $IMG_UPLOAD_DIR;
fi;
if mountpoint -q $IMG_UPLOAD_DIR; then
    umount $IMG_UPLOAD_DIR;
fi
sshfs -o allow_other,default_permissions root@10.158.0.9:/mnt/g2-hd2/bims.app/img_upload /mnt/g2_upload
#########################################################################################################

#########################################################################################################
# Se asignan los permisos de escritura a las carpetas necesarias
chmod 777 $WEB_DIR/app/tmp -R;
chmod 777 $WEB_DIR/app/upload -R;
chmod 777 $WEB_DIR/app/webroot/img/upload -R;
chmod 755 $WEB_DIR/cake/console/cake;
#########################################################################################################

#########################################################################################################
# Se configura el servidor WEB Apache
cp $BOOT_DIR/resources/apache/bims.app.conf /etc/httpd/conf.d/;
mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.backup;
cp $BOOT_DIR/resources/apache/httpd.conf /etc/httpd/conf/;
mkdir -p /etc/httpd/ssl/bims.app/;
systemctl restart httpd;
#########################################################################################################