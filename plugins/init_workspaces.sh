#!/usr/bin/env bash

# Initialize aerospace workspaces on SketchyBar start
CONFIG_DIR="$HOME/.config/sketchybar"

# Small delay to ensure SketchyBar is fully loaded
sleep 0.5

# Trigger workspace refresh
SENDER="aerospace_refresh_workspaces" "$CONFIG_DIR/plugins/aerospace.sh"