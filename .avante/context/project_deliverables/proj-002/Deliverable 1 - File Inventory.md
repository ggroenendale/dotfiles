# Deliverable 1 — Complete File Inventory

**Project:** Proj-002 — Dotfiles Ansible Migration
**Phase:** Phase 0 — Audit & Inventory
**Date:** 2026-05-05
**Status:** Complete

---

## Overview

This document provides a complete inventory of every file in the dotfiles repository, organized by stow package. It documents each file's purpose, cross-platform compatibility, and any relevant notes for the Ansible migration.

---

## Repository Root

Files at the repository root that are **not** managed by Stow (excluded via `.stow-local-ignore`):

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `.gitignore` | Git ignore rules | Yes | Standard git configuration |
| `.stow-local-ignore` | Stow exclusion patterns (Perl regex) | Yes | Excludes repo-specific files from symlinking |
| `AGENTS.md` | AI agent documentation and session logs | Yes | Repository documentation |
| `README.md` | Repository overview and usage guide | Yes | Repository documentation |
| `stow/` | Stow packages directory | Yes | Contains all dotfiles organized by package |
| `bootstrap/` | Bootstrap installer scripts | Yes | Contains install scripts and Ansible playbook |
| `ansible/` | Ansible project structure | Yes | Roles, playbooks, and requirements |

**Note:** The `.stow-local-ignore` patterns exclude: `AGENTS.md`, `README.md`, `avant-analysis.md`, `.gitignore`, `.avante/`, `.git/`, `nvim-plugins-source/`, `_scratch/`.

---

## Stow Package: `bash/`

**Purpose:** Shell configuration, environment variables, aliases, functions, and custom scripts.

### `.config/bash/` — Shell Configuration

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `bashrc` | Main bash config: distro detection, history, shell options, prompt, modular loading | Yes | Sources all `*.sh` files in this directory |
| `00-env.sh` | Environment variables: EDITOR, VISUAL, PAGER, XDG paths, BROWSER, CARGO_HOME, KUBECONFIG | Yes | BROWSER varies by distro |
| `10-paths.sh` | PATH additions: `/opt/nvim/bin`, `~/.cargo/bin`, `~/.local/bin`, `~/.pyenv/bin` | Yes | Standard PATH extensions |
| `20-aliases.sh` | Basic aliases: reload, ll/la/l, grep, df, du, vim→nvim | Yes | Universal shell aliases |
| `30-devtools.sh` | Dev tool initialization: NVM sourcing, Pyenv init | Yes | Tools may need separate installation |
| `40-scripts.sh` | Personal scripts loader (mostly commented out) | Yes | Placeholder for future scripts |
| `50-functions.sh` | Bash functions: screen capture, SSH management, Waybar restart, utility aliases | Partial | Screen capture is Wayland/Hyprland-specific; SSH is cross-platform |

### `.bashrc` (stow root)

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `.bashrc` | Entry point that sources `~/.config/bash/bashrc` and initializes zoxide | Yes | Standard bashrc loader |

### `.local/bin/screenshot-scripts/` — Screen Capture

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `screenshot-full.sh` | Full screen capture with grim, clipboard via wl-copy | No — Wayland | Depends on grim, wl-clipboard |
| `screenshot-region.sh` | Interactive region selection with slurp, grim capture | No — Wayland | Depends on grim, slurp, wl-clipboard |
| `screenshot-window.sh` | Active window capture via hyprctl, falls back to slurp | No — Hyprland | Depends on hyprctl, grim, slurp |
| `screenshot-menu.sh` | Interactive menu (fuzzel GUI or terminal) for screenshot options | No — Hyprland | Depends on fuzzel (optional), grim, slurp |
| `screenrecord-full.sh` | Full screen recording with wf-recorder, PID tracking | No — Wayland | Depends on wf-recorder |
| `screenrecord-region.sh` | Region-based screen recording with slurp + wf-recorder | No — Wayland | Depends on wf-recorder, slurp |
| `screenrecord-stop.sh` | Stops active recording via SIGINT/SIGKILL, shows file size | No — Wayland | Depends on wf-recorder PID file |
| `screenrecord-status.sh` | Checks if recording is active via PID file | No — Wayland | Cross-platform logic but Wayland-specific use |
| `screenrecord-menu.sh` | Context-aware recording menu (fuzzel GUI or terminal) | No — Hyprland | Depends on fuzzel (optional), wf-recorder |
| `README.md` | Comprehensive documentation for screen capture system | No — Wayland/Hyprland | Documents usage, keybindings, troubleshooting |

### `.local/bin/ssh-scripts/` — SSH Management

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `ssh-connect.sh` | Interactive SSH connection manager with terminal menu | Yes | Parses `~/.ssh/config`, pings hosts, caches info |
| `ssh-list.sh` | List SSH hosts with status, hostname, OS info | Yes | Supports table, simple, and JSON output |
| `write_ssh_connect.py` | Python script for SSH connection management | Yes | Helper for ssh-connect.sh |

---

## Stow Package: `desktop_environment/`

**Purpose:** Hyprland/Wayland desktop environment configuration — window manager, bar, terminal, notifications, launcher, wallpaper, and shell prompt.

### `.config/hypr/` — Hyprland Window Manager

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `hyprland.conf` | Main Hyprland config: keybindings, monitors, workspaces, animations | No — Hyprland | Arch Linux specific (package names in exec commands) |
| `hyprlock.conf` | Screen lock configuration | No — Hyprland | Depends on hyprlock |
| `hyprpaper.conf` | Wallpaper management configuration | No — Hyprland | Depends on hyprpaper |

### `.config/waybar/` — Wayland Status Bar

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `config.jsonc` | Waybar module configuration: workspaces, clock, system tray, screenshot button | No — Wayland | Custom screenshot module references local scripts |
| `config.jsonc.bak` | Backup of previous Waybar config | No — Wayland | Can be removed if no longer needed |
| `style.css` | Waybar styling with Tokyo Night theme colors | No — Wayland | CSS theming |

### `.config/kitty/` — Terminal Emulator

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `kitty.conf` | Kitty terminal configuration: font, theme, keybindings, layout | Yes | Uses Tokyo Night theme |
| `current-theme.conf` | Current Tokyo Night theme colors | Yes | Theme file |
| `Tokyo Night Storm.conf` | Tokyo Night Storm variant theme | Yes | Alternative theme |

### `.config/mako/` — Notification Daemon

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `config` | Mako notification settings: position, timeout, colors, grouping | No — Wayland | Mako is a Wayland notification daemon |

### `.config/fuzzel/` — Application Launcher

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `fuzzel.ini` | Fuzzel launcher configuration: appearance, font, keybindings | No — Wayland | Fuzzel is a Wayland-native dmenu replacement |

### `.config/waypaper/` — Wallpaper Manager

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `config.ini` | Waypaper configuration: wallpaper path, backend, settings | No — Wayland | Depends on waypaper and hyprpaper/swaybg |
| `style.css` | Waypaper GUI styling | No — Wayland | CSS for the waypaper GUI |

### `.config/Thunar/` — File Manager

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `accels.scm` | Thunar keyboard shortcuts | Yes | GTK file manager, cross-platform |
| `uca.xml` | Thunar custom actions | Yes | Custom context menu actions |

### `.config/xfce4/` — XFCE Settings

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `helpers.rc` | XFCE helper applications configuration | Yes | Maps file types to applications |

### `.config/starship.toml`

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `starship.toml` | Starship prompt configuration: modules, colors, formatting | Yes | Cross-platform shell prompt |

### `.config/backgrounds/` — Wallpapers

| Item | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `backgrounds/` | ~120+ wallpaper images (.jpg, .png, .jpeg) | Yes | Large directory — consider managing separately from stow |

---

## Stow Package: `neovim_neovide/`

**Purpose:** Neovim editor configuration and Neovide GUI settings.

### `.config/nvim/` — Neovim Configuration

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `init.lua` | Main Neovim entry point | Yes | Bootstrap file for lazy.nvim |
| `README.md` | Neovim configuration documentation | Yes | Documentation |
| `.env` | Environment variables (API keys) | Yes | **Contains secrets** — do not commit, handle via dotenv plugin |
| `keyboard-shortcuts-analysis.md` | Keyboard shortcuts reference | Yes | Documentation |
| `test_alpha_fix.lua` | Test script for alpha.nvim fix | Yes | Development artifact |

#### `lua/geoff/core/` — Core Configuration

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `init.lua` | Core module loader | Yes | Loads all core modules |
| `options.lua` | Neovim options and settings | Yes | Editor behavior settings |
| `keymaps.lua` | Custom key mappings | Yes | Leader key, mode-specific mappings |
| `status.lua` | Status line configuration | Yes | Custom status line |
| `gui.lua` | GUI-specific settings | Yes | Font, transparency, UI settings |
| `gui-context-menu.lua` | GUI context menu configuration | Yes | Right-click menu settings |
| `neovide.lua` | Neovide-specific settings | Yes | Neovide integration |

#### `lua/geoff/plugins/` — Plugin Configurations (35 plugins)

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `init.lua` | Plugin loader (lazy.nvim) | Yes | Bootstrap for all plugins |
| `alpha.lua` | Dashboard / welcome screen | Yes | |
| `auto-session.lua` | Session management | Yes | |
| `autopairs.lua` | Auto-pair brackets/quotes | Yes | |
| `avante.lua` | AI assistant (avante.nvim) | Yes | Custom tools and rules config |
| `bufferline.lua` | Tab/buffer line | Yes | |
| `colorscheme.lua` | Color scheme (Tokyo Night) | Yes | |
| `comment.lua` | Comment toggling | Yes | |
| `dadbod.lua` | Database client | Yes | |
| `deepseek-budget.lua` | Deepseek API budget display | Yes | Custom local plugin |
| `dotenv.lua` | .env file loading | Yes | Loads API keys from `.env` |
| `dressing.lua` | UI improvements | Yes | |
| `formatting.lua` | Code formatting (conform.nvim) | Yes | |
| `gitsigns.lua` | Git decorations | Yes | |
| `indent-blankline.lua` | Indentation guides | Yes | |
| `lazydocker.lua` | Docker management | Yes | |
| `lazygit.lua` | Git UI | Yes | |
| `linting.lua` | Code linting (nvim-lint) | Yes | |
| `lualine.lua` | Status line | Yes | |
| `markdown-toc.lua` | Markdown TOC generation | Yes | |
| `markview.lua` | Markdown preview | Yes | |
| `nvim-cmp.lua` | Autocompletion | Yes | |
| `nvim-dap.lua` | Debug adapter protocol | Yes | |
| `nvim-dap-ui.lua` | DAP UI | Yes | |
| `nvim-dap-python.lua` | Python DAP | Yes | |
| `nvim-docs-view.lua` | Documentation viewer | Yes | |
| `nvim-tree.lua` | File explorer | Yes | |
| `surround.lua` | Surround text objects | Yes | |
| `telescope.lua` | Fuzzy finder | Yes | |
| `todo-comments.lua` | TODO comment highlighting | Yes | |
| `transparent.lua` | Transparent backgrounds | Yes | |
| `treesitter.lua` | Treesitter (syntax parsing) | Yes | |
| `trouble.lua` | Diagnostics list | Yes | |
| `vim-maximizer.lua` | Window maximizer | Yes | |
| `which-key.lua` | Keybinding popup | Yes | |

#### `lua/geoff/plugins/lsp/` — LSP Configuration

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `lspconfig.lua` | LSP server configurations | Yes | Multiple language servers |
| `mason.lua` | Mason package manager for LSP | Yes | Installs LSP servers, formatters, linters |

#### `lua/geoff/plugins/credentials/` — Database Credentials

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `db_credentials.lua` | Database connection credentials | Yes | **Contains secrets** — excluded from git |
| `db_credentials-sample.lua` | Sample credentials template | Yes | Safe to commit, reference only |

### `.config/neovide/` — Neovide GUI

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `config.toml` | Neovide settings: font, theme, transparency, window size | Yes | Neovide is cross-platform |

### `.local/bin/` — Tools

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `neovide-workspace` | Script to launch Neovide with workspace management | Yes | Shell script |

### `.local/share/applications/` — Desktop Entries

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `neovide-workspace.desktop` | Desktop entry for Neovide workspace launcher | Yes | .desktop file for application menu |

---

## Stow Package: `aur_helper/`

**Purpose:** AUR helper (paru) configuration.

| File | Purpose | Cross-Platform | Notes |
|------|---------|----------------|-------|
| `.config/paru.conf` | Paru (AUR helper) configuration | No — Arch Linux only | Only relevant on Arch Linux with AUR enabled |

---

## Stow Package: `app_desktop_files/`

**Purpose:** Desktop entry files (.desktop) for application menus.

**Note:** This package directory is currently **empty**. Desktop files that were previously here may have been moved to `stow/neovim_neovide/.local/share/applications/`.

---

## Cross-Platform Summary

### Universal (works on any Linux distribution)

- All bash configuration files (`.config/bash/*.sh`, `.bashrc`)
- All Neovim configuration (`stow/neovim_neovide/`)
- SSH management scripts (`ssh-connect.sh`, `ssh-list.sh`)
- Kitty terminal configuration (kitty is cross-platform)
- Thunar file manager configuration
- XFCE helper settings
- Starship prompt configuration
- Wallpaper images (content, not the tooling to display them)

### Wayland/Hyprland-specific (Arch Linux desktop only)

- All Hyprland configuration (`hyprland.conf`, `hyprlock.conf`, `hyprpaper.conf`)
- All Waybar configuration (`config.jsonc`, `style.css`)
- Mako notification daemon configuration
- Fuzzel application launcher configuration
- Waypaper wallpaper manager configuration
- All screen capture scripts (grim, slurp, wf-recorder, wl-clipboard)
- Screen capture README documentation

### Arch Linux-specific

- Paru AUR helper configuration (`paru.conf`)

---

## `fix-symlinks.sh` Analysis

**Location:** `bootstrap/fix-symlinks.sh`
**Purpose:** Recreates all stow symlinks after the repository restructure. Removes old/broken symlinks pointing to the old `.config/` and `.local/` locations and replaces them with proper symlinks to `stow/` packages.

### Script Behavior

1. **Determines paths:** Resolves `DOTFILES_DIR` (parent of `bootstrap/`) and `STOW_DIR` (`$DOTFILES_DIR/stow`)
2. **Parses arguments:** `--force` (no prompts), `--dry-run` (preview only)
3. **Defines packages:** Hardcoded list of 5 stow packages:
   - `neovim_neovide`, `desktop_environment`, `bash`, `app_desktop_files`, `aur_helper`
4. **Detects conflicts:** For each package, finds files/dirs in `$HOME` that either:
   - Are symlinks pointing to old `.dotfiles/.config/` or `.dotfiles/.local/` paths
   - Are real files (not symlinks) conflicting with stow
5. **Also checks directory-level symlinks:** Finds directory symlinks that stow needs to create (e.g., `.config/nvim`, `.config/waybar`)
6. **Deduplicates:** Uses `awk` to remove duplicate conflict entries while preserving order
7. **Prompts for confirmation:** Unless `--force` is used, asks before removing conflicts
8. **Removes conflicts:** `rm -rf` on each conflicting path (or dry-run preview)
9. **Runs stow:** For each package: `stow -v -d <STOW_DIR> -t $HOME <package>`

### Key Details for Ansible Migration

| Aspect | Current Script | Ansible Role Equivalent |
|--------|---------------|------------------------|
| Package list | Hardcoded array | Variable in `vars/main.yaml` |
| Conflict detection | Manual find + readlink | `stat` module or `find` with `register` |
| Conflict removal | `rm -rf` | `file` module with `state: absent` |
| Stow execution | `stow -v -d <dir> -t <home> <pkg>` | `command` module with `creates` or `changed_when` |
| Dry-run | `--dry-run` flag + `stow --no` | `--check` mode (Ansible built-in) |
| Force mode | `--force` flag | `--extra-vars` or tags |
| Confirmation prompt | Interactive `read` | Not needed in Ansible (use `--check` instead) |

### Important Notes

- The script should be **preserved** — it's useful for manual intervention and as a reference
- The Ansible stow role should **replicate the script's behavior** for automated provisioning
- The script uses `stow -d <STOW_DIR> -t $HOME <package>` syntax (not `stow .` from repo root)
- The `--adopt` flag is **not used** — the script removes conflicts before stowing
- Directory-level symlinks (e.g., `.config/nvim/`) are checked separately from file-level symlinks
- The script does **not** handle `.stow-local-ignore` patterns — it relies on stow's built-in ignore mechanism

### Ansible Role Requirements (Phase 3)

Based on this analysis, the Ansible stow role should:

1. Define stow packages in a variable (not hardcoded)
2. Use the `command` module to invoke `stow` with `-d` and `-t` flags
3. Handle conflicts by removing them with the `file` module before stowing
4. Support dry-run via Ansible's `--check` mode
5. Be idempotent — use `creates` or `changed_when` to detect changes
6. Support both `stow` and `unstow` operations via tags
7. Run from the repository root (cloned by `ansible-pull` during bootstrap)

---

## Cross-Platform Analysis

### Universal (works on any Linux distribution)

- All bash configuration files (`.config/bash/*.sh`, `.bashrc`)
- All Neovim configuration (`stow/neovim_neovide/`)
- SSH management scripts (`ssh-connect.sh`, `ssh-list.sh`)
- Kitty terminal configuration (kitty is cross-platform)
- Thunar file manager configuration
- XFCE helper settings
- Starship prompt configuration
- Wallpaper images (content, not the tooling to display them)

### Wayland/Hyprland-specific (Arch Linux desktop only)

- All Hyprland configuration (`hyprland.conf`, `hyprlock.conf`, `hyprpaper.conf`)
- All Waybar configuration (`config.jsonc`, `style.css`)
- Mako notification daemon configuration
- Fuzzel application launcher configuration
- Waypaper wallpaper manager configuration
- All screen capture scripts (grim, slurp, wf-recorder, wl-clipboard)
- Screen capture README documentation

### Arch Linux-specific

- Paru AUR helper configuration (`paru.conf`)

### Cross-Platform Strategy

| Concern | Approach |
|---------|----------|
| **Package names differ** | OS-specific variable files in `ansible/roles/packages/vars/` |
| **Config files are universal** | Stow is OS-agnostic — unused configs are harmless |
| **Desktop env is Wayland-only** | Desktop role should be tagged and optional |
| **AUR helper is Arch-only** | `aur_helper` stow package can be skipped on non-Arch via `when` condition |
| **Screen capture is Wayland-only** | Scripts role should check for Wayland or be tagged |
| **Bash config is universal** | Bash stow package can run unconditionally |

