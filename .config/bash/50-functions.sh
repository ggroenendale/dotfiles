# ==================================================================================================
# SCREEN CAPTURE FUNCTIONS & ALIASES
# ==================================================================================================

# Screenshot functions
screenshot-full() {
    ~/.local/bin/screenshot-scripts/screenshot-full.sh
}

screenshot-region() {
    ~/.local/bin/screenshot-scripts/screenshot-region.sh
}

screenshot-window() {
    ~/.local/bin/screenshot-scripts/screenshot-window.sh
}

screenshot-menu() {
    ~/.local/bin/screenshot-scripts/screenshot-menu.sh
}

# Screen recording functions
screenrecord-full() {
    ~/.local/bin/screenshot-scripts/screenrecord-full.sh
}

screenrecord-region() {
    ~/.local/bin/screenshot-scripts/screenrecord-region.sh
}

screenrecord-stop() {
    ~/.local/bin/screenshot-scripts/screenrecord-stop.sh
}

screenrecord-status() {
    ~/.local/bin/screenshot-scripts/screenrecord-status.sh
}

screenrecord-menu() {
    ~/.local/bin/screenshot-scripts/screenrecord-menu.sh
}

# Quick aliases
alias ss-full="screenshot-full"
alias ss-region="screenshot-region"
alias ss-window="screenshot-window"
alias ss-menu="screenshot-menu"
alias sr-full="screenrecord-full"
alias sr-region="screenrecord-region"
alias sr-stop="screenrecord-stop"
alias sr-status="screenrecord-status"
alias sr-menu="screenrecord-menu"

# Open screenshot/recording directories
alias open-screenshots="thunar ~/Pictures/Screenshots 2>/dev/null || nautilus ~/Pictures/Screenshots 2>/dev/null || echo 'Screenshots directory: ~/Pictures/Screenshots'"
alias open-recordings="thunar ~/Videos/ScreenRecordings 2>/dev/null || nautilus ~/Videos/ScreenRecordings 2>/dev/null || echo 'Recordings directory: ~/Videos/ScreenRecordings'"

# Screenshot info
alias screenshot-help="echo '=== Screenshot Commands ==='; echo 'screenshot-full     - Full screen'; echo 'screenshot-region   - Select region'; echo 'screenshot-window   - Active window'; echo 'screenshot-menu     - Interactive menu'; echo ''; echo '=== Screen Recording Commands ==='; echo 'screenrecord-full   - Record full screen'; echo 'screenrecord-region - Record selected region'; echo 'screenrecord-stop   - Stop recording'; echo 'screenrecord-status - Check status'; echo 'screenrecord-menu   - Interactive menu'; echo ''; echo '=== Quick Aliases ==='; echo 'ss-*               - Short for screenshot-*'; echo 'sr-*               - Short for screenrecord-*'"

# Waybar functions
waybar-restart() {
    echo "Restarting Waybar..."
    killall waybar 2>/dev/null
    sleep 1
    nohup waybar >/dev/null 2>&1 &
    echo "Waybar restarted! (running in background with nohup)"
}

alias wb-restart="waybar-restart"

