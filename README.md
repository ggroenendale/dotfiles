# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) and provisioned with [Ansible](https://www.ansible.com/).

## Repository Structure

```
.dotfiles/
├── ansible/           # Ansible playbooks and roles for automated provisioning
├── bootstrap/         # Bootstrap install scripts (install-laptop.sh, install-server.sh, etc.)
├── stow/              # Dotfiles organized into stow packages
│   ├── app_desktop_files/   # .desktop files for application launchers
│   ├── aur_helper/          # AUR helper configuration (paru.conf)
│   ├── bash/                # Shell configuration (.bashrc, .bash_profile, scripts)
│   ├── desktop_environment/ # Hyprland, Waybar, kitty, fuzzel, mako, etc.
│   └── neovim_neovide/      # Neovim and Neovide configuration
├── .avante/           # AI assistant context, plans, and rules
├── .gitignore
├── .stow-local-ignore
├── AGENTS.md
└── README.md
```

## Quick Start

### Prerequisites

Install GNU Stow:

```bash
# Debian/Ubuntu
sudo apt install stow

# Arch Linux
sudo pacman -S stow

# openSUSE
sudo zypper install stow
```

### Clone and Symlink

```bash
cd ~
git clone https://github.com/ggroenendale/dotfiles.git .dotfiles
cd ~/.dotfiles
stow .
```

> **Note:** Stow by default ignores the `.git` folder. Additional ignore patterns are defined in `.stow-local-ignore`.

### Automated Provisioning (Recommended)

For a fully automated setup that installs packages and configures the system:

```bash
# Laptop (full desktop environment)
./bootstrap/install-laptop.sh

# Server (minimal setup)
./bootstrap/install-server.sh

# Desktop (desktop environment without laptop-specific config)
./bootstrap/install-desktop.sh
```

See [bootstrap/README.md](bootstrap/README.md) for detailed usage instructions.

## Ansible Provisioning

The `ansible/` directory contains a modular Ansible project for automated system provisioning. It supports:

- **Cross-platform**: Arch Linux, Debian, Ubuntu, openSUSE
- **Idempotent**: Safe to run multiple times — no duplicate configuration
- **Modular roles**: Dotfiles, fonts, system configuration, desktop environment, and more

See [ansible/README.md](ansible/README.md) for the full Ansible documentation.

### Key Playbooks

| Playbook | Purpose |
|----------|---------|
| `bootstrap.yaml` | Environment validation and prerequisites |
| `laptop.yaml` | Full laptop configuration |
| `server.yaml` | Server configuration (placeholder) |
| `desktop.yaml` | Desktop configuration (placeholder) |

## Stow Packages

The `stow/` directory organizes dotfiles into logical packages:

| Package | Contents |
|---------|----------|
| `bash/` | Shell configuration (`.bashrc`, `.bash_profile`), custom scripts (`~/.local/bin/`) |
| `desktop_environment/` | Hyprland, Waybar, kitty, fuzzel, mako, starship, Thunar, backgrounds |
| `neovim_neovide/` | Neovim config, Neovide config, Neovide workspace script |
| `app_desktop_files/` | `.desktop` files for application launchers |
| `aur_helper/` | Paru configuration (`paru.conf`) |

To stow individual packages:

```bash
cd ~/.dotfiles/stow
stow bash
stow neovim_neovide
stow desktop_environment
```

## Screen Capture System

This dotfiles repository includes a comprehensive screen capture and recording system for Wayland/Hyprland on Arch Linux.

### Features:
- **Screenshots**: Full screen, region selection, active window
- **Screen Recording**: Full screen and region recording
- **Clipboard Integration**: Automatic copying to clipboard
- **Keyboard Shortcuts**: Pre-configured Hyprland keybindings
- **Command Line Access**: Bash functions and aliases

### Keybindings:
- `PRINT`: Full screenshot
- `SHIFT + PRINT`: Region screenshot
- `SUPER + PRINT`: Active window screenshot
- `SUPER + ALT + R`: Screen recording menu
- `SUPER + SHIFT + R`: Stop recording

### Usage:
After running `stow .`, use the commands:
- `screenshot-help` for all screenshot commands
- `screenrecord-menu` for recording options
- `open-screenshots` to view captured screenshots

For detailed documentation, see: `~/.local/bin/screenshot-scripts/README.md`

## Plugin Source Code Access

For debugging and development purposes, the repository includes convenient access to Neovim plugin source code:

### Symlink to Plugin Source
```
nvim-plugins-source -> ~/.local/share/nvim/lazy/
```

This symlink provides quick access to all installed Neovim plugin source code (210MB+). Useful for:
- Debugging plugin issues (e.g., "Invalid buffer id" errors in avante.nvim)
- Understanding plugin implementations
- Reference when writing custom configurations

### Git Ignored
The symlink and plugin source directory are excluded from git:
- Added to `.gitignore`: `nvim-plugins-source` and `.local/share/nvim/`
- Added to `.stow-local-ignore`: Won't be symlinked by GNU Stow

### Usage Examples:
```bash
# Browse plugin source code
cd nvim-plugins-source/avante.nvim/lua/avante/

# Check specific plugin implementation
vim nvim-plugins-source/avante.nvim/lua/avante/utils/root.lua

# List all installed plugins
ls nvim-plugins-source/
```

## RAG Service Fix for Podman

The avante.nvim RAG service requires fixes to work with Podman instead of Docker:

### Issues Fixed:
1. **Podman Runner Support**: avante.nvim only supports "docker" or "nix" runners, not "podman"
2. **Hardcoded Docker Commands**: Commands use "docker" instead of the runner value
3. **Missing Docker Binary**: System only has podman, not docker

### Solutions Implemented:
1. **Patched avante.nvim**: Modified `~/.local/share/nvim/lazy/avante.nvim/lua/avante/rag_service.lua`
   - Updated `get_rag_service_runner()` to treat "podman" as "docker"
   - Backup created at: `rag_service.lua.backup`

2. **Created Docker Symlink**: `~/.local/bin/docker -> /usr/bin/podman`
   - Makes podman accessible as "docker" command
   - Required because avante.nvim hardcodes "docker" commands

3. **RAG Container Running**: Tested and verified container is operational
   - Image: `quay.io/yetoneful/avante-rag-service:0.0.11`
   - Port: `20250`
   - Health check: `curl http://localhost:20250/health`

### Verification:
```bash
# Check if RAG container is running
podman ps | grep avante-rag-service

# Check container logs
podman logs avante-rag-service --tail 10

# Test service health (after container starts)
curl -s http://localhost:20250/health
```

### Manual Container Start (if needed):
```bash
# Remove existing container
podman rm -fv avante-rag-service 2>/dev/null || true

# Start RAG service manually
podman run --platform=linux/amd64 -d \
  -p 0.0.0.0:20250:20250 \
  --name avante-rag-service \
  -v ~/.local/share/nvim/avante/rag_service:/data \
  -v $HOME:/host:ro \
  -e ALLOW_RESET=TRUE \
  -e DATA_DIR=/data \
  -e RAG_EMBED_PROVIDER=openai \
  -e RAG_EMBED_ENDPOINT=https://api.deepseek.com/v1 \
  -e RAG_EMBED_API_KEY="$DEEPSEEK_API_KEY" \
  -e RAG_EMBED_MODEL=text-embedding-ada-002 \
  -e RAG_EMBED_EXTRA='{}' \
  -e RAG_LLM_PROVIDER=openai \
  -e RAG_LLM_ENDPOINT=https://api.deepseek.com/v1 \
  -e RAG_LLM_API_KEY="$DEEPSEEK_API_KEY" \
  -e RAG_LLM_MODEL=deepseek-chat \
  -e RAG_LLM_EXTRA='{}' \
  quay.io/yetoneful/avante-rag-service:0.0.11
```
