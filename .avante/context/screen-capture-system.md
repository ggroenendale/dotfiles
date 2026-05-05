---
title: "Screen Capture System"
description: "Comprehensive screenshot and screen recording system for Wayland/Hyprland with Waybar integration"
tags: [screenshot, screen-recording, wayland, hyprland, waybar, automation]
category: "Utilities"
created: "2026-04-19"
last_edited: "2026-04-19"
version: "1.0"
author: "Geoff"
status: "Published"
---

# Screen Capture System

## Overview
A comprehensive screen capture system for Wayland/Hyprland environments that provides screenshot capture, screen recording, and seamless integration with the Waybar status bar. The system supports multiple capture modes, organized storage, and one-click access from the desktop interface.

## System Architecture

### Core Components
1. **Capture Tools**: grim (screenshots), wf-recorder (screen recording), slurp (region selection)
2. **Clipboard Integration**: wl-clipboard for Wayland clipboard operations
3. **Hyprland Integration**: hyprctl for window information and control
4. **Waybar Integration**: Custom module with dual-click functionality
5. **Script Management**: Bash scripts for all capture operations

### Directory Structure
```
.local/bin/screenshot-scripts/
├── screenshot-full.sh          # Full screen capture
├── screenshot-region.sh        # Region selection capture
├── screenshot-window.sh        # Active window capture
├── screenshot-menu.sh          # Interactive screenshot menu
├── screenrecord-full.sh        # Full screen recording
├── screenrecord-region.sh      # Region-based recording
├── screenrecord-stop.sh        # Stop recording
├── screenrecord-status.sh      # Check recording status
├── screenrecord-menu.sh        # Interactive recording menu
└── README.md                   # System documentation

Pictures/Screenshots/           # Screenshot storage
Videos/ScreenRecordings/        # Recording storage
```

## Capture Modes

### Screenshot Modes
1. **Full Screen**: Capture entire screen (PRINT key)
2. **Region Selection**: Interactive region selection (SHIFT+PRINT)
3. **Active Window**: Capture currently focused window (SUPER+PRINT)
4. **Interactive Menu**: GUI menu with all options (Waybar button)

### Screen Recording Modes
1. **Full Screen Recording**: Record entire screen
2. **Region Recording**: Record selected region
3. **Recording Control**: Start/stop/status commands
4. **Interactive Menu**: GUI menu for recording operations

## Keybindings Configuration

### Hyprland Configuration (.config/hypr/hyprland.conf)
```ini
# Screenshot keybindings
bind = , PRINT, exec, ~/.local/bin/screenshot-scripts/screenshot-full.sh
bind = SHIFT, PRINT, exec, ~/.local/bin/screenshot-scripts/screenshot-region.sh
bind = SUPER, PRINT, exec, ~/.local/bin/screenshot-scripts/screenshot-window.sh

# Screen recording keybindings
bind = SUPER ALT, R, exec, ~/.local/bin/screenshot-scripts/screenrecord-menu.sh
bind = SUPER SHIFT, R, exec, ~/.local/bin/screenshot-scripts/screenrecord-stop.sh

# Legacy hyprshot compatibility (maintained)
bind = , 107, exec, hyprshot -m output -o ~/Pictures/Screenshots
bind = SHIFT, 107, exec, hyprshot -m region -o ~/Pictures/Screenshots
bind = SUPER, 107, exec, hyprshot -m window -o ~/Pictures/Screenshots
```

## Waybar Integration

### Module Configuration (.config/waybar/config.jsonc)
```json
"custom/screenshot": {
    "format": "  ",
    "on-click": "~/.local/bin/screenshot-scripts/screenshot-menu.sh",
    "on-click-right": "~/.local/bin/screenshot-scripts/screenrecord-menu.sh",
    "tooltip": true,
    "tooltip-format": "Screenshot Menu (Left Click)\nScreen Record Menu (Right Click)"
}
```

### CSS Styling (.config/waybar/style.css)
```css
#custom-screenshot {
    background-color: #f5c2e7;
    border-radius: 8px;
    margin: 4px 2px;
    padding: 0 8px;
}
```

### User Experience
- **Left Click**: Opens screenshot menu (full screen, region, window, folder)
- **Right Click**: Opens screen recording menu (start/stop recording, status, folder)
- **Hover**: Shows tooltip with usage instructions
- **Visual**: Pink camera icon () matching Waybar color scheme

## Script Details

### Screenshot Scripts

#### screenshot-full.sh
- Captures entire screen using grim
- Copies to clipboard with wl-copy
- Saves to `~/Pictures/Screenshots/` with timestamp
- Shows desktop notification on completion

#### screenshot-region.sh
- Uses slurp for interactive region selection
- Supports clipboard and file save
- Visual feedback during selection
- Cancel with ESC key

#### screenshot-window.sh
- Uses hyprctl to get active window information
- Captures specific window region
- Handles window borders and decorations
- Works with floating and tiled windows

#### screenshot-menu.sh
- Interactive menu using fuzzel (or terminal menu fallback)
- Provides all screenshot options in one interface
- Includes "Open Screenshots Folder" option
- User-friendly interface

### Screen Recording Scripts

#### screenrecord-full.sh
- Uses wf-recorder for screen recording
- Saves to `~/Videos/ScreenRecordings/` with timestamp
- Supports various codecs and quality settings
- Manages recording PID for control

#### screenrecord-region.sh
- Combines slurp region selection with wf-recorder
- Interactive region selection before recording
- Visual feedback during region selection
- Same quality options as full recording

#### screenrecord-stop.sh
- Gracefully stops active recording
- Sends SIGINT to wf-recorder process
- Shows notification when recording stops
- Cleans up PID file

#### screenrecord-status.sh
- Checks if recording is in progress
- Shows current recording status
- Provides information about active recording
- Useful for scripting and automation

#### screenrecord-menu.sh
- Interactive menu for all recording operations
- Start/stop recording options
- Status check and folder access
- User-friendly interface

## Bash Integration

### Functions and Aliases (.config/bash/50-functions.sh)
```bash
# Screenshot aliases
alias ss-full='~/.local/bin/screenshot-scripts/screenshot-full.sh'
alias ss-region='~/.local/bin/screenshot-scripts/screenshot-region.sh'
alias ss-window='~/.local/bin/screenshot-scripts/screenshot-window.sh'
alias ss-menu='~/.local/bin/screenshot-scripts/screenshot-menu.sh'

# Screen recording aliases
alias sr-full='~/.local/bin/screenshot-scripts/screenrecord-full.sh'
alias sr-region='~/.local/bin/screenshot-scripts/screenrecord-region.sh'
alias sr-stop='~/.local/bin/screenshot-scripts/screenrecord-stop.sh'
alias sr-status='~/.local/bin/screenshot-scripts/screenrecord-status.sh'
alias sr-menu='~/.local/bin/screenshot-scripts/screenrecord-menu.sh'

# Utility commands
alias open-screenshots='xdg-open ~/Pictures/Screenshots/'
alias open-recordings='xdg-open ~/Videos/ScreenRecordings/'
alias screenshot-help='echo "Screenshot: ss-{full,region,window,menu}\nRecording: sr-{full,region,stop,status,menu}\nUtils: open-{screenshots,recordings}"'
```

### Screenshot Functions
```bash
# Quick screenshot to clipboard (no save)
screenshot-clip() {
    grim - | wl-copy
    notify-send "Screenshot" "Copied to clipboard" -i camera
}

# Screenshot with delay
screenshot-delay() {
    local delay=${1:-5}
    echo "Taking screenshot in $delay seconds..."
    sleep $delay
    ~/.local/bin/screenshot-scripts/screenshot-full.sh
}
```

## Storage Management

### File Naming Convention
```
Screenshots/YYYY-MM-DD_HH-MM-SS_screenshot.png
Recordings/YYYY-MM-DD_HH-MM-SS_recording.mp4
```

### Directory Structure
```
~/Pictures/Screenshots/
├── 2026-04-19_10-30-15_screenshot.png
├── 2026-04-19_11-45-22_screenshot.png
└── [organized by date]

~/Videos/ScreenRecordings/
├── 2026-04-19_14-20-10_recording.mp4
├── 2026-04-19_15-35-45_recording.mp4
└── [organized by date]
```

### Cleanup Script (Optional)
```bash
# Remove screenshots older than 30 days
find ~/Pictures/Screenshots -name "*.png" -mtime +30 -delete

# Remove recordings older than 90 days
find ~/Videos/ScreenRecordings -name "*.mp4" -mtime +90 -delete
```

## Installation Requirements

### Core Packages (Arch Linux)
```bash
# Screenshot tools
sudo pacman -S grim slurp wl-clipboard

# Screen recording
sudo pacman -S wf-recorder

# Optional: GUI menu (fuzzel)
sudo pacman -S fuzzel

# Hyprland tools (if using Hyprland)
sudo pacman -S hyprland hyprctl
```

### Directory Setup
```bash
# Create script directory
mkdir -p ~/.local/bin/screenshot-scripts

# Create storage directories
mkdir -p ~/Pictures/Screenshots
mkdir -p ~/Videos/ScreenRecordings

# Make scripts executable
chmod +x ~/.local/bin/screenshot-scripts/*.sh
```

## Usage Examples

### Command Line Usage
```bash
# Take full screenshot
ss-full

# Take region screenshot
ss-region

# Record full screen
sr-full

# Stop recording
sr-stop

# Open screenshots folder
open-screenshots
```

### Interactive Menus
```bash
# Open screenshot menu (GUI or terminal)
ss-menu

# Open screen recording menu
sr-menu
```

### Integration with Other Tools
```bash
# Screenshot and immediately edit in GIMP
ss-full && gimp ~/Pictures/Screenshots/$(ls -t ~/Pictures/Screenshots/ | head -1)

# Record tutorial and compress
sr-full
# Later: ffmpeg -i recording.mp4 -vcodec libx265 -crf 28 compressed.mp4
```

## Troubleshooting

### Common Issues

#### 1. grim/slurp Not Working
```bash
# Check Wayland session
echo $XDG_SESSION_TYPE

# Test grim directly
grim -g "0,0 100x100" test.png

# Test slurp selection
slurp
```

#### 2. wf-recorder Issues
```bash
# Check wf-recorder installation
wf-recorder --version

# Test recording (5 seconds)
wf-recorder -g "$(slurp)" -f test.mp4 &
sleep 5
pkill wf-recorder
```

#### 3. Waybar Button Not Working
```bash
# Check script permissions
ls -la ~/.local/bin/screenshot-scripts/

# Test script directly
~/.local/bin/screenshot-scripts/screenshot-menu.sh

# Check Waybar configuration
cat ~/.config/waybar/config.jsonc | grep -A5 "custom/screenshot"
```

#### 4. Clipboard Issues
```bash
# Test wl-copy/wl-paste
echo "test" | wl-copy
wl-paste

# Check clipboard manager is running
ps aux | grep wl-paste
```

### Debug Commands
```bash
# View script output with debug
bash -x ~/.local/bin/screenshot-scripts/screenshot-full.sh

# Check environment variables
env | grep -E "(WAYLAND|XDG)"

# Test notification system
notify-send "Test" "Notification system working" -i dialog-information
```

## Performance Considerations

### Screenshot Performance
- grim is optimized for Wayland and typically very fast
- Region selection adds minimal overhead
- Clipboard operations are asynchronous

### Recording Performance
- wf-recorder performance depends on codec and quality settings
- Recommended: libx264 for compatibility, libx265 for efficiency
- Adjust frame rate and quality based on use case
- Monitor disk space for long recordings

### Memory Usage
- Scripts are lightweight with minimal memory footprint
- wf-recorder memory usage scales with resolution and frame rate
- Consider RAM availability for high-resolution recordings

## Source Code References

### Tool Repositories
- **grim**: https://github.com/emersion/grim
- **slurp**: https://github.com/emersion/slurp
- **wf-recorder**: https://github.com/ammen99/wf-recorder
- **wl-clipboard**: https://github.com/bugaevc/wl-clipboard
- **hyprshot**: https://github.com/Gustash/hyprshot

### Related Projects
- **Waybar**: https://github.com/Alexays/Waybar
- **Hyprland**: https://github.com/hyprwm/Hyprland
- **fuzzel**: https://codeberg.org/dnkl/fuzzel

## Security Considerations

### File Permissions
- Screenshots stored in user's Pictures directory
- Recordings stored in user's Videos directory
- Scripts executable only by owner
- No elevated privileges required

### Privacy
- Screenshots may contain sensitive information
- Consider automatic cleanup for temporary screenshots
- Be mindful of recording content
- Store sensitive captures in encrypted directories if needed

### Network Usage
- Local system only, no network transmission
- Optional: Scripts could be extended for cloud backup
- Current implementation is entirely local

## Future Enhancements

### Planned Features
1. **Cloud Integration**: Automatic backup to cloud storage
2. **Annotation Tools**: Basic image annotation after capture
3. **Video Editing**: Simple trim/crop of recordings
4. **OCR Integration**: Extract text from screenshots
5. **Workflow Automation**: Integration with task management systems

### Possible Integrations
- **Neovim**: Direct screenshot insertion into markdown files
- **Task Managers**: Automatic screenshot attachment to tasks
- **Documentation**: Screenshot-based documentation generation
- **Testing**: Automated screenshot comparison for UI testing

## Related Documents
- [Hyprland Configuration](./hyprland-configuration.md) - Desktop environment setup
- [Waybar Configuration](./waybar-configuration.md) - Status bar configuration
- [Bash Configuration](./bash-configuration.md) - Shell environment and functions
- [Development Workflow](./development-workflow.md) - Integration with daily work

---

*This screen capture system provides comprehensive screenshot and recording capabilities for Wayland/Hyprland environments with seamless desktop integration and efficient workflow. Last updated: 2026-04-19*

