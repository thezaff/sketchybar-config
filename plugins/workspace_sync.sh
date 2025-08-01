#!/bin/bash

# Workspace synchronization helper script
# This script can be used for periodic checks or manual sync if needed
# It's a lightweight fallback to ensure workspaces stay in sync

# Set CONFIG_DIR if not already set
if [[ -z "$CONFIG_DIR" ]]; then
    CONFIG_DIR="$HOME/.config/sketchybar"
fi

# Get current focused workspace
CURRENT_FOCUSED=$(aerospace list-workspaces --focused --format '%{workspace}')

# Trigger the main workspace update script with current state
export AEROSPACE_FOCUSED_WORKSPACE="$CURRENT_FOCUSED"
export AEROSPACE_PREV_WORKSPACE=""
export CONFIG_DIR="$CONFIG_DIR"

# Call the main workspace update script
"$CONFIG_DIR/plugins/aerospace_workspace_update.sh"