#!/bin/bash
# Interactive menu for screen recording options

set -e

# First check status
"$HOME/.local/bin/screenshot-scripts/screenrecord-status.sh" > /dev/null 2>&1
STATUS=$?

if [ $STATUS -eq 0 ]; then
    # Recording is active, show stop option
    if command -v fuzzel &> /dev/null; then
        CHOICE=$(echo -e "Stop Recording\nCheck Status\nOpen Recordings Folder" | fuzzel --dmenu --prompt="Recording Active: ")

        case "$CHOICE" in
            "Stop Recording")
                "$HOME/.local/bin/screenshot-scripts/screenrecord-stop.sh"
                ;;
            "Check Status")
                "$HOME/.local/bin/screenshot-scripts/screenrecord-status.sh"
                read -p "Press Enter to continue..."
                ;;
            "Open Recordings Folder")
                if command -v thunar &> /dev/null; then
                    thunar "$HOME/Videos/ScreenRecordings" &
                elif command -v nautilus &> /dev/null; then
                    nautilus "$HOME/Videos/ScreenRecordings" &
                else
                    echo "Recordings are saved in: $HOME/Videos/ScreenRecordings"
                    read -p "Press Enter to continue..."
                fi
                ;;
            *)
                echo "Cancelled"
                ;;
        esac
    else
        # Terminal menu
        echo "=== Screen Recording Menu (Active) ==="
        echo "1) Stop Recording"
        echo "2) Check Status"
        echo "3) Open Recordings Folder"
        echo "4) Cancel"
        echo ""
        read -p "Select option (1-4): " CHOICE

        case "$CHOICE" in
            1)
                "$HOME/.local/bin/screenshot-scripts/screenrecord-stop.sh"
                ;;
            2)
                "$HOME/.local/bin/screenshot-scripts/screenrecord-status.sh"
                read -p "Press Enter to continue..."
                ;;
            3)
                if command -v thunar &> /dev/null; then
                    thunar "$HOME/Videos/ScreenRecordings" &
                elif command -v nautilus &> /dev/null; then
                    nautilus "$HOME/Videos/ScreenRecordings" &
                else
                    echo "Recordings are saved in: $HOME/Videos/ScreenRecordings"
                    read -p "Press Enter to continue..."
                fi
                ;;
            4)
                echo "Cancelled"
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    fi
else
    # No active recording, show start options
    if command -v fuzzel &> /dev/null; then
        CHOICE=$(echo -e "Full Screen\nSelected Region\nCheck Status\nOpen Recordings Folder" | fuzzel --dmenu --prompt="Start Recording: ")

        case "$CHOICE" in
            "Full Screen")
                "$HOME/.local/bin/screenshot-scripts/screenrecord-full.sh"
                ;;
            "Selected Region")
                "$HOME/.local/bin/screenshot-scripts/screenrecord-region.sh"
                ;;
            "Check Status")
                "$HOME/.local/bin/screenshot-scripts/screenrecord-status.sh"
                read -p "Press Enter to continue..."
                ;;
            "Open Recordings Folder")
                if command -v thunar &> /dev/null; then
                    thunar "$HOME/Videos/ScreenRecordings" &
                elif command -v nautilus &> /dev/null; then
                    nautilus "$HOME/Videos/ScreenRecordings" &
                else
                    echo "Recordings are saved in: $HOME/Videos/ScreenRecordings"
                    read -p "Press Enter to continue..."
                fi
                ;;
            *)
                echo "Cancelled"
                ;;
        esac
    else
        # Terminal menu
        echo "=== Screen Recording Menu ==="
        echo "1) Full Screen"
        echo "2) Selected Region"
        echo "3) Check Status"
        echo "4) Open Recordings Folder"
        echo "5) Cancel"
        echo ""
        read -p "Select option (1-5): " CHOICE

        case "$CHOICE" in
            1)
                "$HOME/.local/bin/screenshot-scripts/screenrecord-full.sh"
                ;;
            2)
                "$HOME/.local/bin/screenshot-scripts/screenrecord-region.sh"
                ;;
            3)
                "$HOME/.local/bin/screenshot-scripts/screenrecord-status.sh"
                read -p "Press Enter to continue..."
                ;;
            4)
                if command -v thunar &> /dev/null; then
                    thunar "$HOME/Videos/ScreenRecordings" &
                elif command -v nautilus &> /dev/null; then
                    nautilus "$HOME/Videos/ScreenRecordings" &
                else
                    echo "Recordings are saved in: $HOME/Videos/ScreenRecordings"
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
fi

