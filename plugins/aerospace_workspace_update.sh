#!/bin/bash

# AeroSpace workspace management for SketchyBar
if [[ -z "$CONFIG_DIR" ]]; then
    CONFIG_DIR="$HOME/.config/sketchybar"
fi
source "$CONFIG_DIR/colors.sh"

get_monitor_accent_color() {
    local monitor="$1"
    case "$monitor" in
        "1"|"main") echo "$ACCENT_PRIMARY" ;;
        "2"|"secondary") echo "$ACCENT_SECONDARY" ;;
        "3") echo "$ACCENT_TERTIARY" ;;
        "4") echo "$ACCENT_QUATERNARY" ;;
        *) echo "$ACCENT_PRIMARY" ;;
    esac
}

get_monitor_background_focused() {
    local monitor="$1"
    local accent_color=$(get_monitor_accent_color "$monitor")

    echo "${accent_color/0xff/0x40}"
}

get_monitor_background_unfocused() {
    local monitor="$1"
    local accent_color=$(get_monitor_accent_color "$monitor")

    echo "${accent_color/0xff/0x15}"
}

get_monitor_border_focused() {
    local monitor="$1"
    local accent_color=$(get_monitor_accent_color "$monitor")

    echo "${accent_color/0xff/0x80}"
}

get_monitor_border_unfocused() {
    local monitor="$1"
    local accent_color=$(get_monitor_accent_color "$monitor")

    echo "${accent_color/0xff/0x25}"
}

get_monitor_text_focused() {
    local monitor="$1"

    get_monitor_accent_color "$monitor"
}

get_monitor_text_unfocused() {
    local monitor="$1"
    local accent_color=$(get_monitor_accent_color "$monitor")

    echo "${accent_color/0xff/0x70}"
}

# Get current workspace and monitor information
FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE"
PREV_WORKSPACE="$AEROSPACE_PREV_WORKSPACE"

# Function to get monitor-specific colors
get_monitor_colors() {
    local workspace="$1"
    local is_focused="$2"
    
    # Get monitor info for this workspace using aerospace
    local monitor_info=$(aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}|%{monitor-name}' | grep "^${workspace}|")
    
    local monitor_id="1"  # Default fallback
    if [[ -n "$monitor_info" ]]; then
        monitor_id=$(echo "$monitor_info" | cut -d'|' -f2)
    fi
    
    # Get colors based on focus state
    local text_color
    local background_color
    local border_color
    
    if [[ "$is_focused" == "true" ]]; then
        text_color=$(get_monitor_text_focused "$monitor_id")
        background_color=$(get_monitor_background_focused "$monitor_id")
        border_color=$(get_monitor_border_focused "$monitor_id")
    else
        text_color=$(get_monitor_text_unfocused "$monitor_id")
        background_color=$(get_monitor_background_unfocused "$monitor_id")
        border_color=$(get_monitor_border_unfocused "$monitor_id")
    fi
    
    # Return colors as space-separated string: text background border
    echo "$text_color $background_color $border_color"
}


# Function to create or update a workspace item
update_workspace_item() {
    local workspace="$1"
    local is_focused="$2"
    
    local item_name="aerospace.${workspace}"
    
    # Get the sophisticated color scheme
    local colors=$(get_monitor_colors "$workspace" "$is_focused")
    local text_color=$(echo "$colors" | cut -d' ' -f1)
    local background_color=$(echo "$colors" | cut -d' ' -f2)
    local border_color=$(echo "$colors" | cut -d' ' -f3)
    
    # Check if item exists
    local item_exists=$(sketchybar --query "$item_name" 2>/dev/null)
    
    if [[ -z "$item_exists" ]]; then

        sketchybar --add item "$item_name" left \
                   --set "$item_name" \
                         icon="$workspace" \
                         icon.font="JetbrainsMono Nerd Font Mono:Bold:12.0" \
                         icon.color="$text_color" \
                         icon.padding_left=8 \
                         icon.padding_right=8 \
                         label.drawing=off \
                         background.color="$background_color" \
                         background.corner_radius=5 \
                         background.height=24 \
                         background.border_width=1 \
                         background.border_color="$border_color" \
                         background.drawing=on \
                         padding_left=4 \
                         padding_right=4 \
                         click_script="aerospace workspace $workspace" \
                   --subscribe "$item_name" aerospace_workspace_change
        

        sketchybar --move "$item_name" after separator
    else

        sketchybar --set "$item_name" \
                         icon.color="$text_color" \
                         background.color="$background_color" \
                         background.border_color="$border_color" \
                         icon="$workspace"
    fi
}

# Function to remove workspace item
remove_workspace_item() {
    local workspace="$1"
    local item_name="aerospace.${workspace}"
    
    # Check if item exists before trying to remove
    local item_exists=$(sketchybar --query "$item_name" 2>/dev/null)
    if [[ -n "$item_exists" ]]; then
        sketchybar --remove "$item_name"
    fi
}

# Main update logic
update_workspaces() {
    # Get all currently existing workspace items
    local existing_items=$(sketchybar --query bar | jq -r '.items[] | select(startswith("aerospace.")) | .')
    
    # Get workspaces that should be displayed:
    # 1. Always include focused workspace (even if empty)
    # 2. Include all non-empty workspaces
    local workspaces_to_display=()
    
    # Add focused workspace (even if empty)
    if [[ -n "$FOCUSED_WORKSPACE" ]]; then
        workspaces_to_display+=("$FOCUSED_WORKSPACE")
    fi
    
    # Add all non-empty workspaces
    local non_empty_workspaces=$(aerospace list-workspaces --monitor all --empty no --format '%{workspace}')
    while IFS= read -r workspace; do
        if [[ -n "$workspace" ]]; then
            # Add to list if not already included (avoid duplicates)
            local already_included=false
            for existing_ws in "${workspaces_to_display[@]}"; do
                if [[ "$existing_ws" == "$workspace" ]]; then
                    already_included=true
                    break
                fi
            done
            if [[ "$already_included" == "false" ]]; then
                workspaces_to_display+=("$workspace")
            fi
        fi
    done <<< "$non_empty_workspaces"
    
    # Update or create items for workspaces that should be displayed
    for workspace in "${workspaces_to_display[@]}"; do
        local is_focused="false"
        if [[ "$workspace" == "$FOCUSED_WORKSPACE" ]]; then
            is_focused="true"
        fi
        update_workspace_item "$workspace" "$is_focused"
    done
    
    # Remove items for workspaces that should not be displayed
    if [[ -n "$existing_items" ]]; then
        while IFS= read -r item; do
            if [[ -n "$item" ]]; then
                local workspace=${item#aerospace.}
                
                # Check if this workspace should be displayed
                local should_keep=false
                for display_ws in "${workspaces_to_display[@]}"; do
                    if [[ "$display_ws" == "$workspace" ]]; then
                        should_keep=true
                        break
                    fi
                done
                
                # Remove if not in the display list
                if [[ "$should_keep" == "false" ]]; then
                    remove_workspace_item "$workspace"
                fi
            fi
        done <<< "$existing_items"
    fi
}

# Trigger the update
update_workspaces

# Trigger sketchybar event for any scripts that need to respond
sketchybar --trigger aerospace_workspace_change \
           FOCUSED_WORKSPACE="$FOCUSED_WORKSPACE" \
           PREV_WORKSPACE="$PREV_WORKSPACE"