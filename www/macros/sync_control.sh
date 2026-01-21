#!/bin/bash

cd /var/www

# Load config
source .syncrc

# Check if client is remote
if [ -n "${picam_client_host}" ]; then
  ssh_args="-o "StrictHostKeyChecking=no" -p ${picam_client_port}"
  if [[ -n "${picam_client_keyfile}" ]]
    then ssh_args="${ssh_args} -i ${picam_client_keyfile}"
  fi

  # SSH to client and run the command:
  /bin/bash -c "ssh ${ssh_args} ${picam_client_user}@${picam_client_host} \"${picam_client_home}/$1.sh\""
else
  # Run the command as the client:
  ./$1.sh
fi