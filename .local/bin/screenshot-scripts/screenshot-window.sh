#!/bin/bash
# Active window screenshot script for Wayland/Hyprland
# Saves to file and copies to clipboard

set -e

# Configuration
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
FILENAME="screenshot-window-$(date +'%Y-%m-%d-%H%M%S').png"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

# Create directory if it doesn't exist
mkdir -p "$SCREENSHOT_DIR"

# Check for required tools
if ! command -v grim &> /dev/null; then
    echo "Error: grim not found. Please install grim for Wayland screenshots."
    exit 1
fi

# Try to get active window geometry using hyprctl (for Hyprland)
if command -v hyprctl &> /dev/null; then
    # Get active window information
    ACTIVE_WINDOW=$(hyprctl activewindow -j)

    if [ -n "$ACTIVE_WINDOW" ] && [ "$ACTIVE_WINDOW" != "{}" ]; then
        # Parse JSON to get window geometry
        X=$(echo "$ACTIVE_WINDOW" | grep -o '"at":\[[0-9]*,[0-9]*\]' | cut -d'[' -f2 | cut -d',' -f1)
        Y=$(echo "$ACTIVE_WINDOW" | grep -o '"at":\[[0-9]*,[0-9]*\]' | cut -d'[' -f2 | cut -d',' -f2 | cut -d']' -f1)
        WIDTH=$(echo "$ACTIVE_WINDOW" | grep -o '"size":\[[0-9]*,[0-9]*\]' | cut -d'[' -f2 | cut -d',' -f1)
        HEIGHT=$(echo "$ACTIVE_WINDOW" | grep -o '"size":\[[0-9]*,[0-9]*\]' | cut -d'[' -f2 | cut -d',' -f2 | cut -d']' -f1)

        if [ -n "$X" ] && [ -n "$Y" ] && [ -n "$WIDTH" ] && [ -n "$HEIGHT" ]; then
            # Capture the window
            grim -g "${X},${Y} ${WIDTH}x${HEIGHT}" "$FILEPATH"

            # Copy to clipboard
            if command -v wl-copy &> /dev/null; then
                wl-copy < "$FILEPATH"
            fi

            # Send notification
            if command -v notify-send &> /dev/null; then
                notify-send "Screenshot Captured" "Active window saved to:\n$FILENAME" -i "$FILEPATH"
            elif command -v makoctl &> /dev/null; then
                echo "Window screenshot saved: $FILEPATH"
            fi

            echo "Window screenshot saved to: $FILEPATH"
            echo "Copied to clipboard"
            exit 0
        fi
    fi
fi

# Fallback: use slurp to select window manually
echo "Could not automatically detect active window. Please select the window manually."
echo "Press Enter to continue..."
read -r

if command -v slurp &> /dev/null; then
    REGION=$(slurp 2>/dev/null)

    if [ -z "$REGION" ]; then
        echo "Window selection cancelled"
        exit 0
    fi

    grim -g "$REGION" "$FILEPATH"

    # Copy to clipboard
    if command -v wl-copy &> /dev/null; then
        wl-copy < "$FILEPATH"
    fi

    # Send notification
    if command -v notify-send &> /dev/null; then
        notify-send "Screenshot Captured" "Selected window saved to:\n$FILENAME" -i "$FILEPATH"
    elif command -v makoctl &> /dev/null; then
        echo "Window screenshot saved: $FILEPATH"
    fi

    echo "Window screenshot saved to: $FILEPATH"
    echo "Copied to clipboard"
else
    echo "Error: Could not capture window. Please install slurp for manual selection."
    exit 1
fi

