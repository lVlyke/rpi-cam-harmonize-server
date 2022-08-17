# rpi-cam-harmonize-server

Turns your Raspberry Pi + Camera into a server that syncs your Philips Hue-compatible lights to your camera.

![Server GUI](/docs/server_gui.png)

# About

This project allows you to use your Raspberry Pi + Camera module (or equivalent) as a highly configurable web server that will sync your Philips Hue lights to your camera. This is achieved by combining together the capabilities of [RPi_Cam_Web_Interface](https://github.com/silvanmelchior/RPi_Cam_Web_Interface) and [HarmonizeProject](https://github.com/MCPCapital/HarmonizeProject).

## Requirements

* Raspberry Pi running Raspberry Pi OS (desktop or lite, tested on RPi Zero and 3B+ running Buster - **32-bit OS only, arm64 not currently supported**)
* Raspberry Pi camera module (or equivalent)
* Philips Hue Bridge with compatible lights

## Installation

Before starting, **please make sure that the legacy camera interface has been enabled on your Raspberry Pi**. You can do this by running `sudo raspi-config` and enabling the camera under `Interface Options`.

First, clone this project onto your Pi (with submodules):

```bash
git clone --recurse-submodules https://github.com/lVlyke/rpi-cam-harmonize-server.git
```

Next, `cd` into the newly created directory and run the `install` script:

```bash
cd ./rpi-cam-harmonize-server
./install.sh
```

This may take a while dependning on your hardware.

## Configuration

All settings are configured via the `.syncrc` file.

**If you modify any of the settings in `.syncrc`, you must run the `apply.sh` script afterward in order for your changes to take effect.**

Below are all settings in `.syncrc` along with their default values:

```bash
picam_stream_src="http://localhost/cam_pic_new.php?pDelay="
picam_stream_fps=25
picam_stream_init_delay=1.5
picam_log_file="/tmp/rpi-cam-harmonize-server.log"
picam_bridge_ip="" # (Optional) Add your Hue bridge IP here
picam_group_id="" # (Optional) Add your entertainment group ID here
```

**picam_stream_src** - The camera stream URL. This does not normally need to be changed.

**picam_stream_fps** - The number of frames per second the camera stream URL will update. This can be increased/decreased depending on your hardware. Defaults to 25.

**picam_stream_init_delay** - The camera stream init delay. This can be increased if you are receiving `rgbframe` errors when starting light sync. See the "Troubleshooting" section below for more info.

**picam_log_file** - The log file. Defaults to `/tmp/rpi-cam-harmonize-server.log`.

**picam_bridge_ip** - (Optional) The IP address of your Hue Bridge. This is only needed when multiple Hue Bridges are on a single network.

**picam_group_id** - (Optional) The group ID of your Hue entertainment group. This is only needed when you have multiple entertainment groups defined.

**If you modify any of the settings in `.syncrc`, you must run the `apply.sh` script afterward in order for your changes to take effect.**

## Running

### Starting the web server

By default, the server will start automatically when booting your Raspberry Pi. To start or stop the server manually, you can use the included `start.sh` and `stop.sh` scripts:

```bash
start.sh
```

This will launch the web server. The GUI can be accessed via your web browser at your Raspberry Pi's IP address and/or hostname:

![Server GUI](/docs/server_gui.png)

If your camera stream is slightly off alignment or needs to be cropped, you can adjust these and many other camera settings through the GUI until the stream output matches what you expect. See the [RPi-Cam-Web-Interface wiki](https://elinux.org/RPi-Cam-Web-Interface) for more information about configuring the camera.

### Starting light sync

Once you can see the server GUI and verify your camera feed is working, you can start the light sync. To do this, simply press the `Start Light Sync` button. This may take a while depending on your hardware.

**NOTE FOR FIRST TIME SETUP: When starting the light sync for the first time, you will need to give your Raspberry Pi permission to control your lights by pressing the button on your Hue Bridge. You can use the following command to watch the server output, which will prompt you to press the button on your bridge when ready:**

```bash
tail -f /tmp/rpi-cam-harmonize-server.log
```

If everything worked correctly, you should now see your lights being synced to the camera input.

### Stopping light sync

To stop the light sync, simply press the `Stop Light Sync` button. The web server can be turned off by running the `stop.sh` command.

## Troubleshooting

### Nothing happens when I click "Start Light Sync"

The first thing you should do is check the log, which by default is saved at `/tmp/rpi-cam-harmonize-server.log`. This will most likely show you what the issue is. 

If the log shows `ERROR: Button press not detected, exiting application`, you need to make sure you press the button on the Hue Bridge at the correct time during first start. The easiest way to do this is to run `tail -f /tmp/rpi-cam-harmonize-server.log` after clicking "Start Light Sync".

If the log shows an error about `w`, `h`, `rgbframe` or other variables, try increasing the `picam_stream_init_delay` value in `.syncrc` and then run `apply.sh` and try again.

### Light sync is slow/lagging behind camera stream

This can be either due to lack of hardware resources or due to network connectivity issues.

First, try lowering the `picam_stream_fps` in `.syncrc`. If you are using a very low powered Pi like the Zero, try starting with 10 FPS and increase/decrease from there to see what is ideal for your hardware.

If lowering the stream FPS has no effect, it may be a network problem. If you are using Wi-Fi, try switching to a wired connection if possible. 

You can also check `top` to make sure no other background processes are starving resources.

## Special Thanks

Special thanks to the authors and contributors to [RPi_Cam_Web_Interface](https://github.com/silvanmelchior/RPi_Cam_Web_Interface) and [HarmonizeProject](https://github.com/MCPCapital/HarmonizeProject). This project would not be possible without either of these excellent projects!