#!/bin/bash

# Pull all submodules
git submodule update --init --recursive

# Install RPi-Cam-Web-Interface
cd ./RPi_Cam_Web_Interface
echo -e 'rpicamdir=""\nwebserver="apache"\nwebport="80"\nuser=""\nwebpasswd=""\nautostart="yes"\njpglink="no"\n' > ./config.txt
./install.sh q
cd ../

# Install HarmonizeProject deps
sudo apt-get update
sudo apt-get install -y screen bc python3-dev python3-numpy python3-opencv python3-http-parser python3-zeroconf python3-termcolor libpython3-all-dev

sudo chgrp www-data /var/www
sudo chmod g+rwx /var/www

# Add needed plumbing between RPi-Cam-Web-Interface and HarmonizeProject
./apply.sh