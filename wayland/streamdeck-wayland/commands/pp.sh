#!/bin/bash

# xdotool search --name "OBS 30" windowactivate --sync %1 key F1 windowactivate $(xdotool getactivewindow)
#

if [[ $XDG_SESSION_TYPE == "wayland" ]]
then
	ydotool key 56:1 42:1 67:1 67:0 42:0 56:0
else
	for WINDOW in $(xdotool search "OBS 30")
	do    
		xdotool key --window ${WINDOW} Alt+Shift+F9
	done
fi

# works on KDE only
# xdotool search --name "OBS 30" key Super+Shift+F1	

# xdotool key Alt+Shift+F1
# echo "key Alt+Shift+F1" | dotool
# echo "key Super Alt F1" | dotool
