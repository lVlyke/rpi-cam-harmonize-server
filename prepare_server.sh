#!/bin/bash

server_home="/var/www"

# Add needed plumbing between RPi-Cam-Web-Interface and HarmonizeProject
if [ -n "$( ls -A './HarmonizeProject' )" ]; then
  sudo mkdir -p "${server_home}/HarmonizeProject"
  sudo cp -rf ./HarmonizeProject/* "${server_home}/HarmonizeProject"
  sudo chgrp www-data "${server_home}/HarmonizeProject"
  sudo chmod g+rwx "${server_home}/HarmonizeProject"
  
  # Copy config + needed scripts to server_home
  sudo rm -f "${server_home}/.syncrc"
  sudo ln -s "$(pwd)/.syncrc" "${server_home}/.syncrc"
  sudo cp ./start_hue_sync.sh "${server_home}/start_hue_sync.sh"
  sudo cp ./stop_hue_sync.sh "${server_home}/stop_hue_sync.sh"
  sudo cp ./kill_hue_sync.sh "${server_home}/kill_hue_sync.sh"
fi

# Add controls for starting/stopping sync from server UI
sudo mkdir -p "${server_home}/macros"
sudo cp -rf ./www/* "${server_home}"