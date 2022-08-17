#!/bin/bash

server_home="/var/www"

sudo mkdir -p "${server_home}/HarmonizeProject"
sudo cp -rf ./HarmonizeProject/* "${server_home}/HarmonizeProject"
sudo chgrp www-data "${server_home}/HarmonizeProject"
sudo chmod g+rwx "${server_home}/HarmonizeProject"

sudo cp ./.syncrc "${server_home}/.syncrc"
sudo mkdir -p "${server_home}/macros"
sudo cp -rf ./www/* "${server_home}"
