#!/bin/bash
# Stop screen recording script

set -e

PID_FILE="$HOME/.screenrecord.pid"
LOG_FILE="$HOME/.screenrecord.log"

if [ ! -f "$PID_FILE" ]; then
    echo "No active screen recording found."
    exit 0
fi

PID=$(cat "$PID_FILE")

if kill -0 "$PID" 2>/dev/null; then
    echo "Stopping screen recording (PID: $PID)..."

    # Send SIGINT to wf-recorder (graceful stop)
    kill -SIGINT "$PID"

    # Wait for process to terminate
    sleep 1

    if kill -0 "$PID" 2>/dev/null; then
        echo "Process still running, forcing termination..."
        kill -9 "$PID" 2>/dev/null
    fi

    # Clean up PID file
    rm -f "$PID_FILE"

    # Get recording file from log
    if [ -f "$LOG_FILE" ]; then
        RECORDING_FILE=$(grep -o "Recording to: .*" "$LOG_FILE" 2>/dev/null | cut -d' ' -f3- || \
                        grep -o "output file: .*" "$LOG_FILE" 2>/dev/null | cut -d' ' -f3-)

        if [ -n "$RECORDING_FILE" ] && [ -f "$RECORDING_FILE" ]; then
            FILE_SIZE=$(du -h "$RECORDING_FILE" | cut -f1)
            echo "Recording saved to: $RECORDING_FILE"
            echo "File size: $FILE_SIZE"

            # Send notification
            if command -v notify-send &> /dev/null; then
                notify-send "Screen Recording Stopped" "Recording saved:\n$(basename "$RECORDING_FILE")\nSize: $FILE_SIZE"
            fi
        fi
    fi

    echo "Screen recording stopped successfully."
else
    echo "Stale PID file found. Cleaning up..."
    rm -f "$PID_FILE"
    echo "Cleanup complete."
fi

