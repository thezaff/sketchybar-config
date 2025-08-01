#!/bin/bash

# Enhanced workspace initialization script
# Ensures clean startup and handles edge cases

# Wait a moment for sketchybar to fully initialize
sleep 0.5

# Remove any existing aerospace workspace items to start fresh
sketchybar --query bar 2>/dev/null | jq -r '.items[]?' 2>/dev/null | grep '^aerospace\.' | while read -r item; do
    if [[ -n "$item" ]]; then
        sketchybar --remove "$item" 2>/dev/null
    fi
done

# Wait a brief moment
sleep 0.2

# Trigger initial workspace setup
"$CONFIG_DIR/plugins/workspace_sync.sh"