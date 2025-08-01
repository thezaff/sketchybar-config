#!/bin/bash

# Test script for the enhanced workspace system
# Verifies functionality and performance

echo "🧪 Testing Enhanced AeroSpace + SketchyBar Workspace System"
echo "============================================================"

# Test 1: Check if aerospace is running
echo "📋 Test 1: Checking AeroSpace availability..."
if command -v aerospace >/dev/null 2>&1; then
    echo "✅ AeroSpace command found"
    if aerospace list-workspaces --all >/dev/null 2>&1; then
        echo "✅ AeroSpace is running and responsive"
    else
        echo "❌ AeroSpace not running or not responsive"
        exit 1
    fi
else
    echo "❌ AeroSpace command not found"
    exit 1
fi

# Test 2: Check if sketchybar is running
echo ""
echo "📋 Test 2: Checking SketchyBar availability..."
if command -v sketchybar >/dev/null 2>&1; then
    echo "✅ SketchyBar command found"
    if sketchybar --query bar >/dev/null 2>&1; then
        echo "✅ SketchyBar is running and responsive"
    else
        echo "❌ SketchyBar not running or not responsive"
        exit 1
    fi
else
    echo "❌ SketchyBar command not found"
    exit 1
fi

# Test 3: Check script files
echo ""
echo "📋 Test 3: Checking script files..."
scripts=(
    "aerospace_workspace_update.sh"
    "workspace_sync.sh" 
    "init_workspaces.sh"
)

for script in "${scripts[@]}"; do
    script_path="$HOME/.config/sketchybar/plugins/$script"
    if [[ -f "$script_path" && -x "$script_path" ]]; then
        echo "✅ $script exists and is executable"
    else
        echo "❌ $script missing or not executable"
    fi
done

# Test 4: Performance test
echo ""
echo "📋 Test 4: Performance testing..."
echo "Measuring workspace listing performance..."

start_time=$(date +%s%N)
aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}|%{workspace-is-focused}' >/dev/null
end_time=$(date +%s%N)
duration=$((end_time - start_time))
duration_ms=$((duration / 1000000))

echo "⏱️  Workspace listing took: ${duration_ms}ms"

if [[ $duration_ms -lt 100 ]]; then
    echo "✅ Performance excellent (< 100ms)"
elif [[ $duration_ms -lt 300 ]]; then
    echo "✅ Performance good (< 300ms)"
else
    echo "⚠️  Performance could be better (${duration_ms}ms)"
fi

# Test 5: Test the workspace update script
echo ""
echo "📋 Test 5: Testing workspace update script..."
export AEROSPACE_FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused --format '%{workspace}')
export AEROSPACE_PREV_WORKSPACE=""

start_time=$(date +%s%N)
"$HOME/.config/sketchybar/plugins/aerospace_workspace_update.sh"
end_time=$(date +%s%N)
duration=$((end_time - start_time))
duration_ms=$((duration / 1000000))

echo "⏱️  Workspace update took: ${duration_ms}ms"

if [[ $duration_ms -lt 200 ]]; then
    echo "✅ Update performance excellent (< 200ms)"
elif [[ $duration_ms -lt 500 ]]; then
    echo "✅ Update performance good (< 500ms)"
else
    echo "⚠️  Update performance could be better (${duration_ms}ms)"
fi

# Test 6: Check current workspace items
echo ""
echo "📋 Test 6: Checking current workspace items..."
workspace_items=$(sketchybar --query bar 2>/dev/null | jq -r '.items[]?' 2>/dev/null | grep '^aerospace\.' | wc -l)
echo "📊 Found $workspace_items aerospace workspace items"

if [[ $workspace_items -gt 0 ]]; then
    echo "✅ Workspace items are being created"
    sketchybar --query bar 2>/dev/null | jq -r '.items[]?' 2>/dev/null | grep '^aerospace\.' | head -5 | while read -r item; do
        echo "   • $item"
    done
else
    echo "⚠️  No workspace items found - this might be normal if no workspaces are active"
fi

echo ""
echo "🎉 Testing completed!"
echo ""
echo "💡 Tips:"
echo "   • Use 'sketchybar --reload' to restart SketchyBar with new config"
echo "   • Use '$HOME/.config/sketchybar/plugins/workspace_sync.sh' to manually sync"
echo "   • Check logs with: 'log stream --predicate \"process == \\\"sketchybar\\\"\"'"