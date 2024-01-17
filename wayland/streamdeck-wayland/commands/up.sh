#!/bin/bash

if [[ $XDG_SESSION_TYPE == "wayland" ]]
then
	ydotool key 104:1 104:0
else
	xdotool key --window ${WINDOW} Up
fi
