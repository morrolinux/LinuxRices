#!/bin/bash

if [[ $XDG_SESSION_TYPE == "wayland" ]]
then
        ydotool key 56:1 42:1 62:1 62:0 42:0 56:0
else
        for WINDOW in $(xdotool search "OBS 30")
        do
                xdotool key --window ${WINDOW} Alt+Shift+F4
        done
fi
