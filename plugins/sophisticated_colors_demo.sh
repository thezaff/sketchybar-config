#!/bin/bash

# Demo of the sophisticated color scheme for workspace items

echo "🎨 Sophisticated Workspace Color Scheme Demo"
echo "============================================="

# Source colors
if [[ -z "$CONFIG_DIR" ]]; then
    CONFIG_DIR="$HOME/.config/sketchybar"
fi
source "$CONFIG_DIR/colors.sh"

echo ""
echo "🌟 New Sophisticated Color System:"
echo "   Text/Labels:    Full accent colors for focused, dimmed for unfocused"
echo "   Backgrounds:    Dimmed accent colors (subtle & elegant)"
echo "   Borders:        Medium accent colors (defined but not overwhelming)"
echo ""

echo "🎯 Color Intensity Levels:"
echo "   FOCUSED state:"
echo "     • Text:       100% accent color (full vibrancy)"
echo "     • Background: 25% accent color (bright but subtle)"
echo "     • Border:     50% accent color (visible definition)"
echo ""
echo "   UNFOCUSED state:"
echo "     • Text:       70% accent color (dimmed but readable)"
echo "     • Background: 8% accent color (very subtle & dimmed)"
echo "     • Border:     15% accent color (gentle definition)"
echo ""

echo "🖥️  Monitor-Specific Color Mapping:"
echo "   Monitor 1 (Built-in):  $ACCENT_PRIMARY   (Ultra Rich Blue)"
echo "   Monitor 2 (DELL):      $ACCENT_SECONDARY (Ultra Rich Green)"
echo "   Monitor 3:             $ACCENT_TERTIARY  (Ultra Rich Orange)"
echo "   Monitor 4:             $ACCENT_QUATERNARY (Ultra Rich Purple)"
echo ""

echo "📊 Current Workspace Analysis:"
sketchybar --query bar | jq -r '.items[]' | grep '^aerospace\.' | while read item; do
    ws=${item#aerospace.}
    monitor_info=$(aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}|%{monitor-name}|%{workspace-is-focused}' | grep "^${ws}|")
    
    if [[ -n "$monitor_info" ]]; then
        monitor_id=$(echo "$monitor_info" | cut -d'|' -f2)
        monitor_name=$(echo "$monitor_info" | cut -d'|' -f3)
        is_focused=$(echo "$monitor_info" | cut -d'|' -f4)
        
        # Get colors for demonstration
        case "$monitor_id" in
            "1") 
                accent="$ACCENT_PRIMARY"
                color_name="Blue"
                ;;
            "2") 
                accent="$ACCENT_SECONDARY"
                color_name="Green"
                ;;
            "3") 
                accent="$ACCENT_TERTIARY"
                color_name="Orange"
                ;;
            *) 
                accent="$ACCENT_QUATERNARY"
                color_name="Purple"
                ;;
        esac
        
        if [[ "$is_focused" == "true" ]]; then
            focus_indicator="🔥 FOCUSED"
            text_alpha="100%"
            bg_alpha="25%"
            border_alpha="50%"
        else
            focus_indicator="  unfocused"
            text_alpha="70%"
            bg_alpha="8%"
            border_alpha="15%"
        fi
        
        printf "  %s Workspace %s → Monitor %s:\n" "$focus_indicator" "$ws" "$monitor_id"
        if [[ "$is_focused" == "true" ]]; then
            printf "    Text:       %s (%s - %s alpha)\n" "$accent" "$color_name" "$text_alpha"
            printf "    Background: %s (%s - %s alpha)\n" "${accent/0xff/0x40}" "$color_name" "$bg_alpha"
            printf "    Border:     %s (%s - %s alpha)\n" "${accent/0xff/0x80}" "$color_name" "$border_alpha"
        else
            printf "    Text:       %s (%s - %s alpha)\n" "${accent/0xff/0x70}" "$color_name" "$text_alpha"
            printf "    Background: %s (%s - %s alpha)\n" "${accent/0xff/0x15}" "$color_name" "$bg_alpha"
            printf "    Border:     %s (%s - %s alpha)\n" "${accent/0xff/0x25}" "$color_name" "$border_alpha"
        fi
        echo ""
    fi
done

echo "✨ Benefits of the New Color System:"
echo "   ✅ Text remains highly readable with full accent colors"
echo "   ✅ Backgrounds provide subtle monitor differentiation"
echo "   ✅ Borders add definition without being distracting"
echo "   ✅ Focus state changes are immediately visible"
echo "   ✅ Sophisticated layered color approach"
echo "   ✅ Maintains visual hierarchy and elegance"
echo ""

echo "🎨 Visual Design Principles Applied:"
echo "   • High contrast text for accessibility"
echo "   • Subtle backgrounds for visual comfort"
echo "   • Progressive disclosure through focus states"
echo "   • Consistent alpha channel manipulation"
echo "   • Monitor-aware color differentiation"
echo ""

echo "🚀 Try switching workspaces or moving them between monitors"
echo "   to see the sophisticated color transitions in action!"