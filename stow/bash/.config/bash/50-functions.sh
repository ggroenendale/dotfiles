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

# ==================================================================================================
# SSH SERVER MANAGEMENT
# ==================================================================================================

# SSH connection manager - interactive menu
ssh-connect() {
    ~/.local/bin/ssh-scripts/ssh-connect.sh "$@"
}

# List all SSH hosts from config
ssh-list() {
    ~/.local/bin/ssh-scripts/ssh-list.sh "$@"
}

# Quick connect aliases for specific servers
alias node-01="ssh node-01"
alias node-02="ssh node-02"
alias node-40="ssh node-40"
alias node-41="ssh node-41"
alias node-51="ssh node-51"
alias node-53="ssh node-53"
alias node-78="ssh node-78"
alias node-101="ssh node-101"
alias node-118="ssh node-118"
alias node-119="ssh node-119"
alias node-135="ssh node-135"
alias gateway="ssh gateway"

# Legacy aliases
alias server-node-1="ssh server_node_1"
alias server-node-2="ssh server_node_2"

# SSH help
alias ssh-help="echo '=== SSH Commands ==='; echo 'ssh-connect     - Interactive SSH connection menu'; echo 'ssh-list       - List all hosts with status'; echo 'ssh-connect -g - Fuzzel GUI menu'; echo 'ssh-connect -d <ip> - Connect to arbitrary IP'; echo ''; echo '=== Quick Connect ==='; echo 'node-XX        - ssh node-XX (e.g. node-01, node-02)'; echo 'gateway        - ssh gateway'; echo 'ssh <tab>      - Tab-complete hostnames from SSH config'"

