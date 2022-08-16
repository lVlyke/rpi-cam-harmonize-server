#!/bin/bash

# Load config values from `.syncrc`
source /var/www/.syncrc 

# Initialize the log file:
rm -f "${picam_log_file}"
touch "${picam_log_file}"

# Kill previous Harmonize instances:
current_instances="$(screen -ls | grep hue-sync-tty)"

if [[ -n "${current_instances}" ]]
then screen -ls | grep hue-sync-tty | cut -d. -f1 | awk '{print $1}' | xargs kill
fi

# Compute the launch args for Harmonize from the specified config values in `.syncrc`:
frame_delay="$(printf %.0f $(bc -l <<< "1 / ${picam_stream_fps} * 1000000"))"
launch_args="cd /var/www/HarmonizeProject/ && python3 ./harmonize.py --stream_filename ${picam_stream_src}${frame_delay}"

if [[ -n "${picam_bridge_ip}" ]]
then launch_args="${launch_args} --bridgeip ${picam_bridge_ip}"
fi

if [[ -n "${picam_group_id}" ]]
then launch_args="${launch_args} --groupid ${picam_group_id}"
fi

if [[ -n "${picam_stream_init_delay}" ]]
then launch_args="${launch_args} --cam_init_delay ${picam_stream_init_delay}"
fi

launch_args="${launch_args}; exec bash"

# Start Harmonize with the specified launch args
echo "Starting up Harmonize server..." > "${picam_log_file}"
screen -L -Logfile "${picam_log_file}" -dmS hue-sync-tty bash -c "${launch_args}"