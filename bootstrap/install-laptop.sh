#!/usr/bin/env bash
# =============================================================================
# Dotfiles Bootstrap Installer
#
# Purpose:
#   Bootstraps a machine and installs full Ansible-driven configuration
#
# Supported OS:
#   - Arch Linux
#   - Debian
#   - Ubuntu
#   - openSUSE (planned)
#
# Entry Point:
#   curl ... | bash OR ./install-*.sh
#
# Dependencies:
#   - git
#   - curl
#
# Execution Model:
#   1. Detect OS
#   2. Install prerequisites
#   3. Run ansible-pull
# =============================================================================

set -e

# Check for tput (required for cursor control)
if ! command -v tput &> /dev/null; then
  echo -e "${CAT_RED}Error: 'tput' is required but not found.${NC}"
  echo -e "${CAT_SUBTEXT1}Please install ncurses (Ubuntu: apt install ncurses-bin, Arch: pacman -S ncurses)${NC}"
  exit 1
fi

# Early check for help/version flags (before setup)
for arg in "$@"; do
  case $arg in
    -h|--help)
      SHOW_HELP=true
      ;;
    --version)
      SHOW_VERSION=true
      ;;
  esac
done
# ==============================================================
#   Variables                               
# ==============================================================

# Paths
VAULT_SECRET_FILE="$HOME/.ansible-vault/vault.secret"
OP_INSTALLED=false
OP_AUTHENTICATED=false
DOTFILES_LOG="$HOME/.otherdotfiles.log"
DOTFILES_DIR="$HOME/.dotfiles"
IS_FIRST_RUN="$HOME/.dotfiles_run"

# Logging vars
PUSH_LOGS=false
LOG_DIR="$DOTFILES_DIR/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install-$(basename "$0" .sh)-$(date +%Y-%m-%dT%H-%M-%S).log"

# Spinner PID tracking
SPINNER_PID=""
REPO_URL="https://github.com/ggroenendale/dotfiles.git"
BRANCH="main"
SYSTEM_PLAYBOOK="laptop.yaml"
ANSIBLE_PLAYBOOKS_DIR="$DOTFILES_DIR/ansible/playbooks"

# Specify location of ansible config to make sure it uses the dotfiles one
export ANSIBLE_CONFIG="$HOME/.dotfiles/ansible/ansible.cfg"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --help, -h              Show this help message"
            echo "  --dry-run               Show what would be done without making changes"
            echo "  --branch <name>         Use a specific git branch (default: main)"
            echo "  --non-interactive       Skip prompts (for automated provisioning)"
            exit 0
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --branch)
            BRANCH="$2"
            shift 2
            ;;
        --non-interactive)
            NON_INTERACTIVE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--help] [--dry-run] [--branch <name>] [--non-interactive]"
            exit 1
            ;;
    esac
done


# Log system info
{
    echo "=== System Info ==="
    uname -a
    cat /etc/os-release 2>/dev/null
    echo
} | tee -a "$LOG_FILE"

# ==============================================================
#   Helper Functions
# ==============================================================

# ---------------------------------------------------------
# cleanup()
# ---------------------------------------------------------
# Cleanup function for exit
# 
# Inputs:
#   $1 - task description string
#  
# ---------------------------------------------------------
#
cleanup() {
  # Kill spinner if running
  if [[ $SPINNER_PID != "" ]]; then
    kill $SPINNER_PID 2>/dev/null
    wait $SPINNER_PID 2>/dev/null
  fi
  # Show cursor
  tput cnorm
}

# ---------------------------------------------------------
# _spinner()
# ---------------------------------------------------------
# Displays animated spinner for background tasks
# Runs in background; must be killed explicitly
# 
# Inputs:
#   $1 - task description string
#  
# ---------------------------------------------------------
_spinner() {
  local task_text="$1"
  local chars=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
  local delay=0.08

  # Hide cursor
  tput civis

  # Save cursor position
  tput sc

  while true; do
    for char in "${chars[@]}"; do
      # Restore cursor position and clear line
      tput rc
      tput el
      printf "${CAT_OVERLAY1} [${CAT_SAPPHIRE}${char}${CAT_OVERLAY1}]  ${CAT_TEXT}${task_text}" >&2
      sleep $delay
    done
  done
}


# ---------------------------------------------------------
# __task()
# ---------------------------------------------------------
# Start a new task with spinner
#
# Inputs:
#   $1 - task description string
#  
# ---------------------------------------------------------
__task() {
  # if a task is running, complete it first
  if [[ $TASK != "" ]] && [[ $SPINNER_PID != "" ]]; then
    _task_done
  fi

  # set new task
  TASK=$1

  # Start spinner in background
  _spinner "$TASK" &
  SPINNER_PID=$!

  # Disable job control messages
  disown $SPINNER_PID 2>/dev/null
}

# ---------------------------------------------------------
# _cmd()
# ---------------------------------------------------------
#   Performs commands with error checking but hides output
#   while command executes
#
#   Inputs:
#       $1 - the command to run
#  
# ---------------------------------------------------------
_cmd() {
  #create log if it doesn't exist
  if ! [[ -f $DOTFILES_LOG ]]; then
    touch $DOTFILES_LOG
  fi
  # empty conduro.log
  > $DOTFILES_LOG

  # hide stdout, on error we print and exit
  if eval "$1" 1> /dev/null 2> $DOTFILES_LOG; then
    return 0 # success
  else
    # Kill spinner if running
    if [[ $SPINNER_PID != "" ]]; then
      kill $SPINNER_PID 2>/dev/null
      wait $SPINNER_PID 2>/dev/null
      SPINNER_PID=""
    fi

    # Show cursor again
    tput cnorm

    # Clear the line and show error
    printf "\r\033[K${CAT_RED} [✗]  ${CAT_TEXT}${TASK}${NC}\n"

    # Show error details
    local line
    while read -r line; do
      printf "      ${CAT_MAROON}%s${NC}\n" "$line"
    done < "$DOTFILES_LOG"
    printf "\n"

    # remove log file
    rm $DOTFILES_LOG
    # exit installation
    exit 1
  fi
}

# ---------------------------------------------------------
# _cmd_show()
# ---------------------------------------------------------
#   Performs commands with error checking and shows output
#
#   Inputs:
#       $1 - the command to run
#  
# ---------------------------------------------------------
_cmd_show() {
  #create log if it doesn't exist
  if ! [[ -f $DOTFILES_LOG ]]; then
    touch $DOTFILES_LOG
  fi
  # empty conduro.log
  > $DOTFILES_LOG

  # hide stdout, on error we print and exit
  if eval "$1" 2>&1 | tee "$DOTFILES_LOG"; test ${PIPESTATUS[0]} -eq 0; then
    return 0 # success
  else
    # Kill spinner if running
    if [[ $SPINNER_PID != "" ]]; then
      kill $SPINNER_PID 2>/dev/null
      wait $SPINNER_PID 2>/dev/null
      SPINNER_PID=""
    fi

    # Show cursor again
    tput cnorm

    # Clear the line and show error
    printf "\r\033[K${CAT_RED} [✗]  ${CAT_TEXT}${TASK}${NC}\n"

    # Show error details
    local line
    while read -r line; do
      printf "      ${CAT_MAROON}%s${NC}\n" "$line"
    done < "$DOTFILES_LOG"
    printf "\n"

    # remove log file
    rm $DOTFILES_LOG
    # exit installation
    exit 1
  fi
}
# ---------------------------------------------------------
# _clear_task()
# ---------------------------------------------------------
#   Performs commands with error checking
#
#   Inputs:
#       $1 - task description string
#  
# ---------------------------------------------------------
_clear_task() {
  TASK=""
}

# ---------------------------------------------------------
# _task_done()
# ---------------------------------------------------------
#   Performs commands with error checking
#
#   Inputs:
#       $1 - task description string
#  
# ---------------------------------------------------------
_task_done() {
  # Kill spinner if running
  if [[ $SPINNER_PID != "" ]]; then
    kill $SPINNER_PID 2>/dev/null
    wait $SPINNER_PID 2>/dev/null
    SPINNER_PID=""
  fi

  # Show cursor again
  tput cnorm

  # Clear line and show success
  printf "\r\033[K${CAT_GREEN} [✓]  ${CAT_TEXT}${TASK}\n"
  _clear_task
}

# ---------------------------------------------------------
# detect_os()
# ---------------------------------------------------------
#   Detects the operating system by using variables inside
#   the /etc/os-release file, the ID variable 
#   - for arch linux is "arch"
#   - for debian linux is "debian"
#   - for opensuse there is ID_LIKE = "opensuse suse" cause ID = "opensuse-tumbleweed"
#
#  
# ---------------------------------------------------------
detect_os() {
  if [ -f /etc/os-release ]; then
    source /etc/os-release
    # Normalize openSUSE variants (opensuse-tumbleweed, opensuse-leap, etc.) to just "opensuse"
    if [[ $ID == opensuse* ]]; then
      echo "opensuse"
    else
      echo "$ID"
    fi
  else
    echo $(uname -s | tr '[:upper:]' '[:lower:]')
  fi
}

# Determine the OS using the above function
dotfiles_os=$(detect_os)


# =========================================================
#   OS Installer                       
# =========================================================

# ---------------------------------------------------------
# arch_setup()
# ---------------------------------------------------------
#
#  
# ---------------------------------------------------------
arch_setup() {

    # Update Packages
    _cmd "sudo pacman -Sy --noconfirm"
    # Install Git
    if ! [ -x "$(command -v git)" ]; then
        __task "Installing Git"
        _cmd "sudo pacman -S --noconfirm git"
    fi

    # Install Python3
    if ! [ -x "$(command -v python3)" ]; then
        __task "Installing Ansible (This may take a few minutes)"
        _cmd "sudo pacman -S --noconfirm python3"
    fi

    # Install Python3 Pip
    if ! [ -x "$(command -v pip)" ]; then
        __task "Installing Pip (This may take a few minutes)"
        _cmd "sudo pacman -S --noconfirm python-pip"
    fi

    # Install python-argcomplete
    if ! python3 -c "import argcomplete" 2>/dev/null; then
        __task "Installing python-argcomplete"
        _cmd "sudo pacman -S --noconfirm python-argcomplete"
    fi

    # Install Ansible if not available
    if ! [ -x "$(command -v ansible)" ]; then
        __task "Installing Ansible (This may take a few minutes)"
        _cmd "sudo pacman -S --noconfirm ansible"
    fi

    # Install OpenSSH
    if ! [ -x "$(command -v ssh)" ]; then
        __task "Installing OpenSSH"
        _cmd "sudo pacman -S --noconfirm openssh"
    fi

    # Install gopass 
    if ! [ -x "$(command -v gopass)" ]; then
        __task "Installing gopass"
        _cmd "sudo pacman -S gopass gnupg"
        if ! [ -x "$(gpg --list-secret-keys)" ]; then
            _cmd "gpg --full-generate-key"
        fi
        # Initialize gopass
        _cmd "gopass init"
    fi

    # Install Ansible Python dependencies
    __task "Installing Ansible Python dependencies"
    _cmd "sudo pacman -S --noconfirm python-passlib python-kubernetes python-docker python-jmespath"

    # Set Locale
    if ! locale -a 2>/dev/null | grep -q "en_US.utf8"; then
        __task "Setting locale"
        _cmd "sudo sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen"
        _cmd "sudo locale-gen"
    fi
}

# ---------------------------------------------------------
# debian_setup()
# ---------------------------------------------------------
#
#  
# ---------------------------------------------------------
debian_setup() {

    # Update package lists
    __task "Updating package lists"
    _cmd "sudo apt-get update"

    # Install Git
    if ! [ -x "$(command -v git)" ]; then
        __task "Installing Git"
        _cmd "sudo apt-get install -y git"
    fi

    # Install Python3
    if ! [ -x "$(command -v python3)" ]; then
        __task "Installing Python3"
        _cmd "sudo apt-get install -y python3"
    fi

    # Install python3-argcomplete
    if ! python3 -c "import argcomplete" 2>/dev/null; then
        __task "Installing python3-argcomplete"
        _cmd "sudo apt-get install -y python3-argcomplete"
    fi

    # Install Ansible if not available
    if ! [ -x "$(command -v ansible)" ]; then
        __task "Installing Ansible (This may take a few minutes)"
        _cmd "sudo apt-get install -y software-properties-common"
        _cmd "sudo apt-add-repository -y ppa:ansible/ansible"
        _cmd "sudo apt-get update"
        _cmd "sudo apt-get install -y ansible"
    fi

    # Install OpenSSH
    if ! [ -x "$(command -v ssh)" ]; then
        __task "Installing OpenSSH"
        _cmd "sudo apt-get install -y openssh-server"
    fi
}

# ---------------------------------------------------------
# opensuse_setup()
# ---------------------------------------------------------
# Installs:
#   git
#   python3
#   pip
#   python-argcomplete
#   ansible
# in that order by first checking if the a package is available
# then installing if not.
#  
# ---------------------------------------------------------
opensuse_setup() {

    # Update Packages
    _cmd "sudo zypper --non-interactive refresh"

    # Install Git
    if ! [ -x "$(command -v git)" ]; then
        __task "Installing Git"
        _cmd "sudo zypper --non-interactive install git"
    fi

    # Install Python3
    if ! [ -x "$(command -v python3)" ]; then
        __task "Installing Python3"
        _cmd "sudo zypper --non-interactive install python3"
    fi

    # Install Python3 Pip
    if ! [ -x "$(command -v pip)" ]; then
        __task "Installing Pip"
        _cmd "sudo zypper --non-interactive install python3-pip"
    fi

    # Install python-argcomplete
    if ! python3 -c "import argcomplete" 2>/dev/null; then
        __task "Installing python-argcomplete"
        _cmd "sudo zypper --non-interactive install python3-argcomplete"
    fi

    # Install Ansible if not available
    if ! [ -x "$(command -v ansible)" ]; then
        __task "Installing Ansible (This may take a few minutes)"
        _cmd "sudo zypper --non-interactive install ansible"
    fi

    # Install OpenSSH
    if ! [ -x "$(command -v ssh)" ]; then
        __task "Installing OpenSSH"
        _cmd "sudo zypper --non-interactive install openssh"
    fi

    # Install Ansible Python dependencies
    __task "Installing Ansible Python dependencies"
    _cmd "sudo zypper --non-interactive install python3-passlib python3-kubernetes python3-docker python3-jmespath"



    # Set Locale
    if ! locale -a 2>/dev/null | grep -q "en_US.utf8"; then
        __task "Setting locale"
        _cmd "sudo localectl set-locale LANG=en_US.UTF-8"
        _cmd "sudo locale-gen"
    fi
}

# ---------------------------------------------------------
# ubuntu_setup()
# ---------------------------------------------------------
#
#  
# ---------------------------------------------------------
ubuntu_setup() {

    # Update package lists
    __task "Updating package lists"
    _cmd "sudo apt-get update"

    # Install Git
    if ! [ -x "$(command -v git)" ]; then
        __task "Installing Git"
        _cmd "sudo apt-get install -y git"
    fi

    # Install Python3
    if ! [ -x "$(command -v python3)" ]; then
        __task "Installing Python3"
        _cmd "sudo apt-get install -y python3"
    fi

    # Install python3-argcomplete
    if ! python3 -c "import argcomplete" 2>/dev/null; then
        __task "Installing python3-argcomplete"
        _cmd "sudo apt-get install -y python3-argcomplete"
    fi

    # Install Ansible if not available
    if ! [ -x "$(command -v ansible)" ]; then
        __task "Installing Ansible (This may take a few minutes)"
        _cmd "sudo apt-get install -y software-properties-common"
        _cmd "sudo apt-add-repository -y ppa:ansible/ansible"
        _cmd "sudo apt-get update"
        _cmd "sudo apt-get install -y ansible"
    fi

    # Install OpenSSH
    if ! [ -x "$(command -v ssh)" ]; then
        __task "Installing OpenSSH"
        _cmd "sudo apt-get install -y openssh-server"
    fi
}


###########################################################
######      Main Install                             ######
###########################################################



# Install base dependencies
case $dotfiles_os in 
    arch)
        arch_setup
        ;;
    debian)
        debian_setup
        ;;
    opensuse)
        opensuse_setup
        ;;
    ubuntu)
        ubuntu_setup
        ;;
    *)
        __task "Unsupported OS"
        _cmd "echo 'Unsupported OS'"
    ;;
esac 

# Install Ansible dependencies
# Install Ansible collections
__task "Installing Ansible collections"
_cmd "ansible-galaxy collection install community.general ansible.posix kubernetes.core"

if ! [[ -d "$DOTFILES_DIR" ]]; then
    __task "Downloading dotfiles repository (This may take a minute)"
    _cmd "git clone --quiet --branch $BRANCH $REPO_URL $DOTFILES_DIR"
    _task_done
else
    __task "Updating dotfiles repository"
    _cmd "git -C $DOTFILES_DIR pull --quiet"
    _task_done
fi

# Phase 1: Bootstrap — environment validation and prerequisites
__task "Running bootstrap playbook"
_cmd_show "ansible-pull -U \"$REPO_URL\" -C \"$BRANCH\" -i 127.0.0.1, --limit=all --clean \"$ANSIBLE_PLAYBOOKS_DIR/bootstrap.yaml\""
_task_done


# Phase 2: System-specific provisioning
__task "Running $SYSTEM_PLAYBOOK playbook"
_cmd_show "ansible-pull -U \"$REPO_URL\" -C \"$BRANCH\" -i 127.0.0.1, --limit=all --clean \"$ANSIBLE_PLAYBOOKS_DIR/$SYSTEM_PLAYBOOK\""
_task_done


# Push logs 
if [ "$PUSH_LOGS" = true ] && git remote -v 2>/dev/null | grep -q origin; then
    git add "$LOG_FILE"
    git commit -m "logs: install run $(date +%Y-%m-%d)"
    git push
fi

# Completion message
echo ""
echo "============================================"
echo "  Dotfiles installation complete!"
echo "  System playbook: $SYSTEM_PLAYBOOK"
echo "  Branch: $BRANCH"
echo "  Log: $DOTFILES_LOG"
echo "============================================"
echo ""
echo "You may need to restart your shell or log out"
echo "and back in for all changes to take effect."
