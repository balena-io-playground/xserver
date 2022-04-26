#!/usr/bin/env bash

# Cleanup previous references that are not in use. The X server will clean up sockets if they exist. 
rm -r /tmp/.X11-unix 2>/dev/null

echo "Force display is set to $FORCE_DISPLAY"

/usr/bin/entry.sh echo "Running balena base image entrypoint..."

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

echo "balenaBlocks xserver version: $(cat VERSION)"

# If the vcgencmd is supported (i.e. RPi device) - check enough GPU memory is allocated
if command -v vcgencmd &> /dev/null
then
	echo "Checking GPU memory"
    if [ "$(vcgencmd get_mem gpu | grep -o '[0-9]\+')" -lt 128 ]
	then
	echo -e "\033[91mWARNING: GPU MEMORY TOO LOW"
	fi
fi

if [ "$CURSOR" = true ];
then
    exec startx -- $FORCE_DISPLAY
else
    exec startx -- $FORCE_DISPLAY -nocursor
fi
