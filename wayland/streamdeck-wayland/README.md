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
