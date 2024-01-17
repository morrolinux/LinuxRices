# The better way (obs-websocket)

## Requirements 

### A websocket-enabled obs version

just install a recent OBS version that has websocket API 5.0 built-in. That should be OBS 28 and later releases.

For some reason, as of Jan-17-2024, Arch Linux verion of OBS 30 still doesn't provide websocket support, so we have to install `obs-studio-git` from the AUR or the flatpak version. See [this](https://wiki.archlinux.org/title/Open_Broadcaster_Software).

### A websocket client or library to control OBS

[This library](https://github.com/aatikturk/obsws-python) looks easy enough to use:

A minimal python script could be as simple as:

```
#!/usr/bin/env python3

# TODO integrate this into streamdeck-ui for the best expirience

import argparse
import obsws_python as obs

parser = argparse.ArgumentParser()
parser.add_argument('--scene', type=str)
parser.add_argument('--recstop', action='store_true')
args = parser.parse_args()

cl = obs.ReqClient(host='localhost', port=4455, password='mystrongpass' , timeout=3)

def set_scene(scene_name):
    cl.set_current_program_scene(scene_name)

def toggle_recording():
    if cl.get_output_list().outputs[0]['outputActive']:
        cl.stop_output('simple_file_output')
    else:
        cl.start_output('simple_file_output')

if __name__ == "__main__":
    if args.scene is not None:
        set_scene(args.scene)
    if args.recstop:
        toggle_recording()
```

Then you just need to run this script from the `streamdeck_ui` program upon button press.


# Alternative method (hyprland keyboard shortcuts passthrough)
## First step

Configure the shorctus in OBS, then follow the subsequent points to configure the streamdeck.

## Requirements

`ydotool`, a desktop-agnostic xdotool implementation.

## Configuration

```
cp ydotool.service /etc/systemd/system/ydotool.service
sudo systemctl daemon-reload
sudo systemctl enable ydotool
```

Now you can programmatically send keyboard shortcuts with ydotool like so:

```
sudo ydotool key 56:1 15:1 56:0 15:0
```

where keycode:1 means pressed, keycode:0 means released.

See `/usr/include/linux/input-event-codes.h` for available key codes (KEY_*).

## Run as a regular user

```
sudo usermod -a -G input $USER
echo "KERNEL==\"uinput\", GROUP=\"input\", MODE=\"0660\", OPTIONS+=\"static_node=uinput\"" | sudo tee /etc/udev/rules.d/80-uinput.rules > /dev/null
reboot
```

This will ensure that the only `root` and the users in the `input` group will be able to write to the `/dev/uinput` device. The `ydotool` utility writes to `/run/user/1000/.ydotool_socket` for communicating with the backend, so the `ydotool.service` unit is already configured to set right ownership and permissions to it. Please **change 1000** to your UID if it differs!

See: [this](https://github.com/ReimuNotMoe/ydotool/issues/25#issuecomment-535842993) and [this](https://github.com/ReimuNotMoe/ydotool/issues/207)

## Configure hyprland to pass shorcuts to OBS (global shortcuts workaround)

Add to `hyprland.conf`:
```
bind=Alt SHIFT_L,F9,pass,^(com\.obsproject\.Studio)$
bind=Alt SHIFT_L,F12,pass,^(com\.obsproject\.Studio)$
...
```

## Streamdeck configuration

The streamdeck can run simple bash scripts on button press.

such a script could invoke `ydotool` like so:

```
#!/bin/bash

ydotool key 56:1 15:1 56:0 15:0
```

Or something like this for X11 and Wayland operability:

```
#!/bin/bash

if [[ $XDG_SESSION_TYPE == "wayland" ]]
then
	ydotool key 56:1 42:1 67:1 67:0 42:0 56:0   # hyprland will forward this to OBS
else
	for WINDOW in $(xdotool search "OBS 30")
	do    
		xdotool key --window ${WINDOW} Super+Shift+F9
	done
fi
```
