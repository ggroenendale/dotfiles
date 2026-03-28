# Screen Capture System for Wayland/Hyprland

A comprehensive screen capture and recording solution for Arch Linux with Wayland/Hyprland.

## Features

- **Screenshots**: Full screen, selected region, active window
- **Screen Recording**: Full screen and region selection
- **Clipboard Integration**: Automatically copies screenshots to clipboard
- **Notifications**: Desktop notifications for capture events
- **Organized Storage**: Date-based folder structure
- **Interactive Menus**: GUI and terminal menus for easy access
- **Command Line Access**: Bash functions and aliases
- **Hyprland Integration**: Keyboard shortcuts for all functions

## Installation

### 1. Required Packages

```bash
# Core packages (most are likely already installed)
sudo pacman -S grim slurp wl-clipboard

# Screen recording
sudo pacman -S wf-recorder

# Optional: GUI menu support
sudo pacman -S fuzzel
```

### 2. Setup

The system is already configured in your dotfiles. After running `stow .` from your dotfiles directory:

1. Scripts will be symlinked to `~/.local/bin/screenshot-scripts/`
2. Directories will be created:
   - `~/Pictures/Screenshots/`
   - `~/Videos/ScreenRecordings/`
3. Hyprland keybindings will be added
4. Bash functions and aliases will be available

## Usage

### Keyboard Shortcuts (Hyprland)

| Shortcut | Action |
|----------|--------|
| `PRINT` | Full screenshot (save + clipboard) |
| `SHIFT + PRINT` | Select region for screenshot |
| `SUPER + PRINT` | Capture active window |
| `SUPER + ALT + R` | Screen recording menu |
| `SUPER + SHIFT + R` | Stop screen recording |
| `SUPER + CTRL + P` | Full screenshot (hyprshot - legacy) |
| `SUPER + CTRL + [` | Region screenshot (hyprshot - legacy) |

### Command Line

#### Screenshots
```bash
screenshot-full      # Full screen
screenshot-region    # Select region
screenshot-window    # Active window
screenshot-menu      # Interactive menu

# Short aliases
ss-full
ss-region
ss-window
ss-menu
```

#### Screen Recording
```bash
screenrecord-full    # Record full screen
screenrecord-region  # Record selected region
screenrecord-stop    # Stop recording
screenrecord-status  # Check recording status
screenrecord-menu    # Interactive menu

# Short aliases
sr-full
sr-region
sr-stop
sr-status
sr-menu
```

#### Utility Commands
```bash
open-screenshots     # Open screenshots directory
open-recordings      # Open recordings directory
screenshot-help      # Show help with all commands
```

### Interactive Menus

Run `screenshot-menu` or `screenrecord-menu` for GUI menus (requires `fuzzel`). If `fuzzel` is not installed, terminal menus will be shown.

## File Organization

### Screenshots
```
~/Pictures/Screenshots/
├── screenshot-2024-01-15-143022.png
├── screenshot-region-2024-01-15-143045.png
└── screenshot-window-2024-01-15-143107.png
```

### Screen Recordings
```
~/Videos/ScreenRecordings/
├── recording-2024-01-15-143200.mp4
└── recording-region-2024-01-15-143215.mp4
```

## Technical Details

### Tools Used
- **grim**: Screenshot capture for Wayland
- **slurp**: Region selection
- **wl-clipboard**: Clipboard integration
- **wf-recorder**: Screen recording
- **hyprshot**: Legacy screenshot tool (fallback)

### Script Locations
- Main scripts: `~/.local/bin/screenshot-scripts/`
- Bash functions: `~/.config/bash/50-functions.sh`
- Hyprland config: `~/.config/hypr/hyprland.conf`

### PID Management
Screen recording uses a PID file (`~/.screenrecord.pid`) to track active recordings. The `screenrecord-status.sh` script checks this file.

## Troubleshooting

### Common Issues

1. **"grim not found"**
   ```bash
   sudo pacman -S grim
   ```

2. **"slurp not found"**
   ```bash
   sudo pacman -S slurp
   ```

3. **"wf-recorder not found"**
   ```bash
   sudo pacman -S wf-recorder
   ```

4. **No region selection appears**
   - Ensure `slurp` is installed
   - Try running `slurp` directly to test

5. **Clipboard not working**
   ```bash
   sudo pacman -S wl-clipboard
   ```

6. **Notifications not showing**
   - Ensure `mako` or another notification daemon is running
   - Install `libnotify` for `notify-send` support

### Testing
```bash
# Test script syntax
bash -n ~/.local/bin/screenshot-scripts/screenshot-full.sh

# Test core tools
which grim slurp wl-copy

# Test a screenshot (will actually capture)
screenshot-full
```

## Customization

### Changing Save Locations
Edit the scripts in `~/.local/bin/screenshot-scripts/` and update the `SCREENSHOT_DIR` and `RECORDING_DIR` variables.

### Adding New Keybindings
Edit `~/.config/hypr/hyprland.conf` and add new bind commands.

### Modifying Notification Behavior
The scripts use `notify-send` for notifications. You can modify the notification commands in each script.

## Legacy Support

The system maintains compatibility with the existing `hyprshot` tool. The original keybindings (`SUPER+CTRL+P` and `SUPER+CTRL+[`) continue to work.

## License

This screen capture system is part of your personal dotfiles configuration.

