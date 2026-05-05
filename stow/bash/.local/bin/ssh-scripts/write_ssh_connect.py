#!/usr/bin/env python3
"""Write ssh-connect.sh with proper bash content."""

import os

content = """#!/usr/bin/env bash
# ==============================================================================
# ssh-connect.sh - Interactive SSH connection manager
# ==============================================================================
# Connects to servers defined in ~/.ssh/config
# Supports: terminal menu, fuzzel GUI, or direct connect by name
# ==============================================================================

set -euo pipefail

# Colors
GREEN='\\033[0;32m'
YELLOW='\\033[1;33m'
RED='\\033[0;31m'
BLUE='\\033[0;34m'
CYAN='\\033[0;36m'
GRAY='\\033[0;90m'
NC='\\033[0m'

SSH_CONFIG="${HOME}/.ssh/config"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── Help ──────────────────────────────────────────────────────────────────────
show_help() {
    cat << 'HELPEOF'
Usage: ssh-connect [OPTIONS] [hostname]

SSH Connection Manager - Connect to servers from your SSH config.

OPTIONS:
  -l, --list       List all available hosts
  -m, --menu       Show interactive terminal menu to pick a host
  -g, --gui        Show fuzzel GUI menu to pick a host
  -d, --direct     Connect directly to an IP/hostname (not from config)
  -h, --help       Show this help message

EXAMPLES:
  ssh-connect              Interactive menu (auto-detect terminal vs GUI)
  ssh-connect -m           Force terminal menu
  ssh-connect -g           Force fuzzel GUI menu
  ssh-connect -l           List all hosts
  ssh-connect node-01     Connect directly to node-01
  ssh-connect -d 192.168.1.100  Connect to arbitrary IP
HELPEOF
}

# ── Parse SSH config ──────────────────────────────────────────────────────────
get_hosts() {
    awk '
    /^Host / {
        for (i=2; i<=NF; i++) {
            if ($i !~ /^[*!]/) {
                print $i
            }
        }
    }
    ' "$SSH_CONFIG"
}

get_hostname() {
    awk -v target="$1" '
    $1 == "Host" {
        for (i=2; i<=NF; i++) {
            if ($i == target) { found = 1; next }
        }
        found = 0
    }
    found && $1 == "HostName" { print $2; exit }
    ' "$SSH_CONFIG"
}

# ── Get host info via SSH (with caching) ──────────────────────────────────────
CACHE_DIR="${HOME}/.cache/ssh-list"
CACHE_FILE="${CACHE_DIR}/hosts.cache"
mkdir -p "$CACHE_DIR"

get_host_info() {
    local host="$1"
    local ip="$2"
    local cache_key="${host}|${ip}"

    # Check cache first
    if [[ -f "$CACHE_FILE" ]]; then
        local cached
        cached=$(grep "^${cache_key}|" "$CACHE_FILE" 2>/dev/null || true)
        if [[ -n "$cached" ]]; then
            echo "$cached" | cut -d'|' -f3-
            return
        fi
    fi

    local status="offline"
    local hostname=""
    local os=""

    if ping -c 1 -W 1 "$ip" &>/dev/null; then
        status="online"
        local info
        info=$(ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o BatchMode=yes \\
            -o LogLevel=ERROR -T "$host" \\
            "echo HOSTNAME=\\$(hostname); echo OS=\\$(. /etc/os-release 2>/dev/null && echo \\"\\$PRETTY_NAME\\" || echo unknown)" \\
            2>/dev/null || true)
        if [[ -n "$info" ]]; then
            hostname=$(echo "$info" | grep "^HOSTNAME=" | cut -d= -f2-)
            os=$(echo "$info" | grep "^OS=" | cut -d= -f2-)
        fi
    fi

    local result="${status}|${hostname}|${os}"
    echo "${cache_key}|${result}" >> "$CACHE_FILE"
    tail -n 50 "$CACHE_FILE" > "${CACHE_FILE}.tmp" && mv "${CACHE_FILE}.tmp" "$CACHE_FILE"

    echo "$result"
}

# ── Terminal interactive menu ─────────────────────────────────────────────────
terminal_menu() {
    local hosts=()
    while IFS= read -r host; do
        [[ -z "$host" ]] && continue
        hosts+=("$host")
    done < <(get_hosts)

    if [[ ${#hosts[@]} -eq 0 ]]; then
        echo -e "${RED}No hosts found in SSH config.${NC}"
        exit 1
    fi

    echo -e "${CYAN}===============================================${NC}"
    echo -e "${CYAN}         SSH CONNECTION MANAGER                ${NC}"
    echo -e "${CYAN}===============================================${NC}"
    echo ""

    local idx=1
    for host in "${hosts[@]}"; do
        local ip=$(get_hostname "$host")
        local info=$(get_host_info "$host" "${ip:-$host}")
        local status=$(echo "$info" | cut -d'|' -f1)
        local hostname=$(echo "$info" | cut -d'|' -f2)
        local os=$(echo "$info" | cut -d'|' -f3)

        local status_icon
        if [[ "$status" == "online" ]]; then
            status_icon="${GREEN}\●${NC}"
        else
            status_icon="${RED}\○${NC}"
        fi

        printf "  ${GREEN}%2d)${NC} %-12s ${GRAY}%-16s${NC} %b" "$idx" "$host" "${ip:-}" "$status_icon"
        if [[ -n "$hostname" ]]; then
            printf " ${GRAY}%s${NC}" "$hostname"
        fi
        if [[ -n "$os" ]]; then
            printf " ${YELLOW}(%s)${NC}" "$os"
        fi
        echo ""
        ((idx++))
    done

    echo ""
    echo -e "  ${YELLOW} q)${NC} Quit"
    echo ""

    local choice
    read -p "$(echo -e "${CYAN}Select host [1-$((idx-1))] or q: ${NC}")" choice

    if [[ "$choice" == "q" ]] || [[ "$choice" == "Q" ]]; then
        echo "Goodbye!"
        exit 0
    fi

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 ]] || [[ "$choice" -ge "$idx" ]]; then
        echo -e "${RED}Invalid selection.${NC}"
        exit 1
    fi

    local selected_idx=$((choice - 1))
    local selected_host="${hosts[$selected_idx]}"

    echo ""
    echo -e "${GREEN}Connecting to ${CYAN}$selected_host${NC}..."
    ssh "$selected_host"
}

# ── Fuzzel GUI menu ───────────────────────────────────────────────────────────
gui_menu() {
    if ! command -v fuzzel &>/dev/null; then
        echo -e "${RED}fuzzel not found. Using terminal menu.${NC}"
        terminal_menu
        return
    fi

    local items=""
    while IFS= read -r host; do
        [[ -z "$host" ]] && continue
        local ip=$(get_hostname "$host")
        local info=$(get_host_info "$host" "${ip:-$host}")
        local status=$(echo "$info" | cut -d'|' -f1)
        local hostname=$(echo "$info" | cut -d'|' -f2)
        local os=$(echo "$info" | cut -d'|' -f3)

        local label="$host"
        [[ -n "$hostname" ]] && label="$label - $hostname"
        [[ -n "$os" ]] && label="$label ($os)"
        [[ "$status" == "online" ]] && label="$label [ONLINE]" || label="$label [OFFLINE]"

        items+="$label\\n"
    done < <(get_hosts)

    local selection
    selection=$(echo -e "$items" | fuzzel --dmenu --prompt="SSH Connect: " --lines=15 --width=60 2>/dev/null)

    if [[ -z "$selection" ]]; then
        exit

