# Project Plan: Dotfiles Ansible Migration

> **⚠️ AGENT SAFETY LOCK — READ BEFORE PROCEEDING**
>
> **DO NOT EXECUTE ANY WORK ON THIS PROJECT WITHOUT EXPLICIT USER AUTHORIZATION.**
>
> This project plan is a reference document only. No work may be performed on any phase, step, or deliverable unless the user has given a clear, unambiguous instruction to do so in the current conversation.
>
> **Rules for AI agents:**
> 1. **Do not** start, continue, or resume any work on this project autonomously.
> 2. **Do not** create, modify, or delete any files related to this project unless the user explicitly asks you to.
> 3. **Do not** assume that because this file exists, work is authorized — it is not.
> 4. **Do not** offer to begin working on any phase or step. Wait for the user to ask.
> 5. If the user asks a general question about this plan (e.g., "what's in Phase 3?"), answer the question only — do not offer to execute it.
> 6. If the user gives a specific instruction to modify or execute part of this plan, proceed only with that exact instruction.
>
> **Why this exists:** AI agents lose context between sessions. Without this lock, an agent could resume a previous conversation's context and start modifying files or running commands without the user's knowledge or consent. This lock ensures the user remains in control at all times.
>
> **To authorize work:** The user will explicitly say something like "Start Phase 0" or "Work on step 1.1". Until then, do nothing.

## Table of Contents

- [Project Overview](#project-overview)
  - [Goals and Objectives](#goals-and-objectives)
  - [Success Criteria](#success-criteria)
- [Project Scope](#project-scope)
  - [In Scope](#in-scope)
  - [Out of Scope](#out-of-scope)
  - [Deliverables](#deliverables)
- [Dependencies](#dependencies)
  - [Internal Dependencies](#internal-dependencies)
  - [External Dependencies](#external-dependencies)
- [Work Breakdown](#work-breakdown)
  - [Phase 0 — Audit & Inventory](#phase-0--audit--inventory)
  - [Phase 1 — Repository Restructure](#phase-1--repository-restructure)
  - [Phase 2 — Ansible Foundation & Package Role](#phase-2--ansible-foundation--package-role)
  - [Phase 3 — Dotfiles Symlink Migration (Stow)](#phase-3--dotfiles-symlink-migration-stow)
  - [Phase 4 — System Configuration Role](#phase-4--system-configuration-role)
  - [Phase 5 — Desktop Environment Role](#phase-5--desktop-environment-role)
  - [Phase 6 — Scripts & Tooling Role](#phase-6--scripts--tooling-role)
  - [Phase 7 — Bootstrap Installer Overhaul](#phase-7--bootstrap-installer-overhaul)
  - [Phase 8 — Additional Install Scripts](#phase-8--additional-install-scripts)
  - [Phase 9 — Testing & Validation](#phase-9--testing--validation)
  - [Phase 10 — Documentation & Handover](#phase-10--documentation--handover)
- [Resources](#resources)
  - [Infrastructure Requirements](#infrastructure-requirements)
  - [Development Environment](#development-environment)
  - [Budget and Costs](#budget-and-costs)
  - [External Services](#external-services)
- [Validation and Testing](#validation-and-testing)
  - [Validation Requirements](#validation-requirements)
  - [Testing Requirements](#testing-requirements)
- [Risks and Issues](#risks-and-issues)
  - [Key Risks](#key-risks)
  - [Current Issues](#current-issues)
- [Notes](#notes)
- [Revision History](#revision-history)

## Project Overview

**Project ID:** Proj-002
**Status:** Planning
**Start Date:** 2026-05-04
**Target Completion:** 2026-06-15
**Last Updated:** 2026-05-04

### Goals and Objectives

- **Primary Goal:** Migrate the dotfiles repository from a mixed GNU Stow/loose-file state to a clean, modular Ansible-driven configuration management system with a standardized repository structure
- **Key Objectives:**
  1. Audit all existing dotfiles, scripts, and configurations to create a complete inventory
  2. Restructure the repository so that `.config/` and `.local/` are moved into `stow/` subdirectories, with only core infrastructure folders at the root (`.git`, `.avante`, `_scratch`, `ansible`, `stow`, `bootstrap`)
  3. Design and implement a modular Ansible project structure with reusable roles
  4. Create a cross-platform package management role (Arch/Debian/Ubuntu/openSUSE)
  5. Migrate all dotfiles to Ansible tasks with proper idempotency, using GNU Stow as the symlink mechanism
  6. Overhaul the bootstrap installer to use `ansible-pull` for fully automated provisioning
  7. Create additional install scripts for different system types (servers, workstations, laptops)
  8. Add validation and testing to verify the migration is complete and correct

### Success Criteria

- Repository root contains only: `.git/`, `.avante/`, `_scratch/`, `ansible/`, `stow/`, `bootstrap/`, `.gitignore`, `AGENTS.md`, `README.md`
- All dotfiles from `.config/` and `.local/` are moved into `stow/` under appropriate subdirectories
- The bootstrap installer can provision a fresh system from zero to fully configured using `ansible-pull`
- Ansible playbooks are idempotent — running them multiple times produces the same result
- Cross-platform support is maintained (Arch Linux, Debian, Ubuntu, openSUSE)
- Package installations are managed through Ansible with proper OS detection
- Multiple install scripts exist for different system types (laptop, workstation, server)
- All Ansible roles are documented with clear purpose and usage
- A dry-run mode exists for previewing changes before applying them

## Project Scope

### In Scope

- **Repository Restructure**: Move `.config/` and `.local/` into `stow/` subdirectories, clean up root-level files
- **Ansible Project Structure**: Modular role-based layout with inventory, playbooks, group_vars, and host_vars
- **Package Management Role**: Cross-platform package installation (pacman, apt, zypper) with idempotency
- **Dotfiles Symlink Role**: Ansible tasks that invoke GNU Stow to manage symlinks for all config files
- **System Configuration Role**: Hostname, locale, timezone, SSH config, environment variables
- **Desktop Environment Role**: Hyprland, Waybar, kitty, mako, fuzzel, waypaper, wezterm, starship, neovide
- **Scripts & Tooling Role**: `~/.local/bin/` scripts (screenshot, SSH, neovide-workspace) deployment
- **Bash Configuration Role**: `.bashrc`, `.config/bash/*.sh` files, aliases, paths, functions
- **Bootstrap Installer Overhaul**: Rewrite `install-laptop.sh` to use `ansible-pull` with proper OS detection
- **Additional Install Scripts**: Create `install-server.sh`, `install-workstation.sh` for different system types
- **Validation Playbook**: Idempotency checks, file presence verification, service status checks

### Out of Scope

- Migration of Kubernetes cluster infrastructure (covered by Proj-003)
- Migration of SSH server configuration on remote hosts
- Migration of Docker/Podman container configurations
- Migration of CI/CD pipeline configurations (Woodpecker)
- Migration of database credentials and secrets management (handled separately)
- Migration of Neovim plugin data and LSP server binaries (handled by lazy.nvim and mason.nvim at runtime)
- Migration of browser profiles, bookmarks, or extensions
- Migration of application data (game saves, chat history, etc.)
- Migration of systemd user services (unless already in dotfiles)
- Migration of GPG/SSH keys (handled separately for security)
- Migration of `.config/nvim/.env` (contains API keys — handled separately)

### Deliverables

| #   | Phase Name                 | Description                                                           | Completed By |
| --- | -------------------------- | --------------------------------------------------------------------- | ------------ |
| 1   | Audit & Inventory          | Complete inventory of all dotfiles, scripts, and configurations       | Phase 0      |
| 2   | Repository Restructure     | `.config/` and `.local/` moved into `stow/`, root cleaned up          | Phase 1      |
| 3   | Ansible Foundation         | Modular Ansible project structure with inventory, playbooks, and vars | Phase 2      |
| 4   | Package Management Role    | Cross-platform package installation with OS detection                 | Phase 2      |
| 5   | Dotfiles Symlink Role      | Ansible tasks invoking GNU Stow for all config files                  | Phase 3      |
| 6   | System Configuration Role  | Hostname, locale, SSH config, environment variables                   | Phase 4      |
| 7   | Desktop Environment Role   | Hyprland, Waybar, kitty, mako, fuzzel, wezterm, starship              | Phase 5      |
| 8   | Scripts & Tooling Role     | `~/.local/bin/` scripts deployment                                    | Phase 6      |
| 9   | Bootstrap Installer        | Rewritten `install-laptop.sh` using `ansible-pull`                    | Phase 7      |
| 10  | Additional Install Scripts | `install-server.sh`, `install-workstation.sh`                         | Phase 8      |
| 11  | Testing & Validation       | Idempotency checks, file verification, dry-run testing                | Phase 9      |
| 12  | Documentation              | Complete documentation of all roles, scripts, and procedures          | Phase 10     |

## Dependencies

### Internal Dependencies

- **Phase 0 (Audit) → All Phases**: The audit output drives the scope of every subsequent phase
- **Phase 1 (Restructure) → Phases 2-8**: Repository must be restructured before Ansible roles can reference correct paths
- **Phase 2 (Ansible Foundation) → Phases 3-8**: Ansible project structure must exist before roles can be created
- **Phase 2 (Packages) → Phases 3-6**: Package installation must work before config files can reference installed tools
- **Phase 3 (Stow Migration) → Phase 7**: Stow structure must be in place before bootstrap can use it
- **Phase 7 (Bootstrap) → Phases 2-6**: Bootstrap installer depends on all roles being complete
- **Phase 8 (Install Scripts) → Phase 7**: Additional scripts build on the bootstrap pattern
- **Phase 9 (Testing) → Phases 2-8**: Testing can only begin after roles are implemented
- **Phase 10 (Docs) → All Phases**: Documentation is the final step after everything is verified

### External Dependencies

- **Ansible**: Must be installed on the control node (workstation) and target systems
- **Ansible Collections**: `community.general`, `ansible.posix` for common modules
- **Git**: For cloning the dotfiles repository during bootstrap
- **Python 3**: Required by Ansible on all target systems
- **Package Managers**: pacman (Arch), apt (Debian/Ubuntu), zypper (openSUSE) on target systems
- **GNU Stow**: Remains as the symlink mechanism, invoked by Ansible tasks

## Work Breakdown

### Phase 0 — Audit & Inventory

#### Phase 0 Status

| Item | Status |
|------|--------|
| **Phase Complete** | ✅ Yes |
| **Completed By** | DeepSeek (AI Agent) |
| **Completion Date** | 2026-05-05 |
| **Deliverable Location** | `.avante/context/project_deliverables/proj-002/Deliverable 1 - File Inventory.md` |
| **Next Phase** | [Phase 1 — Repository Restructure](#phase-1--repository-restructure) |

**Goal:** Create a complete inventory of all dotfiles, scripts, and configurations in the repository, documenting their purpose, dependencies, and stow package location.

> **Note:** The files from `.config/` and `.local/` have already been moved into `stow/` subdirectories. The inventory should be created by analyzing the current `stow/` directory structure rather than the original locations — the stow packages are the authoritative source.

#### Phase 0 Deliverables

| #   | Deliverable            | Description                                                                     | Location                                                                 |
| --- | ---------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| 1   | **Complete Inventory** | Documented list of every file in `stow/` packages and at repository root, organized by stow package with purpose, cross-platform status, and notes | `.avante/context/project_deliverables/proj-002/Deliverable 1 - File Inventory.md` |

#### 0.1 — Inventory `stow/` packages (replaces original `.config/`)

- Analyze each stow package directory under `stow/` and list every file
- Document the purpose of each config file/directory
- Note which applications/packages each config belongs to
- Identify any files that should not be migrated (e.g., `.env` with secrets)
- **Format:** Markdown table with columns: File, Purpose, Cross-Platform, Notes
- **Sections:** One table per stow package (`bash/`, `desktop_environment/`, `neovim_neovide/`, `aur_helper/`, `app_desktop_files/`)

#### 0.2 — Inventory `stow/` packages (replaces original `.local/`)

- Analyze each stow package directory under `stow/` for `.local/` content and list every file
- Document the purpose of each script and tool
- Note any scripts that have external dependencies (e.g., fuzzel for GUI menus)
- **Format:** Same markdown table format as 0.1, integrated into the per-package tables
- **Sections:** `stow/bash/` (screenshot-scripts, ssh-scripts), `stow/neovim_neovide/` (neovide-workspace), `stow/app_desktop_files/` (.desktop files)

#### 0.3 — Inventory root-level dotfiles

- List all files at repository root (`.gitignore`, `AGENTS.md`, `README.md`, etc.)
- Determine which should remain at root and which should move into `stow/`
- Document the `.stow-local-ignore` patterns and their purpose
- **`nvim-plugins-source/`** — a copy of Neovim plugin source files for code analysis. This directory should NOT be symlinked (it's already in `.stow-local-ignore`) and should NOT be migrated into any stow package. It exists at root purely for reference and is machine-specific.

#### 0.4 — Analyze `fix-symlinks.sh` script

- Review the existing `bootstrap/fix-symlinks.sh` script
- Document what it does: which stow packages it targets, what flags it uses, any error handling
- Identify what the script does that should be replicated in the Ansible stow role (Phase 3) — the script itself stays, but its behavior should be reproduced in Ansible for automated provisioning
- Note any hardcoded paths or assumptions that need to be updated
- Use the script's logic as reference when creating the Ansible stow role (Phase 3) — do not delete or deprecate the script

#### 0.5 — Identify cross-platform concerns

- Note which configs are OS-specific (e.g., pacman vs apt package names)
- Document which configs are universal and can be applied to any Linux distribution
- Identify any configs that depend on specific hardware or desktop environment

### Phase 1 — Repository Restructure

#### Phase 1 Status

| Item | Status |
|------|--------|
| **Phase Complete** | ❌ No |
| **Completed By** | — |
| **Completion Date** | — |
| **Deliverable Location** | — |
| **Next Phase** | [Phase 2 — Ansible Foundation & Package Role](#phase-2--ansible-foundation--package-role) |

**Goal:** Move `.config/` and `.local/` into `stow/` subdirectories, clean up root-level files, and establish the canonical repository layout.

#### Phase 1 Deliverables

| #   | Deliverable                 | Description                                                                    |
| --- | --------------------------- | ------------------------------------------------------------------------------ |
| 1   | **Restructured Repository** | `.config/` and `.local/` moved into `stow/`, root cleaned to core folders only |

#### 1.1 — Distribute `.config/` contents into appropriate stow packages

> **Current state: ✅ Already done.** `.config/` has been removed from the repo root. All config files are distributed across stow packages. The wezterm config was intentionally deleted (user switched to kitty). The broken `~/.config/wezterm` symlink (pointing to the deleted directory) needs to be removed as cleanup.

- Audit all items in `.config/` at the repo root and map each to the correct stow package
- **`stow/desktop_environment/.config/`** already contains: backgrounds, fuzzel, hypr, kitty, mako, starship.toml, Thunar, waybar, waypaper, xfce4
  - No additional items from `.config/` need to go here (desktop env config is already in place)
  - **Note:** Wezterm config was deleted — the user now uses kitty as the primary terminal emulator. The broken `~/.config/wezterm` symlink (leftover from the old structure) should be removed. No wezterm config should be added to any stow package.
- **`stow/bash/.config/`** already contains: bash/ directory with shell config files
  - No additional items from `.config/` need to go here (bash config is already in place)
- **`stow/neovim_neovide/.config/`** already contains: neovide/, nvim/
  - No additional items from `.config/` need to go here (neovim/neovide config is already in place)
- **`stow/aur_helper/`** — new stow package for AUR helper configuration
  - Move `.config/paru.conf` into `stow/aur_helper/.config/paru.conf`
  - Paru is a package manager, not a desktop environment component — it needs its own dedicated stow package
  - **Naming note:** The package is called `aur_helper` rather than `paru` because it describes the _purpose_ (AUR helper configuration), not the specific tool. If you switch to a different AUR helper (e.g., yay) in the future, the stow package name remains meaningful.
- **`fonts/` at repo root** — do NOT migrate into stow. Fonts are binary files (`.ttf`) that need to be installed to `~/.local/share/fonts/` and registered with `fc-cache`, not symlinked. They also bloat the git repo at 125MB. Instead, handle font installation through Ansible's package role (see Phase 2.4) or the system/fonts role (see Step 1.6).
- **New stow packages** may be needed for configs that don't fit existing categories
- Verify each config file is correctly placed in its target stow package directory
- Ensure the `.config/` directory at repo root is removed after all files are distributed
- Update `.stow-local-ignore` to exclude repository-specific files from symlinking
- Verify the move preserves file permissions and metadata

#### 1.2 — Distribute `.local/` contents into appropriate stow packages

> **Current state: ✅ Already done.** `.local/` has been removed from the repo root. All local files are distributed across stow packages.

- Audit all items in `.local/` at the repo root and map each to the correct stow package
- **`stow/bash/.local/`** already contains: `bin/screenshot-scripts/`, `bin/ssh-scripts/`
  - Move `.local/bin/` (all custom scripts and tools) into `stow/bash/.local/bin/`
  - **Note:** All custom scripts and tools belong in the `stow/bash/` package — this includes screenshot scripts, SSH scripts, and any future custom executables. Do NOT create a separate `stow/local/` package — the bash package is the correct home for all custom scripts.
- **`stow/app_desktop_files/.local/`** already contains: `share/applications/` with .desktop files
  - Move `.local/share/applications/` into `stow/app_desktop_files/.local/share/applications/`
  - Desktop files are already organized in their own stow package — no changes needed to the existing structure
- **`stow/neovim_neovide/.local/`** contains: `bin/neovide-workspace` and `share/applications/neovide-workspace.desktop`
  - The `.desktop` file intentionally lives in the `neovim_neovide` stow package alongside the Neovide-related script it references
  - **Exception:** This creates a stow package overlap — both `neovim_neovide` and `app_desktop_files` manage `.local/share/applications/`. This is intentional because `neovide-workspace.desktop` is a Neovide-specific file that belongs with its associated tool. The `app_desktop_files` package manages all other `.desktop` files. Stow handles this correctly because `neovim_neovide` is stowed first, creating individual symlinks for its files, and `app_desktop_files` is stowed second, creating a directory symlink for `.local/share/applications/` (which includes the neovide-workspace.desktop entry via the directory).
- **Items needing new packages:**
  - `.local/share/vlc/` — VLC skin/config may need its own stow package (e.g., `stow/vlc/`)
- Verify each file is correctly placed in its target stow package directory
- Ensure the `.local/` directory at repo root is removed after all files are distributed
- Update `.stow-local-ignore` to exclude repository-specific files from symlinking
- Verify the move preserves file permissions and metadata

#### 1.3 — Clean up root-level files

> **Current state: ✅ Already done.** `.bashrc` is in `stow/bash/.bashrc`, `.config/starship.toml` is in `stow/desktop_environment/.config/starship.toml`, `.config/paru.conf` is in `stow/aur_helper/.config/paru.conf`. Root contains only core infrastructure.

- Move `.bashrc` into `stow/` (it's a dotfile that should be symlinked) — **done**
- Move `.config/starship.toml` into `stow/.config/` if not already there — **done**
- Move `.config/paru.conf` into `stow/.config/` if not already there — **done**
- Ensure only core infrastructure remains at root: `.git/`, `.avante/`, `_scratch/`, `ansible/`, `stow/`, `bootstrap/`, `.gitignore`, `AGENTS.md`, `README.md`
- **`nvim-plugins-source/`** at root is intentional — it's a local reference for avante.nvim code analysis, excluded from git via `.gitignore` and from stow via `.stow-local-ignore`

#### 1.4 — Update `.stow-local-ignore`

- Add patterns for files that should never be symlinked: `AGENTS.md`, `README.md`, `.avante/*`, `.gitignore`, `.git/*`, `.stow-local-ignore`, `_scratch/*`, `ansible/*`
- Test that `stow .` from repository root produces the correct symlinks
- Verify no unintended files are symlinked

#### 1.5 — Test Stow still works after restructure

- Run `stow --adopt -v .` from repository root (or `stow -v config local` for targeted stow)
- Verify all expected symlinks are created in `~/.config/` and `~/.local/`
- Check that no broken symlinks exist
- Confirm the system still works as before (open terminal, launch Hyprland, etc.)

#### 1.6 — Create Ansible role for font installation

- Create `ansible/roles/system/fonts/tasks/main.yaml` with tasks to install font files
- The role should copy font files from a designated source directory (e.g., `ansible/roles/system/fonts/files/`) to `~/.local/share/fonts/`
- After copying, run `fc-cache -fv` to register the fonts with the fontconfig system
- Use the `copy` module with `mode: 0644` to deploy `.ttf` and `.otf` font files
- Ensure idempotency — only copy files that have changed, and only run `fc-cache` when new fonts are added
- Support both user-level font installation (`~/.local/share/fonts/`) and system-level (`/usr/local/share/fonts/`) via an Ansible variable
- Add a `fonts` tag to allow selective execution of font tasks
- Document the font source directory structure and how to add new fonts
- **Note:** The `fonts/` directory at the repository root (containing 125MB of `.ttf` files) should NOT be symlinked via Stow. Instead, font files should be stored in `ansible/roles/system/fonts/files/` and deployed via Ansible's `copy` module, which handles binary files correctly and avoids bloating the stow symlink tree.

### Phase 2 — Ansible Foundation & Package Role

#### Phase 2 Status

| Item | Status |
|------|--------|
| **Phase Complete** | ❌ No |
| **Completed By** | — |
| **Completion Date** | — |
| **Deliverable Location** | — |
| **Next Phase** | [Phase 3 — Dotfiles Symlink Migration (Stow)](#phase-3--dotfiles-symlink-migration-stow) |

**Goal:** Establish the modular Ansible project structure and create the cross-platform package management role that handles OS detection and package installation.

#### Phase 2 Deliverables

| #   | Deliverable                   | Description                                                       |
| --- | ----------------------------- | ----------------------------------------------------------------- |
| 1   | **Ansible Project Structure** | Inventory, playbooks, group_vars, host_vars, and role directories |
| 2   | **Package Management Role**   | Cross-platform package installation with OS detection             |

#### 2.1 — Design Ansible project structure

- Create `ansible/inventory/` with host groups (laptops, workstations, servers)
- Create `ansible/playbooks/` with main playbook and component playbooks
- Create `ansible/group_vars/` for OS-specific variables (package names, paths)
- Create `ansible/host_vars/` for host-specific overrides
- Create `ansible/roles/` directory structure for all planned roles
- Create `ansible/ansible.cfg` with project-wide Ansible configuration

#### 2.2 — Create base playbook structure

- Create `ansible/playbooks/site.yaml` as the main entry point
- Create `ansible/playbooks/bootstrap.yaml` for initial system setup
- Create `ansible/playbooks/desktop.yaml` for desktop environment setup
- Create `ansible/playbooks/server.yaml` for headless server setup
- Create `ansible/playbooks/validate.yaml` for post-provisioning validation

#### 2.3 — Create package management role

- Create `ansible/roles/packages/tasks/main.yaml` with OS detection logic
- Define package lists in `ansible/roles/packages/vars/` for each OS:
  - `Arch.yml` — packages for pacman
  - `Debian.yml` — packages for apt
  - `Ubuntu.yml` — packages for apt (may inherit from Debian)
  - `openSUSE.yml` — packages for zypper
- Create `ansible/roles/packages/tasks/` sub-tasks for each package manager
- Ensure idempotency — running multiple times produces the same result

#### 2.4 — Define package categories

- **Core system packages**: git, curl, wget, stow, openssh, python3
- **Desktop packages**: hyprland, waybar, kitty, mako, fuzzel, waypaper, wezterm, starship
- **Development packages**: neovim, nodejs, npm, python-pip, lazygit, k9s, kubectl, helm
- **Media packages**: grim, slurp, wl-clipboard, wf-recorder, imagemagick
- **Font packages**: ttf-jetbrains-mono, ttf-font-awesome, noto-fonts
- Each category should be a separate variable list for composability

#### 2.5 — Test package role on each OS

- Test on Arch Linux (primary development machine)
- Test on Debian/Ubuntu (server VMs or containers)
- Test on openSUSE (if available, otherwise document as untested)
- Verify idempotency by running the playbook twice
- Document any OS-specific issues or workarounds

### Phase 3 — Dotfiles Symlink Migration (Stow)

#### Phase 3 Status

| Item | Status |
|------|--------|
| **Phase Complete** | ❌ No |
| **Completed By** | — |
| **Completion Date** | — |
| **Deliverable Location** | — |
| **Next Phase** | [Phase 4 — System Configuration Role](#phase-4--system-configuration-role) |

**Goal:** Create Ansible roles that invoke GNU Stow to manage symlinks for all dotfiles, replacing manual Stow commands with idempotent Ansible tasks.

#### Phase 3 Deliverables

| #   | Deliverable           | Description                                              |
| --- | --------------------- | -------------------------------------------------------- |
| 1   | **Stow Symlink Role** | Ansible role that runs `stow` for each package directory |

#### 3.1 — Create the stow role

- Create `ansible/roles/stow/tasks/main.yaml`
- Implement tasks that run `stow` for each package directory (config, local, bash, etc.)
- Use the `command` module to invoke `stow` with appropriate flags
- Add `creates` or `changed_when` conditions for idempotency
- Support both `stow` and `unstow` operations via Ansible tags

#### 3.2 — Define stow packages in variables

- Create `ansible/roles/stow/vars/main.yaml` with the list of stow packages
- Each package maps to a subdirectory under `stow/` (e.g., `config`, `local`)
- Allow enabling/disabling specific packages via Ansible variables
- Support for `--adopt` flag to handle existing files during initial setup

#### 3.3 — Handle edge cases

- Existing files that conflict with symlinks (use `--adopt` or backup strategy)
- Files that should not be symlinked (use `.stow-local-ignore` patterns)
- Permission preservation for executable scripts in `~/.local/bin/`
- Dry-run mode using `--no` flag for previewing changes

#### 3.4 — Test the stow role

- Run the role on the current workstation and verify all symlinks are correct
- Test unstow operation and verify files are removed
- Test idempotency — running the role multiple times produces no changes
- Test dry-run mode and verify no actual changes are made

### Phase 4 — System Configuration Role

#### Phase 4 Status

| Item | Status |
|------|--------|
| **Phase Complete** | ❌ No |
| **Completed By** | — |
| **Completion Date** | — |
| **Deliverable Location** | — |
| **Next Phase** | [Phase 5 — Desktop Environment Role](#phase-5--desktop-environment-role) |

**Goal:** Create an Ansible role for system-level configuration — hostname, locale, timezone, SSH config, and environment variables.

#### Phase 4 Deliverables

| #   | Deliverable                   | Description                                         |
| --- | ----------------------------- | --------------------------------------------------- |
| 1   | **System Configuration Role** | Hostname, locale, SSH config, environment variables |

#### 4.1 — Create the system role

- Create `ansible/roles/system/tasks/main.yaml`
- Implement tasks for hostname, locale, and timezone configuration
- Use the `hostname` module for hostname, `locale_gen` for locale
- Ensure idempotency with `when` conditions and `changed_when`

#### 4.2 — Configure SSH

- Deploy `~/.ssh/config` via Ansible template (if not managed by Stow)
- Set SSH defaults: `StrictHostKeyChecking accept-new`, `ServerAliveInterval 60`
- Add host entries for known servers (node-01, node-02, gateway)
- Ensure SSH directory has correct permissions (700)

#### 4.3 — Configure environment variables

- Deploy `~/.config/bash/00-env.sh` via Ansible template
- Set common environment variables (EDITOR, BROWSER, TERMINAL, etc.)
- Add PATH entries for `~/.local/bin/` and other custom paths
- Support OS-specific environment variables

#### 4.4 — Test the system role

- Run on current workstation and verify all settings are applied
- Test on a fresh system (VM or container) to verify from-scratch provisioning
- Verify idempotency by running the role twice

### Phase 5 — Desktop Environment Role

**Goal:** Create an Ansible role that deploys and configures the Hyprland/Wayland desktop environment — window manager, bar, terminal, notifications, launcher, wallpaper, and shell prompt.

#### Phase 5 Deliverables

| #   | Deliverable                  | Description                                                       |
| --- | ---------------------------- | ----------------------------------------------------------------- |
| 1   | **Desktop Environment Role** | Hyprland, Waybar, kitty, mako, fuzzel, wezterm, starship, neovide |

#### 5.1 — Create the desktop role

- Create `ansible/roles/desktop/tasks/main.yaml`
- Organize tasks into subdirectories for each component
- Use the package role to ensure all desktop packages are installed first
- Deploy config files via Stow (Phase 3) or template tasks

#### 5.2 — Configure Hyprland

- Deploy `hyprland.conf` with keybindings, monitors, and workspace settings
- Deploy `hyprpaper.conf` for wallpaper management
- Deploy `hyprlock.conf` for screen locking
- Ensure Hyprland starts correctly after deployment

#### 5.3 — Configure Waybar

- Deploy `config.jsonc` with modules (workspaces, clock, system tray, screenshot button)
- Deploy `style.css` with consistent theming
- Verify all Waybar modules render correctly

#### 5.4 — Configure terminal emulators

- Deploy `kitty/kitty.conf` with Tokyo Night theme and font settings

#### 5.5 — Configure desktop utilities

- Deploy `mako/config` for notification daemon settings
- Deploy `fuzzel/fuzzel.ini` for application launcher
- Deploy `waypaper/config.ini` for wallpaper manager
- Deploy `starship.toml` for shell prompt customization
- Deploy `neovide/config.toml` for Neovide GUI settings

#### 5.6 — Test the desktop role

- Run on current workstation and verify all desktop components work
- Test on a fresh system to verify from-scratch desktop provisioning
- Verify idempotency by running the role twice

### Phase 6 — Scripts & Tooling Role

**Goal:** Create an Ansible role that deploys all custom scripts and tools from `~/.local/bin/`, ensuring they are executable and properly integrated into the system PATH.

#### Phase 6 Deliverables

| #   | Deliverable                | Description                                                 |
| --- | -------------------------- | ----------------------------------------------------------- |
| 1   | **Scripts & Tooling Role** | `~/.local/bin/` scripts deployment with correct permissions |

#### 6.1 — Create the scripts role

- Create `ansible/roles/scripts/tasks/main.yaml`
- Deploy scripts via Stow (from `stow/.local/bin/`) or copy tasks
- Ensure all scripts have executable permissions (0755)
- Verify scripts are accessible from `~/.local/bin/` in PATH

#### 6.2 — Deploy screenshot scripts

- Deploy all scripts from `stow/.local/bin/screenshot-scripts/`
- Verify dependencies: grim, slurp, wl-clipboard, wf-recorder
- Test each script: screenshot-full, screenshot-region, screenshot-window, screenshot-menu
- Test each recording script: screenrecord-full, screenrecord-region, screenrecord-stop, screenrecord-status, screenrecord-menu

#### 6.3 — Deploy SSH scripts

- Deploy `ssh-connect.sh` and `ssh-list.sh` from `stow/.local/bin/ssh-scripts/`
- Verify SSH config is properly set up (Phase 4)
- Test `ssh-connect` interactive menu
- Test `ssh-list` with table, simple, and json output formats

#### 6.4 — Deploy other tools

- Deploy `neovide-workspace` script from `stow/.local/bin/`
- Verify any additional scripts in `~/.local/bin/` are deployed
- Ensure all scripts have proper shebangs and are executable

#### 6.5 — Test the scripts role

- Run on current workstation and verify all scripts are present and executable
- Test each script produces expected output
- Verify PATH includes `~/.local/bin/`

### Phase 7 — Bootstrap Installer Overhaul

**Goal:** Rewrite the bootstrap installer to use `ansible-pull` for fully automated provisioning, with proper OS detection and dependency installation.

#### Phase 7 Deliverables

| #   | Deliverable             | Description                                        |
| --- | ----------------------- | -------------------------------------------------- |
| 1   | **Bootstrap Installer** | Rewritten `install-laptop.sh` using `ansible-pull` |

#### 7.1 — Analyze current bootstrap installer

- Review the existing `bootstrap/install-laptop.sh` script
- Document what it currently does: OS detection, package installation, Ansible setup
- Identify what works well and what needs improvement
- Note any hardcoded paths or assumptions that need to be generalized

#### 7.2 — Design the new bootstrap architecture

- The install script should be minimal — just enough to bootstrap Ansible
- Ansible handles everything else via `ansible-pull`
- Support multiple system types via different install scripts:
  - `install-laptop.sh` — full desktop environment
  - `install-workstation.sh` — development tools without full desktop
  - `install-server.sh` — minimal server setup
- Each script sets the appropriate Ansible tags or variables

#### 7.3 — Rewrite `install-laptop.sh`

- Keep the OS detection logic (Arch, Debian, Ubuntu, openSUSE)
- Install minimal prerequisites: git, python3, ansible
- Clone the dotfiles repository (or use existing checkout)
- Run `ansible-pull` with the appropriate playbook and tags
- Add progress indicators and error handling
- Support both interactive and non-interactive modes

#### 7.4 — Create `install-workstation.sh`

- Similar structure to `install-laptop.sh` but targets workstation role
- Installs development tools but may skip desktop environment
- Useful for setting up a secondary development machine

#### 7.5 — Create `install-server.sh`

- Minimal bootstrap for headless servers
- Installs only core system packages and SSH configuration
- No desktop environment, no GUI tools
- Useful for setting up Kubernetes nodes or other servers

#### 7.6 — Test the bootstrap installer

- Test on a fresh Arch Linux installation (VM or container)
- Test on a fresh Debian/Ubuntu installation
- Test on openSUSE if available
- Verify the entire process from zero to fully configured system
- Document any issues encountered during testing

### Phase 8 — Additional Install Scripts

**Goal:** Create install scripts for different system types beyond laptops — workstations and servers — each tailored to their specific role and package requirements.

#### Phase 8 Deliverables

| #   | Deliverable                    | Description                                   |
| --- | ------------------------------ | --------------------------------------------- |
| 1   | **Additional Install Scripts** | `install-server.sh`, `install-workstation.sh` |

#### 8.1 — Define system type profiles

- **Laptop**: Full desktop environment, development tools, media tools, fonts
- **Workstation**: Development tools, SSH config, scripts, no desktop environment
- **Server**: Core system packages, SSH config, minimal footprint
- Document the package and role differences between each profile

#### 8.2 — Create `install-workstation.sh`

- Bootstrap script for secondary development machines
- Installs core packages, development tools, and SSH configuration
- Skips Hyprland/Wayland desktop environment
- Useful for setting up a machine that connects to the cluster

#### 8.3 — Create `install-server.sh`

- Bootstrap script for headless servers (Kubernetes nodes, etc.)
- Installs only server-essential packages (no GUI, no development tools)
- Configures SSH with hardened settings (key-only auth, disable root login)
- Sets up firewall rules (ufw or iptables) for server workloads
- Installs Docker/Podman and Kubernetes tooling (kubectl, Helm, k9s)
- Configures NTP, log rotation, and system monitoring basics
- Skips all desktop environment, audio, and display-related packages
- Designed to be idempotent — safe to re-run on existing servers

#### 8.4 — Test each install script

- Test `install-workstation.sh` on a fresh Arch Linux VM or container
- Test `install-server.sh` on a fresh Debian/Ubuntu VM
- Verify each script correctly detects the OS and installs the right packages
- Confirm the workstation script skips desktop environment packages
- Confirm the server script installs only server-essential packages
- Test idempotency by running each script twice
- Document any OS-specific issues or workarounds

### Phase 9 — Testing & Validation

**Goal:** Create a comprehensive testing and validation framework to verify the migration is complete, idempotent, and produces the correct system configuration.

#### Phase 9 Deliverables

| #   | Deliverable             | Description                                                           |
| --- | ----------------------- | --------------------------------------------------------------------- |
| 1   | **Validation Playbook** | Idempotency checks, file presence verification, service status checks |

#### 9.1 — Create validation playbook

- Create `ansible/playbooks/validate.yaml` with comprehensive validation tasks
- Verify all expected symlinks exist and point to the correct targets
- Check that all expected packages are installed
- Verify all scripts are present and executable
- Confirm SSH config has correct entries and permissions

#### 9.2 — Implement idempotency testing

- Run each playbook twice and verify no changes on the second run
- Document any tasks that are not idempotent and fix them
- Add `changed_when` conditions to suppress false-positive changes
- Test with `--check` mode to verify dry-run behavior

#### 9.3 — Test cross-platform compatibility

- Run validation playbook on each supported OS (Arch, Debian, Ubuntu)
- Document any OS-specific differences in validation results
- Verify OS detection logic works correctly for each distribution
- Test with different package manager configurations

#### 9.4 — Test disaster recovery

- Simulate a broken symlink scenario and verify the validation playbook detects it
- Test recovery by re-running the stow role to restore missing symlinks
- Simulate a missing package scenario and verify the package role re-installs it
- Test bootstrap from scratch on a clean VM to verify full recovery
- Document the recovery procedure for each failure scenario

#### 9.5 — Document test results

- Create a test report documenting all validation results
- Include screenshots or logs for each test scenario
- Document any known issues or limitations found during testing
- Create a checklist for future testing after repository changes

### Phase 10 — Documentation & Handover

**Goal:** Create comprehensive documentation for the entire Ansible-based dotfiles management system, covering all roles, scripts, procedures, and troubleshooting.

#### Phase 10 Deliverables

| #   | Deliverable                | Description                                            |
| --- | -------------------------- | ------------------------------------------------------ |
| 1   | **Complete Documentation** | README files, role documentation, and procedure guides |

#### 10.1 — Document the Ansible project structure

- Create `ansible/README.md` with an overview of the project structure
- Document each role's purpose, variables, and usage
- Explain the playbook hierarchy and how to run specific playbooks
- Include a quick-start guide for new systems

#### 10.2 — Document the bootstrap process

- Update `bootstrap/README.md` with instructions for each install script
- Document the supported operating systems and their prerequisites
- Include troubleshooting guidance for common bootstrap failures
- Explain how to customize the bootstrap for different system types

#### 10.3 — Document the repository structure

- Update the main `README.md` with the new repository layout
- Explain the purpose of each top-level directory
- Document the Stow symlink management approach
- Include a migration guide for existing users

#### 10.4 — Document maintenance procedures

- Create `ansible/MAINTENANCE.md` with common maintenance tasks
- Document how to add new packages to the package role
- Document how to add new dotfiles to the stow role
- Document how to update the bootstrap installer for new OS versions
- Include troubleshooting guidance for common maintenance issues
- Document backup and recovery procedures for the dotfiles repository

#### 10.5 — Create troubleshooting guide

- Create `ansible/TROUBLESHOOTING.md` with common issues and solutions
- Cover bootstrap failures (network issues, missing dependencies, OS detection errors)
- Cover Ansible playbook failures (syntax errors, module issues, permission problems)
- Cover Stow symlink issues (conflicts, broken symlinks, permission errors)
- Cover cross-platform issues (package name differences, path differences)
- Include diagnostic commands for each category of issue
- Document how to gather debug information for reporting issues

## Resources

### Infrastructure Requirements

- **Compute Resources:** Current Arch Linux workstation (Hyprland, Wayland) — no additional hardware needed
- **Storage:** Dotfiles repository on local SSD — minimal storage requirements
- **Network:** Local LAN for testing bootstrap on VMs and secondary machines

### Development Environment

- **Hardware:** Local Arch Linux workstation (Hyprland, Wayland)
- **Software/Tools:** Ansible, GNU Stow, git, Neovim, avante.nvim
- **Development Stack:** YAML (Ansible), Bash (scripts), Lua (Neovim)
- **Testing VMs:** LXC containers or VMs for cross-platform testing (Debian, Ubuntu)

### Budget and Costs

- **Infrastructure Costs:** $0 (all local hardware)
- **Service Costs:** $0 (no cloud services)
- **Total Budget:** $0 (time only)

### External Services

- **Git Repository:** GitHub (for cloning during bootstrap)
- **Package Repositories:** Arch Linux, Debian, Ubuntu, openSUSE official repos

## Validation and Testing

### Validation Requirements

- [ ] **Repository Structure Validation**: Root contains only core infrastructure folders
  - **Method:** `ls -la` at repository root
  - **Success:** Only `.git/`, `.avante/`, `_scratch/`, `ansible/`, `stow/`, `bootstrap/`, `.gitignore`, `AGENTS.md`, `README.md` present
- [ ] **Symlink Validation**: All dotfiles correctly symlinked to home directory
  - **Method:** `stow --no -v .` from repository root
  - **Success:** No errors, all expected symlinks listed
- [ ] **Package Installation Validation**: All required packages installed
  - **Method:** Run validation playbook
  - **Success:** All package checks pass
- [ ] **Bootstrap Validation**: Fresh system can be provisioned from zero
  - **Method:** Run `install-laptop.sh` on clean VM
  - **Success:** System fully configured with all dotfiles and packages
- [ ] **Idempotency Validation**: Running playbooks twice produces no changes
  - **Method:** Run each playbook twice, compare output
  - **Success:** Second run shows "ok=0 changed=0"

## Risks and Issues

### Key Risks

1. **Repository Restructure Disruption**: Moving `.config/` and `.local/` into `stow/` could break active symlinks
   - **Impact:** High
   - **Mitigation:** Perform restructure in a branch, test thoroughly before merging, keep backup of original structure

2. **Cross-Platform Incompatibility**: Package names and paths differ across distributions
   - **Impact:** Medium
   - **Mitigation:** Test on each supported OS, use Ansible's OS detection, maintain separate package lists

3. **Ansible Complexity**: Team may not be familiar with Ansible, increasing maintenance burden
   - **Impact:** Low
   - **Mitigation:** Document thoroughly, keep roles simple and focused, provide quick-start guides

4. **Bootstrap Failure**: `ansible-pull` may fail on systems without internet or with unusual configurations
   - **Impact:** Medium
   - **Mitigation:** Test on multiple OS versions, add fallback modes, provide offline installation instructions

5. **Scope Creep**: Migration may uncover additional configs or scripts that need to be migrated
   - **Impact:** Low
   - **Mitigation:** Strictly follow the audit inventory, defer out-of-scope items to future projects

### Current Issues

1. **Mixed Repository State**: `.config/` and `.local/` exist at root level alongside `stow/`, `ansible/`, and `bootstrap/`
   - **Status:** Open
   - **Next Steps:** Phase 1 will move these into `stow/` subdirectories

2. **Bootstrap Installer Not Functional**: `install-laptop.sh` has commented-out `ansible-pull` commands and incomplete OS setup functions
   - **Status:** Open
   - **Next Steps:** Phase 7 will rewrite the installer to properly use `ansible-pull`

3. **Ansible Roles Incomplete**: Existing `ansible/roles/` have only skeleton structures (dotfiles, system/networking)
   - **Status:** Open
   - **Next Steps:** Phases 2-6 will flesh out all roles with complete implementations

## Notes

- GNU Stow remains the symlink mechanism — Ansible orchestrates Stow rather than replacing it
- The bootstrap installer should be minimal — just enough to bootstrap Ansible, which handles everything else
- Cross-platform support is a key differentiator — the new system should work on Arch, Debian, Ubuntu, and openSUSE
- All secrets and API keys (`.env` files) must remain outside the repository — handled via environment variables or vault
- The `_scratch/` directory should be added to `.gitignore` to prevent accidental commits
- Testing on VMs or containers is recommended before running on production machines
- The existing `bootstrap/bootstrap.yaml` playbook references roles (`base`, `python`, `dotfiles`) that may need to be updated or replaced
- **Stow is OS-agnostic:** Stow creates symlinks regardless of whether the target software is installed. An unused config file (e.g., `paru.conf` on Debian) is completely harmless — it just sits there inert. This means the stow role can run unconditionally on any OS without needing OS detection logic. Ansible's package role handles OS-specific installations separately.

## Agent Execution Instructions

**These instructions are mandatory for any AI agent working on this project plan.**

### Sequential Phase Execution

1. **Phases MUST be executed in strict numeric order** — Phase 0 first, then Phase 1, then Phase 2, and so on through Phase 10.
2. **Within each phase, steps MUST be executed in numeric order** — e.g., 0.1 before 0.2, 0.2 before 0.3, etc.
3. **Do NOT skip ahead** to a later phase or step, even if it seems independent or self-contained.
4. **Do NOT rearrange steps** — follow the order as written in this document.
5. **Do NOT work on multiple phases simultaneously** — complete one phase entirely before moving to the next.

### Phase Completion Requirement

- A phase is only complete when **all** of its deliverables are finished and verified.
- Before moving to the next phase, mark the current phase as complete in the project tracking.
- If a phase depends on output from a prior phase, that prior phase must be fully complete before starting.

### Exception Handling

- If a step cannot be completed (e.g., missing information, external blocker), document the issue in the relevant phase notes and move to the next step within the same phase.
- If an entire phase is blocked, document the blocker and pause work on this project until the blocker is resolved.
- Do not skip a blocked phase to work on a later phase — this creates ordering issues and breaks dependencies.

### Rationale

Each phase builds on the deliverables of the previous phases. Working out of order will:

- Break internal dependencies (e.g., Phase 3 needs Phase 1's restructured paths)
- Create rework when earlier changes invalidate later work
- Make it impossible to verify idempotency and correctness
- Confuse the project tracking and progress reporting

## Revision History

| Version | Date       | Changes                                                            |
| ------- | ---------- | ------------------------------------------------------------------ |
| 1.0     | 2026-05-04 | Initial version — full project plan for Ansible migration          |
| 1.1     | 2026-05-05 | Added Agent Execution Instructions for sequential phase processing |

---

_This project plan document should be updated as the project evolves. Keep it current to reflect the actual project status._
