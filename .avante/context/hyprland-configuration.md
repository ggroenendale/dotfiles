---
title: "Hyprland Configuration"
description: "Hyprland Wayland compositor configuration for Arch Linux with optimized window management, keybindings, and integration with other system components"
tags: [hyprland, wayland, compositor, window-manager, desktop]
category: "System Configuration"
created: "2026-04-19"
last_edited: "2026-04-19"
version: "1.0"
author: "Geoff"
status: "Published"
---

# Hyprland Configuration

## Overview
Hyprland is a dynamic tiling Wayland compositor that combines automatic tiling, stacking, and floating window layouts. This configuration provides an optimized desktop environment for development workflows with seamless integration of Neovim, screen capture, and other productivity tools.

## Configuration Structure

### Main Configuration File
```
.config/hypr/
├── hyprland.conf          # Primary configuration
├── hyprpaper.conf         # Wallpaper configuration (optional)
└── scripts/               # Hyprland-related scripts
```

### Configuration Philosophy
- **Developer-Focused**: Keybindings optimized for coding and system administration
- **Minimalist Aesthetic**: Clean interface with focus on content
- **Performance First**: Optimized for smooth animations and responsiveness
- **Integration Ready**: Designed to work with Neovim, Waybar, and screen capture tools

## Core Configuration

### Basic Settings (hyprland.conf)
```ini
# Monitor configuration
monitor=,preferred,auto,1

# Execute applications on startup
exec-once = waybar
exec-once = nm-applet --indicator
exec-once = blueman-applet
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

# Input configuration
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1
    touchpad {
        natural_scroll = no
    }
}

# General configuration
general {
    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    layout = dwindle
}

# Decoration (visual appearance)
decoration {
    rounding = 10

    blur {
        enabled = true
        size = 3
        passes = 1
    }

    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# Animations
animations {
    enabled = yes

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Window layout
dwindle {
    pseudotile = yes
    preserve_split = yes
}

master {
    new_is_master = true
}

# Gestures
gestures {
    workspace_swipe = on
}

# Window rules
windowrule = float, ^(kitty)$
windowrule = center, ^(kitty)$
windowrule = size 800 600, ^(kitty)$
```

## Keybindings Configuration

### Navigation and Window Management
```ini
# Basic movement
bind = SUPER, Q, killactive,
bind = SUPER SHIFT, Q, exit,
bind = SUPER, F, fullscreen,
bind = SUPER, Space, togglefloating,
bind = SUPER, P, pseudo, # dwindle
bind = SUPER, S, togglesplit, # dwindle

# Move focus with SUPER + vim keys
bind = SUPER, H, movefocus, l
bind = SUPER, L, movefocus, r
bind = SUPER, K, movefocus, u
bind = SUPER, J, movefocus, d

# Move windows with SUPER + SHIFT + vim keys
bind = SUPER SHIFT, H, movewindow, l
bind = SUPER SHIFT, L, movewindow, r
bind = SUPER SHIFT, K, movewindow, u
bind = SUPER SHIFT, J, movewindow, d

# Switch workspaces with SUPER + [0-9]
bind = SUPER, 1, workspace, 1
bind = SUPER, 2, workspace, 2
bind = SUPER, 3, workspace, 3
bind = SUPER, 4, workspace, 4
bind = SUPER, 5, workspace, 5
bind = SUPER, 6, workspace, 6
bind = SUPER, 7, workspace, 7
bind = SUPER, 8, workspace, 8
bind = SUPER, 9, workspace, 9
bind = SUPER, 0, workspace, 10

# Move active window to a workspace with SUPER + SHIFT + [0-9]
bind = SUPER SHIFT, 1, movetoworkspace, 1
bind = SUPER SHIFT, 2, movetoworkspace, 2
bind = SUPER SHIFT, 3, movetoworkspace, 3
bind = SUPER SHIFT, 4, movetoworkspace, 4
bind = SUPER SHIFT, 5, movetoworkspace, 5
bind = SUPER SHIFT, 6, movetoworkspace, 6
bind = SUPER SHIFT, 7, movetoworkspace, 7
bind = SUPER SHIFT, 8, movetoworkspace, 8
bind = SUPER SHIFT, 9, movetoworkspace, 9
bind = SUPER SHIFT, 0, movetoworkspace, 10
```

### Application Launchers
```ini
# Terminal
bind = SUPER, Return, exec, kitty

# Application launcher
bind = SUPER, D, exec, fuzzel

# Web browser
bind = SUPER, B, exec, firefox

# File manager
bind = SUPER, E, exec, nautilus

# Screenshot tools (screen capture system integration)
bind = , PRINT, exec, ~/.local/bin/screenshot-scripts/screenshot-full.sh
bind = SHIFT, PRINT, exec, ~/.local/bin/screenshot-scripts/screenshot-region.sh
bind = SUPER, PRINT, exec, ~/.local/bin/screenshot-scripts/screenshot-window.sh

# Screen recording (screen capture system integration)
bind = SUPER ALT, R, exec, ~/.local/bin/screenshot-scripts/screenrecord-menu.sh
bind = SUPER SHIFT, R, exec, ~/.local/bin/screenshot-scripts/screenrecord-stop.sh
```

### Special Functions
```ini
# Reload Hyprland configuration
bind = SUPER SHIFT, C, exec, hyprctl reload

# Lock screen
bind = SUPER, L, exec, swaylock

# Power menu
bind = SUPER, X, exec, wlogout --protocol layer-shell

# Clipboard manager
bind = SUPER, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy
```

## Workspace Strategy

### Workspace Layout
- **Workspace 1**: Terminal and shell (primary development)
- **Workspace 2**: Web browser and research
- **Workspace 3**: Neovim and code editing
- **Workspace 4**: Communication (Discord, Slack, etc.)
- **Workspace 5**: Media and entertainment
- **Workspace 6-10**: Project-specific or temporary workspaces

### Workspace Rules
```ini
# Assign applications to specific workspaces
windowrulev2 = workspace 1, class:^(kitty)$
windowrulev2 = workspace 2, class:^(firefox)$
windowrulev2 = workspace 2, class:^(Google-chrome)$
windowrulev2 = workspace 3, class:^(neovide)$
windowrulev2 = workspace 4, class:^(discord)$
windowrulev2 = workspace 4, class:^(slack)$
```

## Integration with Other Components

### Waybar Integration
- Hyprland provides workspace information to Waybar
- Waybar displays active workspace and window information
- Seamless visual integration with Hyprland aesthetics

### Screen Capture System
- Keybindings for screenshot and screen recording
- Integration with hyprctl for window information
- Works with Wayland native tools (grim, slurp, wf-recorder)

### Neovim Integration
- Optimized window management for editor workflows
- Workspace strategy supports development environment
- Keybindings designed to complement Neovim navigation

## Performance Optimization

### Graphics and Rendering
```ini
# Enable hardware acceleration
env = WLR_RENDERER,vulkan

# Reduce tearing
env = WLR_DRM_NO_ATOMIC,1

# Optimize for NVIDIA
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = __GL_GSYNC_ALLOWED,1
env = __GL_VRR_ALLOWED,1
env = WLR_DRM_NO_ATOMIC,1
env = WLR_NO_HARDWARE_CURSORS,1
```

### Memory and Resource Management
- Minimal background processes
- Efficient animation rendering
- Optimized compositor settings for development workloads

## Environment Variables

### Hyprland-Specific Variables
```bash
# Set in shell configuration (.bashrc or .zshrc)
export HYPRLAND_LOG_WLR=1
export XCURSOR_SIZE=24
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GDK_BACKEND=wayland
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export MOZ_ENABLE_WAYLAND=1
```

### Display Server Variables
```bash
# Wayland session
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_DESKTOP=Hyprland
```

## Scripts and Automation

### Hyprland Event Handlers
```bash
# Example: Execute script when workspace changes
exec-once = ~/.config/hypr/scripts/workspace-change-handler.sh
```

### Custom Scripts Directory
```
.config/hypr/scripts/
├── workspace-change-handler.sh
├── window-focus-logger.sh
├── layout-switcher.sh
└── performance-monitor.sh
```

### Example Script: Workspace Change Handler
```bash
#!/bin/bash
# Log workspace changes for debugging

WORKSPACE_LOG="$HOME/.cache/hyprland-workspace.log"

hyprctl monitor -j | jq -r '.[] | "\(.activeWorkspace.id) - \(.name)"' >> "$WORKSPACE_LOG"
```

## Troubleshooting

### Common Issues

#### 1. Display Issues
```bash
# Check monitor configuration
hyprctl monitors

# List available modes
hyprctl monitors -j | jq '.[].modes'

# Set specific monitor configuration
monitor=DP-1,2560x1440@144,0x0,1
```

#### 2. Input Device Problems
```bash
# List input devices
hyprctl devices

# Debug keyboard input
hyprctl keyword input:kb_layout us

# Check touchpad settings
hyprctl keyword input:touchpad:natural_scroll no
```

#### 3. Performance Issues
```bash
# Check Hyprland logs
journalctl -u hyprland -f

# Monitor resource usage
htop

# Disable specific features for testing
# Comment out blur, animations, or shadows
```

#### 4. Application Compatibility
```bash
# Force XWayland for problematic applications
env = GDK_BACKEND,x11  # For specific apps

# Check if application supports Wayland
echo $XDG_SESSION_TYPE

# Use xprop to check window properties
xprop | grep -i class
```

### Debug Commands
```bash
# Get Hyprland status
hyprctl version
hyprctl monitors
hyprctl workspaces
hyprctl clients

# Reload configuration
hyprctl reload

# Debug specific window
hyprctl activewindow

# List all keybindings
hyprctl binds
```

## Security Considerations

### Screen Locking
- Integrated with swaylock for screen locking
- Automatic lock on suspend
- Configurable lock timeout

### Session Security
- Wayland provides better security than X11
- Isolated client-server model
- Reduced attack surface compared to X11

### Privacy Features
- No remote access by default
- Clipboard management with cliphist
- Secure credential handling

## Backup and Migration

### Configuration Backup
```bash
# Backup Hyprland configuration
cp -r ~/.config/hypr/ ~/backups/hyprland-config-$(date +%Y%m%d)

# Export keybindings
hyprctl binds > ~/backups/hyprland-keybinds-$(date +%Y%m%d).txt
```

### Migration to New System
1. Copy `.config/hypr/` directory
2. Install required packages: hyprland, waybar, kitty, fuzzel
3. Set environment variables in shell configuration
4. Test configuration with `hyprctl reload`

## Source Code References

### Primary Repositories
- **Hyprland**: https://github.com/hyprwm/Hyprland
- **Hyprland Wiki**: https://wiki.hyprland.org/
- **Hyprland Config Examples**: https://github.com/hyprwm/Hyprland/tree/main/example

### Related Tools
- **Waybar**: https://github.com/Alexays/Waybar
- **Kitty**: https://github.com/kovidgoyal/kitty
- **Fuzzel**: https://codeberg.org/dnkl/fuzzel
- **Swaylock**: https://github.com/swaywm/swaylock

### Documentation
- **Hyprland Configuration**: https://wiki.hyprland.org/Configuring/Configuring-Hyprland/
- **Hyprland Keybindings**: https://wiki.hyprland.org/Configuring/Binds/
- **Wayland Protocol**: https://wayland.freedesktop.org/

## Customization and Extensions

### Theme Customization
- Modify colors in `col.active_border` and `col.inactive_border`
- Adjust rounding and shadow parameters
- Customize animation bezier curves

### Plugin System
Hyprland supports plugins for extended functionality:
- **hyprfocus**: Focus animation enhancements
- **hyprbars**: Custom window title bars
- **hyprland-per-window-layout**: Per-window layout management

### Community Configurations
- Explore https://github.com/topics/hyprland-config for inspiration
- Check r/hyprland on Reddit for user configurations
- Browse Hyprland forum for troubleshooting tips

## Related Documents
- [Waybar Configuration](./waybar-configuration.md) - Status bar setup
- [Screen Capture System](./screen-capture-system.md) - Screenshot/recording integration
- [Neovim Configuration](./neovim-configuration.md) - Editor setup
- [System Overview](./system-overview.md) - Overall architecture

---

*This Hyprland configuration provides a optimized Wayland desktop environment for development workflows with seamless integration of productivity tools and AI-assisted development. Last updated: 2026-04-19*

