#!/bin/bash

# Check for HDMI connection
if xrandr | grep "HDMI-2 connected"; then
    # If HDMI is connected, load the HDMI layout
~/.screenlayout/lg_external_monitor.sh
fi

