#!/bin/bash

killall polybar
polybar &

# Resync IPC modules after polybar restarts
sleep 1
voice-dictation sync 2>/dev/null &
standup-record sync 2>/dev/null &
lid-suspend-sync 2>/dev/null &
picom-toggle sync 2>/dev/null &
