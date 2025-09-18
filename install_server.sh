#!/bin/bash

# Pull all submodules
git submodule update --init --recursive RPi_Cam_Web_Interface

# Install RPi-Cam-Web-Interface
cd ./RPi_Cam_Web_Interface
echo -e 'rpicamdir=""\nwebserver="apache"\nwebport="80"\nuser=""\nwebpasswd=""\nautostart="yes"\njpglink="no"\n' > ./config.txt
./install.sh q
cd ../

# Update permissions for /var/www
sudo chgrp www-data /var/www
sudo chmod g+rwx /var/www

# Prepare server
./prepare_server.sh