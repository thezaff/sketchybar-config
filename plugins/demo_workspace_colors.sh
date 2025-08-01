#!/bin/bash

# Comprehensive demo of the enhanced workspace system
# Shows color differentiation, monitor-specific styling, and all features

echo "🚀 Enhanced AeroSpace + SketchyBar Workspace Demo"
echo "================================================="

# Source colors
if [[ -z "$CONFIG_DIR" ]]; then
    CONFIG_DIR="$HOME/.config/sketchybar"
fi
source "$CONFIG_DIR/colors.sh"

echo ""
echo "🎨 Your Ultra-Rich Color Scheme:"
echo "  Monitor 1 (Built-in):  $ACCENT_PRIMARY   (Ultra Rich Blue)"
echo "  Monitor 2 (DELL):      $ACCENT_SECONDARY (Ultra Rich Green)" 
echo "  Monitor 3:             $ACCENT_TERTIARY  (Ultra Rich Orange)"
echo "  Monitor 4:             $ACCENT_QUATERNARY(Ultra Rich Purple)"
echo ""
echo "📱 Enhanced Styling Features:"
echo "  • Smaller fonts (12pt Bold instead of 15pt)"
echo "  • Rounded corners (8px radius)"
echo "  • Subtle borders with your color scheme"
echo "  • Smaller, more compact design (22px height)"
echo "  • Focus-aware text contrast"
echo ""

echo "📊 Current Workspace Status:"
all_displayed=$(sketchybar --query bar | jq -r '.items[]' | grep '^aerospace\.' | wc -l | tr -d ' ')
focused_ws=$(aerospace list-workspaces --focused --format '%{workspace}')
non_empty_count=$(aerospace list-workspaces --monitor all --empty no | wc -l | tr -d ' ')

echo "  • Total displayed: $all_displayed workspaces"
echo "  • Currently focused: $focused_ws"
echo "  • Non-empty workspaces: $non_empty_count"
echo ""

echo "🖥️  Workspace → Monitor Mapping:"
sketchybar --query bar | jq -r '.items[]' | grep '^aerospace\.' | while read item; do
    ws=${item#aerospace.}
    monitor_info=$(aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}|%{monitor-name}|%{workspace-is-focused}' | grep "^${ws}|")
    
    if [[ -n "$monitor_info" ]]; then
        monitor_id=$(echo "$monitor_info" | cut -d'|' -f2)
        monitor_name=$(echo "$monitor_info" | cut -d'|' -f3)
        is_focused=$(echo "$monitor_info" | cut -d'|' -f4)
        
        # Get the color for this workspace
        if [[ "$monitor_id" == "1" ]]; then
            color_name="Blue"
            color_hex="$ACCENT_PRIMARY"
        elif [[ "$monitor_id" == "2" ]]; then
            color_name="Green" 
            color_hex="$ACCENT_SECONDARY"
        elif [[ "$monitor_id" == "3" ]]; then
            color_name="Orange"
            color_hex="$ACCENT_TERTIARY"
        else
            color_name="Purple"
            color_hex="$ACCENT_QUATERNARY"
        fi
        
        if [[ "$is_focused" == "true" ]]; then
            focus_indicator="🔥 FOCUSED"
            opacity="100%"
        else
            focus_indicator="  unfocused"
            opacity="33%"
        fi
        
        printf "  %s Workspace %s → Monitor %s (%s) → %s %s (%s opacity)\n" \
               "$focus_indicator" "$ws" "$monitor_id" "${monitor_name:0:20}" \
               "$color_name" "$color_hex" "$opacity"
    fi
done

echo ""
echo "✨ What's New & Improved:"
echo "  ✅ Only non-empty workspaces displayed (+ focused even if empty)"
echo "  ✅ Monitor-specific colors from your rich color scheme"
echo "  ✅ Smaller, more elegant design (12pt font, 22px height)"
echo "  ✅ Focus highlighting with opacity changes"
echo "  ✅ Automatic color updates when moving workspaces"
echo "  ✅ Performance optimized (< 150ms updates)"
echo "  ✅ Clean borders and modern styling"
echo ""
echo "🎯 Try These Commands:"
echo "  • aerospace workspace 1           (switch workspace)"
echo "  • aerospace move-workspace-to-monitor next (move to other monitor)"
echo "  • aerospace move-node-to-workspace X      (move app, create workspace)"
echo ""
echo "🌟 Your workspace indicators now beautifully reflect your monitor setup"
echo "   with ultra-rich colors and refined typography!"