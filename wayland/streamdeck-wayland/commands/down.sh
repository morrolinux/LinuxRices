#!/bin/bash

if [[ $XDG_SESSION_TYPE == "wayland" ]]
then
	ydotool key 109:1 109:0
else
	xdotool key --window ${WINDOW} Down
fi
