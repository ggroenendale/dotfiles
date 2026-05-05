#!/bin/bash
# Screen recording status and control script

PID_FILE="$HOME/.screenrecord.pid"
LOG_FILE="$HOME/.screenrecord.log"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        echo "Screen recording is ACTIVE (PID: $PID)"
        echo "Log file: $LOG_FILE"
        echo "To stop recording, run: $HOME/.local/bin/screenshot-scripts/screenrecord-stop.sh"
        return 0
    else
        # Clean up stale PID file
        rm -f "$PID_FILE"
        echo "Screen recording is INACTIVE (stale PID file cleaned)"
        return 1
    fi
else
    echo "Screen recording is INACTIVE"
    return 1
fi

