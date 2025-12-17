#!/bin/bash
# i3 startup script - launches apps to specific workspaces

sleep 1

# WS 1: Main terminal
i3-msg 'workspace 1'
alacritty &
sleep 0.5

# WS 2: Main browser
i3-msg 'workspace 2'
brave-browser &
sleep 1

# WS 6: Comms browser (Gmail, Calendar, Teams, Simplenote)
i3-msg 'workspace 6'
brave-browser "https://mail.google.com" "https://calendar.google.com" "https://teams.microsoft.com" "https://app.simplenote.com" &
sleep 0.5

# Return to WS 1
i3-msg 'workspace 1'
