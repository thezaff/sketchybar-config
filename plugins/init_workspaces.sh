#!/bin/bash

sleep 0.5
sketchybar --query bar 2>/dev/null | jq -r '.items[]?' 2>/dev/null | grep '^aerospace\.' | while read -r item; do
    if [[ -n "$item" ]]; then
        sketchybar --remove "$item" 2>/dev/null
    fi
done

sleep 0.2
"$CONFIG_DIR/plugins/workspace_sync.sh"