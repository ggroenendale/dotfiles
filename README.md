## Dotfiles Repo.

In order to let gnu stow copy our dotfiles into our home directory, we first need to install gnu stow.

Debian/Ubuntu

```bash
sudo apt install stow
```

Arch

```bash
sudo pacman -S stow
```

Then we need to make sure our `/.dotfiles` folder lives in our home directory. So we can git clone
this repo into our home directory as .dotfiles.

```bash
cd ~
git clone https://github.com/ggroenendale/dotfiles.git .dotfiles
```

Then once we have all of the files onto the device that we want, we run gnu stow in order to symlink our dotfiles to the
home directory. The magic bit here about symlinking the folders into the home directory is due to stow symlinking to one
folder above by default.

```bash
cd ~/.dotfiles
stow .
```

> NOTE: stow by default ignores the `/.git` folder. If we want to ignore other files we can create a `.stow-local-ignore`
> file and make entries similar to .gitignore entries.

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
