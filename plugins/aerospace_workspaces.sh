#!/usr/bin/env bash

# Source colors for consistent theming
source "$CONFIG_DIR/colors.sh"

# Get all non-empty workspaces
ALL_WORKSPACES=$(aerospace list-workspaces --monitor all --empty no)
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

# Get workspaces for each monitor
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
    
    # Fallback - shouldn't happen with non-empty workspaces
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

# Function to get monitor name for display
get_monitor_name() {
    local monitor="$1"
    case "$monitor" in
        "1") echo "M1" ;;    # External monitor
        "2") echo "M2" ;;    # Built-in monitor
        *) echo "M?" ;;      # Fallback
    esac
}

# Clear existing workspace items (remove all items that start with 'workspace.')
sketchybar --query bar | grep -o '"workspace\.[^"]*"' | sed 's/"//g' | while read -r item; do
    sketchybar --remove "$item" 2>/dev/null || true
done

# Create items for all non-empty workspaces
for workspace in $ALL_WORKSPACES; do
    ITEM_NAME="workspace.$workspace"
    MONITOR=$(get_workspace_monitor "$workspace")
    MONITOR_COLOR=$(get_monitor_color "$MONITOR")
    MONITOR_NAME=$(get_monitor_name "$MONITOR")
    
    # Add the workspace item
    sketchybar --add item "$ITEM_NAME" left \
               --subscribe "$ITEM_NAME" aerospace_workspace_change \
               --set "$ITEM_NAME" \
                     icon="$workspace" \
                     icon.font="SF Pro:Medium:12.0" \
                     icon.padding_left=8 \
                     icon.padding_right=8 \
                     label.drawing=off \
                     padding_left=2 \
                     padding_right=2 \
                     background.corner_radius=6 \
                     background.height=26 \
                     background.drawing=on \
                     click_script="aerospace workspace $workspace" \
                     script="$PLUGIN_DIR/aerospace_workspace_update.sh $workspace"
    
    # Set colors based on focus and monitor
    if [ "$workspace" = "$FOCUSED_WORKSPACE" ]; then
        # Focused workspace - white text on darker background
        sketchybar --set "$ITEM_NAME" \
                   icon.color=$WHITE \
                   icon.font="SF Pro:Semibold:12.0" \
                   background.color=$BACKGROUND_2
    else
        # Non-focused workspace - monitor color on lighter background
        sketchybar --set "$ITEM_NAME" \
                   icon.color=$MONITOR_COLOR \
                   icon.font="SF Pro:Medium:12.0" \
                   background.color=$BACKGROUND_1
    fi
done