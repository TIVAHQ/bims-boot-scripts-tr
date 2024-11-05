# bims-boot-scripts
Boot Scripts para Servidores de BIMS SaaS que son creados dinámicamente por el esquema de Load Balancing. Se trata de instrucciones escritas en bash.

## Cómo funcionan
Todos los cambios que se suban a la rama "main" son automáticamente ejecutados en todos los servidores del esquema de backends del sistema de load balancing.

## Archivos

### ./boot.sh
Es el primer archivo que se ejecuta y su primer ejecución se realiza al iniciar el servidor mediante la entrada
```bash
crontab -e
@reboot /usr/sbin/bims_update_boot_scripts
```

### ./install/install_bins_sync.sh
Configura la ejecución de la sincronización de archivos de BIMS desde G2 al nodo del backend mediante rsync.
Instala el comando /usr/sib/bims_sync que ejecuta la sinconización.

### ./install/install_bims_check_cloud_storage.sh
Instala el comando bims_check_cloud_storage, que hace de watchdog del montaje del bucket de Google Cloud Storage, empleado para el almacenamiento y acceso de imágenes y otros archivos subidos a BIMS por los usuarios.

### ./install/install_bims_update_boot_scripts
Instala el comando bims_update_boot_scripts, cuya función es actualizar un clon de este repositorio en el nodo del backend, evaluar si hay cambios en la rama main, y si hubieren cambios, vuelve a ejecutar boot.sh para reinstalar los scripts.

### ./install/install_bims_cron
Instala el cron del sistema de boot definido en ./cron/bims_boot.

### ./cron/bims_boot
Contiene las definiciones del cron para la ejecución períodica de:
- bims_check_cloud_storage
- bims_sync
- bims_update_boot_scripts

### ./rsync/exclusions.txt
Contiene la lista de archivos y directorios que serán excluídos de la sincronización de archivos de BIMS desde G2 al nodo del backend.

### ./rsync/rsync_key
Contiene el key de autenticación SSH utilizado por el rsync

### ./sbin/*
Contiene las definiciones de los comandos que son instalados:
- bims_check_cloud_storage
- bims_sync
- bims_update_boot_scripts
