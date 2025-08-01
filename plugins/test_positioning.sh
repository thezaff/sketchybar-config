#!/bin/bash

echo "🔄 Testing Workspace Positioning"
echo "================================"
echo ""

echo "Removing existing workspace items:"
for item in $(sketchybar --query bar | jq -r '.items[]' | grep '^aerospace\.'); do
    echo "  Removing $item"
    sketchybar --remove "$item"
done

echo ""
echo "Current order after removal:"
sketchybar --query bar | jq -r '.items[]' | grep -E '^(apple\.|aerospace\.|separator|front_app)' | sed 's/^/  /'

echo ""
echo "Running workspace sync to recreate them:"
./workspace_sync.sh

echo ""
echo "New order after recreation:"
sketchybar --query bar | jq -r '.items[]' | grep -E '^(apple\.|aerospace\.|separator|front_app)' | sed 's/^/  /'

echo ""
echo "✅ If workspaces now appear after apple.logo and before separator, positioning works!"
echo "❌ If they still appear at the end, we need a different approach."