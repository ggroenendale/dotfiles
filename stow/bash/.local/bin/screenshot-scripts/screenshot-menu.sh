#!/bin/bash
# Interactive menu for screenshot options

set -e

# Check if fuzzel is available for GUI menu
if command -v fuzzel &> /dev/null; then
    CHOICE=$(echo -e "Full Screen\nSelected Region\nActive Window\nOpen Screenshots Folder" | fuzzel --dmenu --prompt="Screenshot Options: ")

    case "$CHOICE" in
        "Full Screen")
            "$HOME/.local/bin/screenshot-scripts/screenshot-full.sh"
            ;;
        "Selected Region")
            "$HOME/.local/bin/screenshot-scripts/screenshot-region.sh"
            ;;
        "Active Window")
            "$HOME/.local/bin/screenshot-scripts/screenshot-window.sh"
            ;;
        "Open Screenshots Folder")
            if command -v thunar &> /dev/null; then
                thunar "$HOME/Pictures/Screenshots" &
            elif command -v nautilus &> /dev/null; then
                nautilus "$HOME/Pictures/Screenshots" &
            else
                echo "Screenshots are saved in: $HOME/Pictures/Screenshots"
                read -p "Press Enter to continue..."
            fi
            ;;
        *)
            echo "Cancelled"
            ;;
    esac
else
    # Fallback to terminal menu
    echo "=== Screenshot Menu ==="
    echo "1) Full Screen"
    echo "2) Selected Region"
    echo "3) Active Window"
    echo "4) Open Screenshots Folder"
    echo "5) Cancel"
    echo ""
    read -p "Select option (1-5): " CHOICE

    case "$CHOICE" in
        1)
            "$HOME/.local/bin/screenshot-scripts/screenshot-full.sh"
            ;;
        2)
            "$HOME/.local/bin/screenshot-scripts/screenshot-region.sh"
            ;;
        3)
            "$HOME/.local/bin/screenshot-scripts/screenshot-window.sh"
            ;;
        4)
            if command -v thunar &> /dev/null; then
                thunar "$HOME/Pictures/Screenshots" &
            elif command -v nautilus &> /dev/null; then
                nautilus "$HOME/Pictures/Screenshots" &
            else
                echo "Screenshots are saved in: $HOME/Pictures/Screenshots"
                read -p "Press Enter to continue..."
            fi
            ;;
        5)
            echo "Cancelled"
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
fi

