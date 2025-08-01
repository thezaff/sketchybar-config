#!/bin/bash

# Quick script to check workspace colors and monitor assignments

echo "🎨 Workspace Color & Monitor Check"
echo "=================================="

# Source colors
if [[ -z "$CONFIG_DIR" ]]; then
    CONFIG_DIR="$HOME/.config/sketchybar"
fi
source "$CONFIG_DIR/colors.sh"

echo "🖥️  Monitor Color Mapping:"
echo "  Monitor 1 (Built-in): $ACCENT_PRIMARY (Blue)"
echo "  Monitor 2 (DELL):     $ACCENT_SECONDARY (Green)"
echo "  Monitor 3:            $ACCENT_TERTIARY (Orange)"
echo "  Monitor 4:            $ACCENT_QUATERNARY (Purple)"
echo ""

echo "📊 Currently Displayed Workspaces:"
sketchybar --query bar | jq -r '.items[]' | grep '^aerospace\.' | while read item; do
    ws=${item#aerospace.}
    monitor_info=$(aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}|%{monitor-name}|%{workspace-is-focused}' | grep "^${ws}|")
    
    if [[ -n "$monitor_info" ]]; then
        monitor_id=$(echo "$monitor_info" | cut -d'|' -f2)
        monitor_name=$(echo "$monitor_info" | cut -d'|' -f3)
        is_focused=$(echo "$monitor_info" | cut -d'|' -f4)
        
        if [[ "$is_focused" == "true" ]]; then
            focus_marker="🔥"
        else
            focus_marker="  "
        fi
        
        echo "$focus_marker Workspace $ws -> Monitor $monitor_id ($monitor_name)"
    fi
done

echo ""
echo "💡 To test color changes:"
echo "   • Move a workspace: aerospace move-workspace-to-monitor next"
echo "   • Focus different workspace: aerospace workspace <name>"
echo "   • See colors update automatically!"