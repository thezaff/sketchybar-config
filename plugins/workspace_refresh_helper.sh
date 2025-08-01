#!/usr/bin/env bash

# Helper script to ensure workspace refresh happens with proper timing
# This addresses timing issues with Aerospace triggers

# Small delay to ensure Aerospace has processed the workspace change
sleep 0.2

# Trigger the workspace refresh
sketchybar --trigger aerospace_refresh_workspaces