#!/bin/bash
# Region selection screen recording script for Wayland/Hyprland

set -e

# Configuration
RECORDING_DIR="$HOME/Videos/ScreenRecordings"
FILENAME="recording-region-$(date +'%Y-%m-%d-%H%M%S').mp4"
FILEPATH="$RECORDING_DIR/$FILENAME"
PID_FILE="$HOME/.screenrecord.pid"
LOG_FILE="$HOME/.screenrecord.log"

# Create directory if it doesn't exist
mkdir -p "$RECORDING_DIR"

# Check if already recording
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        echo "Error: Screen recording is already active (PID: $PID)"
        echo "Run $HOME/.local/bin/screenshot-scripts/screenrecord-stop.sh to stop it first."
        exit 1
    else
        # Clean up stale PID file
        rm -f "$PID_FILE"
    fi
fi

# Check for required tools
if ! command -v wf-recorder &> /dev/null; then
    echo "Error: wf-recorder not found. Please install wf-recorder for screen recording."
    echo "Install with: paru -S wf-recorder"
    exit 1
fi

if ! command -v slurp &> /dev/null; then
    echo "Error: slurp not found. Please install slurp for region selection."
    exit 1
fi

# Get region selection
echo "Select a region to record (click and drag)"
REGION=$(slurp 2>/dev/null)

# Check if user cancelled (ESC key)
if [ -z "$REGION" ]; then
    echo "Region selection cancelled"
    exit 0
fi

# Start recording
echo "Starting region recording..."
echo "Recording region: $REGION"
echo "Recording will be saved to: $FILEPATH"
echo "Press Ctrl+C or run screenrecord-stop.sh to stop recording."

# Start wf-recorder with region in background
wf-recorder -g "$REGION" -f "$FILEPATH" > "$LOG_FILE" 2>&1 &

# Save PID
RECORD_PID=$!
echo $RECORD_PID > "$PID_FILE"

# Send notification
if command -v notify-send &> /dev/null; then
    notify-send "Screen Recording Started" "Region recording in progress.\nFile: $FILENAME\n\nStop with: screenrecord-stop.sh"
fi

echo "Recording started with PID: $RECORD_PID"
echo "To stop recording, run: $HOME/.local/bin/screenshot-scripts/screenrecord-stop.sh"
echo "To check status, run: $HOME/.local/bin/screenshot-scripts/screenrecord-status.sh"

# Wait for recording to finish (user will stop it with stop script)
wait $RECORD_PID

