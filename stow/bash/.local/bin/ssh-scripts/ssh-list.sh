#!/usr/bin/env bash
# ==============================================================================
# ssh-list.sh - List all SSH hosts from config with status info
# ==============================================================================
# Shows hostname, IP, OS info, and online status for each host in SSH config.
# Uses cached results to avoid slow re-queries.
# ==============================================================================

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

SSH_CONFIG="${HOME}/.ssh/config"
CACHE_DIR="${HOME}/.cache/ssh-list"
CACHE_FILE="${CACHE_DIR}/hosts.cache"
CACHE_TTL=300  # 5 minutes

mkdir -p "$CACHE_DIR"

if [[ ! -f "$SSH_CONFIG" ]]; then
    echo -e "${RED}Error: SSH config not found at $SSH_CONFIG${NC}"
    exit 1
fi

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

get_user() {
    awk -v target="$1" '
    $1 == "Host" {
        for (i=2; i<=NF; i++) {
            if ($i == target) { found = 1; next }
        }
        found = 0
    }
    found && $1 == "User" { print $2; exit }
    ' "$SSH_CONFIG"
}

get_port() {
    awk -v target="$1" '
    $1 == "Host" {
        for (i=2; i<=NF; i++) {
            if ($i == target) { found = 1; next }
        }
        found = 0
    }
    found && $1 == "Port" { print $2; exit }
    ' "$SSH_CONFIG"
}

# ── Get host info via SSH ─────────────────────────────────────────────────────
get_host_info() {
    local host="$1"
    local ip="$2"
    local user="$3"
    local port="$4"

    # Check cache first
    local cache_key="${host}|${ip}"
    if [[ -f "$CACHE_FILE" ]]; then
        local cached
        cached=$(grep "^${cache_key}|" "$CACHE_FILE" 2>/dev/null || true)
        if [[ -n "$cached" ]]; then
            echo "$cached" | cut -d'|' -f3-
            return
        fi
    fi

    # Quick ping check
    local status="offline"
    local hostname=""
    local os=""

    if ping -c 1 -W 1 "$ip" &>/dev/null; then
        status="online"
        # Try to get hostname and OS via SSH (fast, non-blocking)
        local info
        info=$(ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o BatchMode=yes \
            -o LogLevel=ERROR -T "$host" \
            "echo HOSTNAME=\$(hostname); echo OS=\$(. /etc/os-release 2>/dev/null && echo \"\$PRETTY_NAME\" || echo unknown)" \
            2>/dev/null || true)
        if [[ -n "$info" ]]; then
            hostname=$(echo "$info" | grep "^HOSTNAME=" | cut -d= -f2-)
            os=$(echo "$info" | grep "^OS=" | cut -d= -f2-)
        fi
    fi

    local result="${status}|${hostname}|${os}"
    # Cache it
    echo "${cache_key}|${result}" >> "$CACHE_FILE"

    # Trim cache to last 50 entries
    tail -n 50 "$CACHE_FILE" > "${CACHE_FILE}.tmp" && mv "${CACHE_FILE}.tmp" "$CACHE_FILE"

    echo "$result"
}

# ── Main listing ──────────────────────────────────────────────────────────────
main() {
    local format="${1:-table}"

    # Collect all hosts
    local hosts=()
    while IFS= read -r host; do
        [[ -z "$host" ]] && continue
        hosts+=("$host")
    done < <(get_hosts)

    if [[ ${#hosts[@]} -eq 0 ]]; then
        echo -e "${RED}No hosts found in SSH config.${NC}"
        exit 1
    fi

    case "$format" in
        json)
            echo "["
            local first=true
            for host in "${hosts[@]}"; do
                $first || echo ","
                first=false
                local hn=$(get_hostname "$host")
                local us=$(get_user "$host")
                local po=$(get_port "$host")
                local info=$(get_host_info "$host" "${hn:-$host}" "${us:-geoff}" "${po:-22}")
                local status=$(echo "$info" | cut -d'|' -f1)
                local hostname=$(echo "$info" | cut -d'|' -f2)
                local os=$(echo "$info" | cut -d'|' -f3)
                echo "  {\"host\":\"$host\",\"ip\":\"${hn:-}\",\"user\":\"${us:-geoff}\",\"port\":\"${po:-22}\",\"status\":\"$status\",\"hostname\":\"${hostname:-}\",\"os\":\"${os:-}\"}"
            done
            echo "]"
            ;;
        simple)
            for host in "${hosts[@]}"; do
                echo "$host"
            done
            ;;
        table|*)
            printf "${CYAN}%-20s %-18s %-10s %-25s %s${NC}\n" "HOST" "IP" "STATUS" "HOSTNAME" "OS"
            printf "${CYAN}%-20s %-18s %-10s %-25s %s${NC}\n" "----" "--" "------" "--------" "--"
            for host in "${hosts[@]}"; do
                local hn=$(get_hostname "$host")
                local us=$(get_user "$host")
                local po=$(get_port "$host")
                local info=$(get_host_info "$host" "${hn:-$host}" "${us:-geoff}" "${po:-22}")
                local status=$(echo "$info" | cut -d'|' -f1)
                local hostname=$(echo "$info" | cut -d'|' -f2)
                local os=$(echo "$info" | cut -d'|' -f3)

                local status_display
                if [[ "$status" == "online" ]]; then
                    status_display="${GREEN}online${NC}"
                else
                    status_display="${RED}offline${NC}"
                fi

                printf "%-20s %-18s %b %-25s %s\n" "$host" "${hn:-}" "$status_display" "${hostname:-}" "${os:-}"
            done
            echo ""
            echo -e "${GRAY}Tip: Use 'ssh-connect' for interactive menu, or 'ssh <host>' to connect directly${NC}"
            ;;
    esac
}

main "$@"

