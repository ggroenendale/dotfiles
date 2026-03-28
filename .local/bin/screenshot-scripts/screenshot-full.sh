#!/bin/bash
# Full screen screenshot script for Wayland/Hyprland
# Saves to file and copies to clipboard

set -e

# Configuration
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
FILENAME="screenshot-$(date +'%Y-%m-%d-%H%M%S').png"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

# Create directory if it doesn't exist
mkdir -p "$SCREENSHOT_DIR"

# Take screenshot
if command -v grim &> /dev/null; then
    # Capture full screen
    grim "$FILEPATH"

    # Copy to clipboard
    if command -v wl-copy &> /dev/null; then
        wl-copy < "$FILEPATH"
    fi

    # Send notification
    if command -v notify-send &> /dev/null; then
        notify-send "Screenshot Captured" "Full screen saved to:\n$FILENAME" -i "$FILEPATH"
    elif command -v makoctl &> /dev/null; then
        # Alternative notification for mako
        echo "Screenshot saved: $FILEPATH"
    fi

    echo "Screenshot saved to: $FILEPATH"
    echo "Copied to clipboard"
else
    echo "Error: grim not found. Please install grim for Wayland screenshots."
    exit 1
fi

