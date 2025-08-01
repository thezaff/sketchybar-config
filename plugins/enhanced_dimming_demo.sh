#!/bin/bash

# Demo of enhanced dimming for unfocused workspaces

echo "🎨 Enhanced Dimming Update"
echo "========================="

# Source colors
if [[ -z "$CONFIG_DIR" ]]; then
    CONFIG_DIR="$HOME/.config/sketchybar"
fi
source "$CONFIG_DIR/colors.sh"

echo ""
echo "✨ MORE DIMMED UNFOCUSED WORKSPACES:"
echo ""

echo "📊 BEFORE vs AFTER Alpha Values:"
echo ""
echo "   FOCUSED state (unchanged):"
echo "     • Text:       100% accent color"
echo "     • Background: 25% accent color" 
echo "     • Border:     50% accent color"
echo ""
echo "   UNFOCUSED state (more dimmed):"
echo "     BEFORE:"
echo "       • Background: 12% accent color"
echo "       • Border:     25% accent color"
echo ""
echo "     AFTER:"
echo "       • Background: 8% accent color  ← MORE DIMMED!"
echo "       • Border:     15% accent color ← MORE DIMMED!"
echo ""

echo "🎯 What This Improves:"
echo "   ✅ Better focus differentiation"
echo "   ✅ Cleaner visual hierarchy"
echo "   ✅ Less distraction from unfocused workspaces"
echo "   ✅ More elegant subtle presence"
echo "   ✅ Enhanced focused workspace prominence"
echo ""

echo "🌟 Visual Impact:"
echo "   • Unfocused workspaces now blend more subtly with the bar"
echo "   • Focused workspace stands out more prominently"
echo "   • Overall cleaner, more professional appearance"
echo "   • Better visual flow across multiple workspaces"
echo ""

echo "🖥️  Color Examples with New Dimming:"
echo "   Monitor 1 (Blue):   $ACCENT_PRIMARY"
echo "     Focused:   Background ${ACCENT_PRIMARY/0xff/0x40}, Border ${ACCENT_PRIMARY/0xff/0x80}"
echo "     Unfocused: Background ${ACCENT_PRIMARY/0xff/0x15}, Border ${ACCENT_PRIMARY/0xff/0x25}"
echo ""
echo "   Monitor 2 (Green):  $ACCENT_SECONDARY"
echo "     Focused:   Background ${ACCENT_SECONDARY/0xff/0x40}, Border ${ACCENT_SECONDARY/0xff/0x80}"
echo "     Unfocused: Background ${ACCENT_SECONDARY/0xff/0x15}, Border ${ACCENT_SECONDARY/0xff/0x25}"
echo ""

echo "⚡ Performance Impact:"
echo "   • No performance change - same update speed"
echo "   • Only visual appearance enhanced"
echo "   • Same smart display logic maintained"
echo ""

echo "🎉 Result:"
echo "   Your unfocused workspaces are now more elegantly dimmed,"
echo "   creating better focus differentiation and a cleaner,"
echo "   more sophisticated visual hierarchy!"
echo ""

echo "💡 To see the enhanced dimming in action:"
echo "   • Restart AeroSpace if needed"
echo "   • Switch between workspaces"
echo "   • Notice the more subtle unfocused states"