# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a SketchyBar configuration repository that creates a modern macOS menu bar with Aerospace window manager integration. The configuration features a rich color theme, multi-monitor support, and various system status widgets.

## Development Commands

### SketchyBar Management
- **Restart SketchyBar**: `./restart.sh` - Kills existing instances and starts with current config
- **Reload Configuration**: `sketchybar --reload`
- **Check Status**: `sketchybar --query bar` or `sketchybar --query <item_name>`

### C Helper Binary
- **Build Helper**: `cd helper && make` - Compiles the C helper for CPU monitoring
- **Clean Build**: `cd helper && rm -f helper && make`

### Testing Changes
- **Test Single Plugin**: `bash plugins/<plugin_name>.sh` - Run plugin directly for testing
- **Debug Item**: `sketchybar --query <item_name>` - Check item configuration and state

## Architecture

### Core Configuration Structure

**Main Configuration (`sketchybarrc`)**
- Bar appearance and default styling
- Item definitions with positioning (left/right)
- Plugin associations and event subscriptions
- Multi-monitor workspace indicators with Aerospace integration

**Theming System**
- `colors.sh`: Centralized color definitions with ultra-rich theme
- `icons.sh`: SF Symbols and Nerd Font icon mappings
- Colors sourced by all plugins for consistency

**Plugin Architecture**
- Each widget is a separate bash script in `plugins/`
- Plugins source `colors.sh` and `icons.sh` for consistent theming
- Event-driven updates through SketchyBar's subscription system

### Multi-Monitor Aerospace Integration

**Workspace Display Logic (`aerospace_display.sh`)**
- Maps Aerospace monitor IDs to logical names (M1=Built-in, M2=External)
- Caches workspace state in `/tmp/aerospace_display_state`
- Dynamic display adaptation based on connected monitors
- Visual focus indication with color/font changes

**Monitor Configuration**
- M1 (Monitor 1): Built-in Retina Display (Aerospace ID: 2)
- M2 (Monitor 2): External MAG 274UPF E2 (Aerospace ID: 1)
- Auto-detection of monitor connection status
- Workspace persistence across monitor changes

### Widget System

**System Widgets**
- `battery.sh`: Power status with color-coded charge levels
- `volume.sh`: Audio control with popup interface
- `wifi.sh` / `bluetooth.sh`: Connectivity status
- `clock.sh`: Time display with click actions

**Application Integration**
- `front_app.sh`: Current app display with icon mapping
- `now_playing.sh`: Media playback status
- Icon mapping for 20+ common applications

**Aerospace Integration**
- `aerospace.sh` / `aerospace_display.sh`: Workspace management
- `monitor_watcher.sh`: Monitor connection detection
- Event-driven workspace change notifications

### C Helper Binary

**Purpose**: High-performance system monitoring for CPU metrics
- `helper.c`: Main event handler and SketchyBar integration
- `cpu.h` / CPU implementation: System CPU percentage calculation
- `sketchybar.h`: SketchyBar C API bindings
- Compiled with: `clang -std=c99 -O3 helper.c -o helper`

## Configuration Notes

### Color Theme
Ultra-rich color scheme with deep, saturated colors:
- Primary accents: Blue (#82aaff), Green (#b9f27c), Orange (#ff966c), Purple (#c792ea)
- Battery states: 5-level color progression from green to critical red
- Background: Transparent bar with dark item backgrounds

### Font System
- Primary: SF Pro (Semibold 15.0 for icons, Medium 13.0 for labels)
- Workspace indicators: SF Pro Medium 12.0
- Consistent sizing across all widgets

### Event System
- `aerospace_workspace_change`: Triggered on workspace switches
- `front_app_switched`: App focus changes
- `volume_change`: Audio level changes
- `system_woke` / `power_source_change`: Power events

## Aerospace Configuration

The `.aerospace.toml` file configures:
- SketchyBar integration via `exec-on-workspace-change`
- Multi-monitor gap settings (40px top gap for 2K monitors)
- Workspace-to-monitor assignments
- Window management keybindings

## File Organization

```
├── sketchybarrc              # Main configuration
├── colors.sh / icons.sh     # Theming system
├── plugins/                 # Widget implementations
│   ├── aerospace_display.sh # Multi-monitor workspace logic
│   ├── front_app.sh        # Application tracking
│   └── [other widgets]
├── helper/                  # C performance components
└── aerospace-config/        # Aerospace WM integration
```

## Common Patterns

- All plugins source colors.sh and icons.sh for consistency
- Event subscriptions defined in sketchybarrc with `--subscribe`
- State caching used for persistence (e.g., workspace states)
- Color/font changes indicate active/inactive states
- Click scripts provide interactive functionality

## Claude's Expertise

- Unixporn Ricing Expert
  - Deep familiarity with bash and shell scripting
  - Extensive knowledge of Aerospace tiling window manager
  - Proficient with SketchyBar statusbar configuration
  - Uses context7 for advanced workflow management