#!/bin/bash

# Install RPi-Cam-Web-Interface
cd ./RPi_Cam_Web_Interface
./install.sh
cd ../

# Install HarmonizeProject deps
sudo apt-get update
sudo apt-get install -y screen bc python3-pip python3-dev python3-numpy python3-opencv libpython3-all-dev
pip3 install http-parser zeroconf termcolor

sudo chgrp www-data /var/www
sudo chmod g+rwx /var/www
sudo -H -u www-data bash -c "pip3 install http-parser zeroconf termcolor"

# Add needed plumbing between RPi-Cam-Web-Interface and HarmonizeProject
./apply.sh