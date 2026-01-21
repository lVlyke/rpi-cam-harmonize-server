# rpi-cam-harmonize-server

Turn any Raspberry Pi + Camera module into a self-contained real-time light syncing solution for your Philips Hue lights, including a remotely accessible web interface. Powered by [HarmonizeProject](https://github.com/MCPCapital/HarmonizeProject) and [RPi_Cam_Web_Interface](https://github.com/silvanmelchior/RPi_Cam_Web_Interface).

![Server GUI](/docs/server_gui.png)

# About

A collection of shell scripts that turns a Raspberry Pi (or any machine running Debian) into a highly configurable web server with GUI that will sync your Philips Hue lights to a camera's video stream in real time.

## Requirements

* Philips Hue Bridge with compatible lights
* A device running Debian (such as a Rasperry Pi).
* A compatible camera that supports MJPEG streaming (see below).

### Camera requirements

#### Raspberry Pi
Raspberry Pi camera module (or equivalent).

> [!IMPORTANT]
> You must enable the legacy camera module which currently only works with the legacy version of Raspberry Pi OS (Bullseye or earlier). If you are using the Rasperry Pi Imager, select **Raspberry Pi OS (Legacy, 32-bit) Lite**.

#### Other devices
Any camera or device that supports sending an MJPEG stream over HTTP.

## Installation

> [!IMPORTANT]
> Before starting, **ensure that the legacy camera interface has been enabled on your Raspberry Pi**. You can do this by running `sudo raspi-config` and enabling the legacy camera module under `Interface Options`.

This project can be installed two different ways:
- **All-in-one installation**: A single Raspberry Pi hosts the camera server and runs the light sync. A Raspberry Pi with a camera module is required.
- **Separate client and server installation:** The client device handles syncing the lights to the camera. The server is a separate device, such as a Raspberry Pi + camera, or any MJPEG stream source.

### Option 1: All-in-one installation

Clone the project onto your machine:

```bash
git clone https://github.com/lVlyke/rpi-cam-harmonize-server.git
```

Next, `cd` into the newly created directory.

```bash
cd ./rpi-cam-harmonize-server
```

Run the `install_all.sh` script:

```bash
./install_all.sh
```

This may take a while depending on your hardware.

Finally, update your [**settings**](#configuration) as needed.

### Option 2: Separate client and server installation

#### Client

Clone the project onto your client machine:

```bash
git clone https://github.com/lVlyke/rpi-cam-harmonize-server.git
```

Next, `cd` into the newly created directory.

```bash
cd ./rpi-cam-harmonize-server
```

Run the `install_client.sh` script:

```bash
./install_client.sh
```
This may take a while depending on your hardware.

#### Server

> [!IMPORTANT]
> Your camera source (server) can be either a Raspberry Pi + camera or a MJPEG stream. The web GUI is only available if using a Raspberry Pi as the camera server.

If using a MJPEG camera stream source, proceed to [**Configuration**](#configuration).

If using a Rasperry Pi + camera as the camera stream source (server), clone the project onto the Pi server and run the `install_server.sh` script:

```bash
./install_server.sh
```

## Configuration

All settings are configured via the `.syncrc` file. These are the available settings and their default values:

```bash
picam_stream_src="http://localhost/cam_pic_new.php?pDelay="
picam_stream_fps=25
picam_stream_init_delay=1.5
picam_log_file="/tmp/rpi-cam-harmonize-server.log"
picam_bridge_ip="" # (Optional) Add your Hue bridge IP here
picam_group_id="" # (Optional) Add your entertainment group ID here
```

**picam_stream_src** - The camera stream URL. Leave unchanged for all-in-one installation. Set to the server's camera video stream URL if using a remote server.

**picam_stream_fps** - The number of frames per second the camera stream URL will update. This can be increased/decreased depending on your hardware. Defaults to 25.

**picam_stream_init_delay** - The camera stream init delay. This can be increased if you are receiving `rgbframe` errors when starting light sync. See the "Troubleshooting" section below for more info.

**picam_log_file** - The log file. Defaults to `/tmp/rpi-cam-harmonize-server.log`.

**picam_bridge_ip** - (Optional) The IP address of your Hue Bridge. This is only needed when multiple Hue Bridges are on a single network.

**picam_group_id** - (Optional) The group ID of your Hue entertainment group. This is only needed when you have multiple entertainment groups defined.

The following properties are only applicable for a remote server installation. **Leave these unchanged for all-in-one and client installations**.

```bash
picam_client_host=""
picam_client_port="22"
picam_client_keyfile=""
picam_client_user="syncuser"
picam_client_home="/rpi-cam-harmonize-server"
```

**picam_client_host** - The host/IP of the client machine.

**picam_client_port** - The port of the client machine for SSH.

**picam_client_keyfile** - Path to the SSH keyfile to use.

**picam_client_user** - Name of the user to use on the client machine.

**picam_client_home** - The project directory path on the client machine.

## Running

### Starting the web server

By default, the server will start automatically when booting your Raspberry Pi. To start or stop the server manually, you can use the included `start_server.sh` and `stop_server.sh` scripts:

```bash
./start_server.sh
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

To stop the light sync, simply press the `Stop Light Sync` button.

The web server can be turned off by running the `stop_server.sh` command:

```bash
./stop.sh
```

## Troubleshooting

### My camera does not show up on the server GUI

Make sure you have enabled the legacy camera interface on your Raspberry Pi. You can do this by running `sudo raspi-config` and enabling the camera under `Interface Options`.

### Nothing happens when I click "Start Light Sync"

The first thing you should do is check the log, which by default is saved at `/tmp/rpi-cam-harmonize-server.log`. This will most likely show you what the issue is. 

If the log shows `ERROR: Button press not detected, exiting application`, you need to make sure you press the button on the Hue Bridge at the correct time during first start. The easiest way to do this is to run `tail -f /tmp/rpi-cam-harmonize-server.log` after clicking "Start Light Sync".

If the log shows an error about `w`, `h`, `rgbframe` or other variables, try increasing the `picam_stream_init_delay` value in `.syncrc` and try again.

### Light sync is slow/lagging behind camera stream

This can be either due to lack of hardware resources or due to network connectivity issues.

First, try lowering the `picam_stream_fps` in `.syncrc`. If you are using a very low powered Pi like the Zero, try starting with 10 FPS and increase/decrease from there to see what is ideal for your hardware.

If lowering the stream FPS has no effect, it may be a network problem. If you are using Wi-Fi, try switching to a wired connection if possible. 

You can also check `top` to make sure no other background processes are starving resources.

## Special Thanks

Special thanks to the authors and contributors to [RPi_Cam_Web_Interface](https://github.com/silvanmelchior/RPi_Cam_Web_Interface) and [HarmonizeProject](https://github.com/MCPCapital/HarmonizeProject). This would not exist without either of these excellent projects!