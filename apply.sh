#!/bin/bash

sudo mkdir -f /var/www/HarmonizeProject
sudo cp -rf ./HarmonizeProject/* /var/www/HarmonizeProject
sudo chgrp www-data /var/www/HarmonizeProject
sudo chmod g+rwx /var/www/HarmonizeProject

sudo cp ./.syncrc /var/www/.syncrc
sudo mkdir -f /var/www/macros
sudo cp -rf ./www/* /var/www
