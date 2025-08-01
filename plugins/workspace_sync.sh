#!/usr/bin/env bash

# Periodic workspace sync to catch missed workspace changes
CONFIG_DIR="$HOME/.config/sketchybar"

# Get current workspace states
CURRENT_WORKSPACES=$(aerospace list-workspaces --monitor all --empty no | sort | tr '\n' ' ')
EXISTING_ITEMS=$(sketchybar --query bar | grep -o '"workspace\.[^"]*"' | sed 's/"//g' | sed 's/workspace\.//' | sort | tr '\n' ' ')

# If they don't match, trigger a refresh
if [ "$CURRENT_WORKSPACES" != "$EXISTING_ITEMS" ]; then
    sketchybar --trigger aerospace_refresh_workspaces
fi