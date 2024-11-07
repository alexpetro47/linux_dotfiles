# Check for HDMI connection on either HDMI-1 or HDMI-2
if xrandr | grep -q "HDMI-[12] connected"; then
    # If HDMI is connected on HDMI-1 or HDMI-2, load the HDMI layout
    ~/.screenlayout/external_monitor.sh
else
    # If no HDMI connection, load the laptop-only layout
    ~/.screenlayout/laptop_only.sh
fi

