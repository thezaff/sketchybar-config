#!/usr/bin/env bash

# Source colors for consistent theming
source "$CONFIG_DIR/colors.sh"

WORKSPACE_ID="$1"
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

# Get workspaces for each monitor to determine colors
MONITOR_1_WORKSPACES=$(aerospace list-workspaces --monitor 1 --empty no 2>/dev/null || echo "")
MONITOR_2_WORKSPACES=$(aerospace list-workspaces --monitor 2 --empty no 2>/dev/null || echo "")

# Function to determine which monitor a workspace belongs to
get_workspace_monitor() {
    local workspace="$1"
    
    # Check if workspace is on monitor 1
    for ws in $MONITOR_1_WORKSPACES; do
        if [ "$ws" = "$workspace" ]; then
            echo "1"
            return
        fi
    done
    
    # Check if workspace is on monitor 2
    for ws in $MONITOR_2_WORKSPACES; do
        if [ "$ws" = "$workspace" ]; then
            echo "2"
            return
        fi
    done
    
    echo "unknown"
}

# Function to get monitor color
get_monitor_color() {
    local monitor="$1"
    case "$monitor" in
        "1") echo "$ACCENT_PRIMARY" ;;    # External monitor - Blue
        "2") echo "$ACCENT_SECONDARY" ;;  # Built-in monitor - Green
        *) echo "$GREY" ;;               # Fallback
    esac
}

# Determine monitor and color for this workspace
MONITOR=$(get_workspace_monitor "$WORKSPACE_ID")
MONITOR_COLOR=$(get_monitor_color "$MONITOR")

# Update styling based on focus state
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
    # Focused workspace - white text on darker background
    sketchybar --set "$NAME" \
               icon.color=$WHITE \
               icon.font="SF Pro:Semibold:12.0" \
               background.color=$BACKGROUND_2
else
    # Non-focused workspace - monitor color on lighter background
    sketchybar --set "$NAME" \
               icon.color=$MONITOR_COLOR \
               icon.font="SF Pro:Medium:12.0" \
               background.color=$BACKGROUND_1
fi