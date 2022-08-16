#!/bin/bash

current_instances="$(screen -ls | grep hue-sync-tty)"

if [[ -n "${current_instances}" ]]
then screen -ls | grep hue-sync-tty | cut -d. -f1 | awk '{print $1}' | xargs kill
fi
