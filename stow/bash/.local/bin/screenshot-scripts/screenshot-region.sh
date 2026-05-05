#!/bin/bash
# Interactive region selection screenshot script for Wayland/Hyprland
# Saves to file and copies to clipboard

set -e

# Configuration
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
FILENAME="screenshot-region-$(date +'%Y-%m-%d-%H%M%S').png"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

# Create directory if it doesn't exist
mkdir -p "$SCREENSHOT_DIR"

# Check for required tools
if ! command -v grim &> /dev/null; then
    echo "Error: grim not found. Please install grim for Wayland screenshots."
    exit 1
fi

if ! command -v slurp &> /dev/null; then
    echo "Error: slurp not found. Please install slurp for region selection."
    exit 1
fi

# Get region selection
REGION=$(slurp 2>/dev/null)

# Check if user cancelled (ESC key)
if [ -z "$REGION" ]; then
    echo "Region selection cancelled"
    exit 0
fi

# Take screenshot of selected region
grim -g "$REGION" "$FILEPATH"

# Copy to clipboard
if command -v wl-copy &> /dev/null; then
    wl-copy < "$FILEPATH"
fi

# Send notification
if command -v notify-send &> /dev/null; then
    notify-send "Screenshot Captured" "Selected region saved to:\n$FILENAME" -i "$FILEPATH"
elif command -v makoctl &> /dev/null; then
    # Alternative notification for mako
    echo "Region screenshot saved: $FILEPATH"
fi

echo "Region screenshot saved to: $FILEPATH"
echo "Copied to clipboard"

