#!/usr/bin/env bash

# Aerospace workspace manager - handles both workspace changes and refreshes
CONFIG_DIR=${CONFIG_DIR:-"$HOME/.config/sketchybar"}
source "$CONFIG_DIR/colors.sh"

# Handle different events
case "$SENDER" in
    "aerospace_workspace_change")
        # Update workspace highlighting
        FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE"
        PREV_WORKSPACE="$AEROSPACE_PREV_WORKSPACE"
        
        # If no focused workspace from environment, get it directly
        if [ -z "$FOCUSED_WORKSPACE" ]; then
            FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
        fi
        
        # Update all workspace items
        for item in $(sketchybar --query bar | grep -o '"workspace\.[^"]*"' | sed 's/"//g'); do
            workspace_id="${item#workspace.}"
            
            if [ "$workspace_id" = "$FOCUSED_WORKSPACE" ]; then
                # Focused workspace - bright accent color with darker background
                sketchybar --set "$item" \
                           icon.color=$YELLOW \
                           icon.font="SF Pro:Semibold:13.0" \
                           background.color=$BACKGROUND_2 \
                           background.border_width=2 \
                           background.border_color=$ACCENT_PRIMARY
            else
                # Get monitor for this workspace to determine color
                MONITOR_1_WORKSPACES=$(aerospace list-workspaces --monitor 1 --empty no 2>/dev/null || echo "")
                MONITOR_2_WORKSPACES=$(aerospace list-workspaces --monitor 2 --empty no 2>/dev/null || echo "")
                
                # Determine monitor color
                MONITOR_COLOR="$GREY"
                for ws in $MONITOR_1_WORKSPACES; do
                    if [ "$ws" = "$workspace_id" ]; then
                        MONITOR_COLOR="$ACCENT_PRIMARY"  # Blue for monitor 1
                        break
                    fi
                done
                for ws in $MONITOR_2_WORKSPACES; do
                    if [ "$ws" = "$workspace_id" ]; then
                        MONITOR_COLOR="$ACCENT_SECONDARY"  # Green for monitor 2
                        break
                    fi
                done
                
                # Non-focused workspace - monitor color on lighter background
                sketchybar --set "$item" \
                           icon.color=$MONITOR_COLOR \
                           icon.font="SF Pro:Medium:12.0" \
                           background.color=$BACKGROUND_1 \
                           background.border_width=0 \
                           background.border_color=$TRANSPARENT
            fi
        done
        ;;
        
    "aerospace_refresh_workspaces")
        # Rebuild workspace list from scratch
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
        
        # Remove all existing workspace items
        sketchybar --query bar | grep -o '"workspace\.[^"]*"' | sed 's/"//g' | while read -r item; do
            sketchybar --remove "$item" 2>/dev/null || true
        done
        
        # Create items for all non-empty workspaces
        for workspace in $ALL_WORKSPACES; do
            ITEM_NAME="workspace.$workspace"
            MONITOR=$(get_workspace_monitor "$workspace")
            MONITOR_COLOR=$(get_monitor_color "$MONITOR")
            
                    # Add the workspace item
            sketchybar --add item "$ITEM_NAME" left \
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
                             script="$CONFIG_DIR/plugins/aerospace.sh" \
                       --subscribe "$ITEM_NAME" aerospace_workspace_change
            
            # Set colors based on focus and monitor
            if [ "$workspace" = "$FOCUSED_WORKSPACE" ]; then
                # Focused workspace - bright accent color with darker background
                sketchybar --set "$ITEM_NAME" \
                           icon.color=$YELLOW \
                           icon.font="SF Pro:Semibold:13.0" \
                           background.color=$BACKGROUND_2 \
                           background.border_width=2 \
                           background.border_color=$ACCENT_PRIMARY
            else
                # Non-focused workspace - monitor color on lighter background
                sketchybar --set "$ITEM_NAME" \
                           icon.color=$MONITOR_COLOR \
                           icon.font="SF Pro:Medium:12.0" \
                           background.color=$BACKGROUND_1 \
                           background.border_width=0 \
                           background.border_color=$TRANSPARENT
            fi
        done
        ;;
    
    *)
        # Default case - trigger workspace refresh for initialization
        sketchybar --trigger aerospace_refresh_workspaces
        ;;
esac