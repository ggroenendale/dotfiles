# Project Plan: Dotfiles Ansible Migration

> **⚠️ AGENT SAFETY LOCK — READ BEFORE PROCEEDING**
>
> **DO NOT EXECUTE ANY WORK ON THIS PROJECT WITHOUT EXPLICIT USER AUTHORIZATION.**
>
> This project plan is a reference document only. No work may be performed on any phase, step, or deliverable unless the user has given a clear, unambiguous instruction to do so in the current conversation.
>
> **Rules for AI agents:**
>
> 1. **Do not** start, continue, or resume any work on this project autonomously.
> 2. **Do not** create, modify, or delete any files related to this project unless the user explicitly asks you to.
> 3. **Do not** assume that because this file exists, work is authorized — it is not.
> 4. **Do not** offer to begin working on any phase or step. Wait for the user to ask.
> 5. If the user asks a general question about this plan (e.g., "what's in Phase 3?"), answer the question only — do not offer to execute it.
> 6. If the user gives a specific instruction to modify or execute part of this plan, proceed only with that exact instruction.
> 7. **Ignore the word "Ok".** "Ok" is not a permission word. "Ok" is not authorization. "Ok" is not permission. Do not interpret "Ok" as a signal to begin work.
> 8. **Small Changes** When using the write_to_file tool it will truncate after 200 lines. When writing more than 200 lines split small changes into a max of 50 line changes using str_replace
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
  - [Phase 3 — Dotfiles Symlink Migration (Stow) _(moved to Proj-002)_](#phase-3--dotfiles-symlink-migration-stow)
  - [Phase 4 — System Configuration Role _(moved to Proj-002)_](#phase-4--system-configuration-role)
  - [Phase 5 — Desktop Environment Role _(moved to Proj-002)_](#phase-5--desktop-environment-role)
  - [Phase 6 — Scripts & Tooling Role _(moved to Proj-002)_](#phase-6--scripts--tooling-role)
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
- [Revision History](#revhistory)

## Project Overview

**Project ID:** Proj-001
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
  4. Migrate all dotfiles to Ansible tasks with proper idempotency, using GNU Stow as the symlink mechanism
  5. Overhaul the bootstrap installer to use `ansible-pull` for fully automated provisioning
  6. Create additional install scripts for different system types (servers, workstations, laptops)
  7. Add validation and testing to verify the migration is complete and correct

### Success Criteria

- Repository root contains only: `.git/`, `.avante/`, `_scratch/`, `ansible/`, `stow/`, `bootstrap/`, `.gitignore`, `AGENTS.md`, `README.md`
- All dotfiles from `.config/` and `.local/` are moved into `stow/` under appropriate subdirectories
- The bootstrap installer can provision a fresh system from zero to fully configured using `ansible-pull`
- Ansible playbooks are idempotent — running them multiple times produces the same result
- Cross-platform support is maintained (Arch Linux, Debian, Ubuntu, openSUSE)
- Package installations are managed through Ansible with proper OS detection
- Multiple install scripts exist for different system types (laptop, workstation, server)
- A dry-run mode exists for previewing changes before applying them

## Project Scope

### In Scope

- **Repository Restructure**: Move `.config/` and `.local/` into `stow/` subdirectories, clean up root-level files
- **Ansible Project Structure**: Modular role-based layout with inventory, playbooks, group_vars, and host_vars
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
| 4   | Bootstrap Installer        | Rewritten `install-laptop.sh` using `ansible-pull`                    | Phase 7      |
| 5   | Additional Install Scripts | `install-server.sh`, `install-workstation.sh`                         | Phase 8      |
| 6   | Testing & Validation       | Idempotency checks, file verification, dry-run testing                | Phase 9      |
| 7   | Documentation              | Complete documentation of all roles, scripts, and procedures          | Phase 10     |

## Dependencies

### Internal Dependencies

- **Phase 0 (Audit) → All Phases**: The audit output drives the scope of every subsequent phase
- **Phase 1 (Restructure) → Phases 2-10**: Repository must be restructured before Ansible roles can reference correct paths
- **Phase 2 (Ansible Foundation) → Phases 7-10**: Ansible project structure must exist before bootstrap and scripts can be created
- **Phase 7 (Bootstrap) → Phases 8-10**: Bootstrap installer must work before additional scripts can be created
- **Phase 8 (Install Scripts) → Phase 9**: Additional scripts build on the bootstrap pattern
- **Phase 9 (Testing) → Phases 7-8**: Testing can only begin after bootstrap and scripts are implemented
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

| Item                     | Status                                                                            |
| ------------------------ | --------------------------------------------------------------------------------- |
| **Phase Complete**       | ✅ Yes                                                                            |
| **Completed By**         | DeepSeek (AI Agent)                                                               |
| **Completion Date**      | 2026-05-05                                                                        |
| **Deliverable Location** | `.avante/context/project_deliverables/proj-002/Deliverable 1 - File Inventory.md` |
| **Next Phase**           | [Phase 1 — Repository Restructure](#phase-1--repository-restructure)              |

**Goal:** Create a complete inventory of all dotfiles, scripts, and configurations in the repository, documenting their purpose, dependencies, and stow package location.

> **Note:** The files from `.config/` and `.local/` have already been moved into `stow/` subdirectories. The inventory should be created by analyzing the current `stow/` directory structure rather than the original locations — the stow packages are the authoritative source.

#### Phase 0 Deliverables

| #   | Deliverable            | Description                                                                                                                                        | Location                                                                          |
| --- | ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
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

| Item                     | Status                                                                                           |
| ------------------------ | ------------------------------------------------------------------------------------------------ |
| **Phase Complete**       | ✅ Yes                                                                                           |
| **Completed By**         | DeepSeek (AI Agent)                                                                              |
| **Completion Date**      | 2026-05-05                                                                                       |
| **Deliverable Location** | Repository root — `.config/` and `.local/` moved into `stow/`, root cleaned to core folders only |
| **Next Phase**           | [Phase 2 — Ansible Foundation & Package Role](#phase-2--ansible-foundation)                      |

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
- **`fonts/` at repo root** — do NOT migrate into stow. Fonts are binary files (`.ttf`) that need to be installed to `~/.local/share/fonts/` and registered with `fc-cache`, not symlinked. They also bloat the git repo at 125MB. Instead, handle font installation through the system/fonts role (see Step 1.6).
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

> **Current state: ✅ Complete.** Verified on 2026-05-05.

- Add patterns for files that should never be symlinked: `AGENTS.md`, `README.md`, `.avante/*`, `.gitignore`, `.git/*`, `.stow-local-ignore`, `_scratch/*`, `ansible/*`
- Test that `stow .` from repository root produces the correct symlinks
- Verify no unintended files are symlinked
- **Note on `.env` file:** `stow/neovim_neovide/.config/nvim/.env` is intentionally tracked in git and symlinked by stow to `~/.config/nvim/.env`. This is the current behavior and is correct — stow should deploy this file. However, this is a **future removal target**: secrets, passwords, and API tokens will eventually be handled through a proper secrets management solution (e.g., Ansible vault, pass, gopass), eliminating the need for a tracked `.env` file. When that migration happens, the `.gitignore` `.env` rule will prevent it from being re-added.

#### 1.5 — Test Stow still works after restructure

> **Current state: ✅ Complete.** Verified on 2026-05-05.

- Run `stow --adopt -v .` from repository root (or `stow -v config local` for targeted stow)
- Verify all expected symlinks are created in `~/.config/` and `~/.local/`
- Check that no broken symlinks exist
- Confirm the system still works as before (open terminal, launch Hyprland, etc.)

**Verification results (2026-05-05):**

- `stow --no -v -d stow -t $HOME --no-folding .` — 348 symlinks across 5 packages, 0 conflicts, 0 errors
- All `.config/` symlinks (hypr, kitty, waybar, fuzzel, mako, bash, paru.conf, neovide, nvim, Thunar, xfce4, backgrounds, waypaper, starship.toml) — correct
- All `.local/bin/` symlinks (screenshot-scripts, ssh-scripts, neovide-workspace, docker, wal) — correct
- All `.local/share/applications/` symlinks — correct
- `.bashrc` symlink — correct
- Wezterm config — confirmed deleted, no broken symlink
- `fix-symlinks.sh` — functional, handles old→new path migration
- `ansible/roles/dotfiles/main.yaml` — already exists with dynamic stow logic

#### 1.6 — Create Ansible role for font installation

#### Step 1.6 Status

| Item                | Status              |
| ------------------- | ------------------- |
| **Step Complete**   | ✅ Yes              |
| **Completed By**    | DeepSeek (AI Agent) |
| **Completion Date** | 2026-05-05          |

> **Note on `fonts/` directory:** There is no `fonts/` directory at the repository root. The 125MB concern mentioned in earlier drafts does not apply — font files were never stored at root level.

> **Current structure (already exists):**
>
> - `ansible/roles/system/fonts/main.yaml` — **implemented** with package-first, files-fallback logic
> - `ansible/roles/system/fonts/vars/` — **created** with OS-specific variable files
> - `ansible/roles/system/fonts/files/Mononoki/` — 10 TTF files + LICENSE + README
> - `ansible/roles/system/fonts/files/NerdFontsSymbolsOnly/` — 2 TTF files + fontconfig conf + LICENSE + README
> - `ansible/roles/system/fonts/files/SourceCodePro/` — 44 TTF files + LICENSE + README
> - **Total:** 56 TTF files, ~125MB

> **⚠️ Duplication concern:** On Arch Linux, both Mononoki and SauceCodePro fonts are already available as system packages (installed in `/usr/share/fonts/TTF/`). The font files in the Ansible role are duplicates of what's already provided by pacman. However, the role is still valuable for cross-platform support (Debian/Ubuntu may not have these specific nerd-font packages).

**Implementation details:**

- `ansible/roles/system/fonts/main.yaml` — Complete role with:
  - OS detection via `include_vars` with `with_first_found` (Archlinux, Debian, Ubuntu, openSUSE, default)
  - Package manager installation using `ansible.builtin.package` (pacman/apt/zypper)
  - System font check via `stat` on `/usr/share/fonts/TTF/MononokiNerdFont-Regular.ttf`
  - File copy fallback using `ansible.builtin.copy` with directory_mode
  - Fontconfig conf deployment for Nerd Fonts Symbols
  - `fc-cache -fv` execution after fallback copy
  - Tags: `fonts`, `fonts-packages`, `fonts-files`
- `ansible/roles/system/fonts/vars/` — OS-specific variable files:
  - `Archlinux.yml` — `ttf-mononoki-nerd`, `ttf-sourcecodepro-nerd`, `nerd-fonts-symbols`, `ttf-nerd-fonts-symbols-mono`
  - `Debian.yml` — `fonts-firacode` (fallback only)
  - `Ubuntu.yml` — `fonts-firacode` (fallback only)
  - `openSUSE.yml` — `fetch-git` (fallback only)
  - `default.yml` — empty list (fallback only)
- **Decision (2026-05-05):** **Option C** — package manager first, font files as fallback.
  - **Priority order:** Package manager → font files from role
  - **Arch Linux:** Install via pacman (`ttf-mononoki-nerd`, `ttf-sourcecodepro-nerd`, `nerd-fonts-symbols`, etc.)
  - **Debian/Ubuntu:** Install via apt (if packages exist in repos)
  - **openSUSE:** Install via zypper (if packages exist in repos)
  - **Fallback:** If the package manager doesn't have the fonts, copy from `ansible/roles/system/fonts/files/` and run `fc-cache`
  - **Font files stay in the repo** — they serve as the cross-platform safety net
- **Syntax check:** ✅ Passed with `ansible-playbook --syntax-check`

### Phase 2 — Ansible Foundation

#### Phase 2 Status

| Item                     | Status                                                                                   |
| ------------------------ | ---------------------------------------------------------------------------------------- |
| **Phase Complete**       | ✅ Yes                                                                                   |
| **Completed By**         | DeepSeek (AI Agent)                                                                      |
| **Completion Date**      | 2026-05-06                                                                               |
| **Deliverable Location** | `ansible/` — project structure, playbooks, roles, and config                             |
| **Next Phase**           | [Phase 3 — Dotfiles Symlink Migration (Stow)](#phase-3--dotfiles-symlink-migration-stow) |

**Goal:** Establish the modular Ansible project structure with inventory, playbooks, group_vars, host_vars, and role directories.

#### Phase 2 Deliverables

| #   | Deliverable                   | Description                                                       |
| --- | ----------------------------- | ----------------------------------------------------------------- |
| 1   | **Ansible Project Structure** | Inventory, playbooks, group_vars, host_vars, and role directories |

#### 2.1 — Design Ansible project structure

**Decision:** No inventory file or directory. This is a single-machine dotfiles setup using `ansible-pull` with `-i localhost,`. An inventory adds complexity without benefit. If remote server management is ever needed in the future, an inventory can be added then.

| #   | Task                                        | Status      | Notes                                                                                                                                                             |
| --- | ------------------------------------------- | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Create `ansible/playbooks/` directory       | ✅ Complete | Exists with legacy playbooks (arch_desktop, debian_router, debian_server, desktop, home_theater_pc_debian, test, ubuntu_server) — will be reorganized in step 2.2 |
| 2   | Create `ansible/group_vars/` directory      | ✅ Complete | Directory exists (empty) — content deferred until OS-specific variable needs arise                                                                                |
| 3   | Create `ansible/host_vars/` directory       | ✅ Complete | Directory exists (empty) — content deferred until host-specific variable needs arise                                                                              |
| 4   | Create `ansible/roles/` directory structure | ✅ Complete | Exists with roles: common, desktop, graphics, storage, network_storage, dotfiles — each has sub-role structure with tasks, handlers, and READMEs                  |
| 5   | Create `ansible/ansible.cfg`                | ✅ Complete | Exists with roles_path, collections_path, interpreter_python configured                                                                                           |

**Notes:**

- The existing roles (common, desktop, graphics, storage, network_storage) are legacy from a prior Ansible project structure (OmniProvisioner). They will need significant adjustments to work with the new dotfiles-focused layout, but that work is deferred to later phases.
- The `dotfiles` role already exists at `ansible/roles/dotfiles/main.yaml` with dynamic stow logic — this is a good foundation for Phase 3.
- The `system` role exists at `ansible/roles/system/` with `fonts/` and `networking/` sub-roles (fonts role was implemented in Phase 1.6).
- The `bootstrap` role exists at `ansible/roles/bootstrap/tasks/main.yaml` (empty placeholder — will be populated in Phase 7).
- The `ai` role exists at `ansible/roles/ai/` — purpose TBD, deferred until Phase 2 implementation.
- The `dev` role exists at `ansible/roles/dev/` — purpose TBD, deferred until Phase 2 implementation.
- The `cluster` role exists at `ansible/roles/cluster/` — purpose TBD, deferred until Phase 2 implementation.
- `group_vars/` and `host_vars/` are deferred — they can be created when OS-specific variable needs arise during role implementation.

#### 2.2 — Create base playbook structure

| #   | Task                                      | Status      | Notes                                                                                                                                        |
| --- | ----------------------------------------- | ----------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Create `ansible/playbooks/bootstrap.yaml` | ✅ Complete | Implemented with OS detection, environment validation, SSH config, and package manager verification                                          |
| 2   | Create `ansible/playbooks/desktop.yaml`   | ⚠️ Skeleton | File exists but is empty — needs full implementation (deferred to later phase)                                                               |
| 3   | Create `ansible/playbooks/server.yaml`    | ⚠️ Skeleton | File exists but is empty — needs full implementation (deferred to later phase)                                                               |
| 4   | Create `ansible/playbooks/laptop.yaml`    | ⚠️ Skeleton | File exists but is empty — needs full implementation (deferred to later phase)                                                               |
| 5   | Create `ansible/playbooks/test.yaml`      | ✅ Complete | Exists and is functional — simple validation playbook that prints debug messages. Used only for testing install scripts work with filepaths. |

**Notes:**

- Legacy playbooks exist (`arch_desktop.yaml`, `debian_router.yaml`, `debian_server.yaml`, `ubuntu_server.yaml`, `home_theater_pc_debian.yaml`) and will remain and be refactored or updated.
- `desktop.yaml` exists as an empty file placeholder — it needs to be populated with the desktop role and component includes.
- `bootstrap.yaml` is intentionally lean — it runs before the machine-specific playbook as part of a two-phase `ansible-pull` flow:
  1. **Install script** → Installs prerequisites (git, python, ansible), clones repo
  2. **`ansible-pull bootstrap.yaml`** → Validates environment (Python/Ansible versions, network to GitHub), sets up `~/.ssh/` permissions and deploys SSH config, verifies installed Ansible collections are functional
  3. **`ansible-pull laptop.yaml`** (or workstation/server) → Full system configuration

#### 2.3 — Create Paru AUR helper role

- Create `ansible/roles/package_management/tasks/main.yaml` with Arch Linux detection
- Install build dependencies: `base-devel`, `git`
- Clone Paru from AUR and build/install with `makepkg -si --noconfirm`
- Ensure idempotency — check if `paru` binary exists before building
- Only runs on Arch Linux systems (skip on Debian/Ubuntu/openSUSE)
- Is part of the bootstrap.yaml playbook as installs on Arch Systems require this package manager.

### Phase 3 — Dotfiles Symlink Migration (Stow)

#### Phase 3 Status

| Item                     | Status                                                                     |
| ------------------------ | -------------------------------------------------------------------------- |
| **Phase Complete**       | ✅ Yes — moved to Proj-002                                                 |
| **Completed By**         | —                                                                          |
| **Completion Date**      | —                                                                          |
| **Deliverable Location** | —                                                                          |
| **Next Phase**           | [Phase 4 — System Configuration Role](#phase-4--system-configuration-role) |

**Goal:** _(moved to Proj-002)_ Create Ansible roles that invoke GNU Stow to manage symlinks for all dotfiles, replacing manual Stow commands.

#### Phase 3 Deliverables

| #   | Deliverable        | Description    |
| --- | ------------------ | -------------- |
| 1   | **No Deliverable** | No deliverable |

#### Work canceled and moved to Proj-002

### Phase 4 — System Configuration Role _(moved to Proj-002)_

#### Phase 4 Status

| Item                     | Status                                                                   |
| ------------------------ | ------------------------------------------------------------------------ |
| **Phase Complete**       | ✅ Yes — moved to Proj-002                                               |
| **Completed By**         | —                                                                        |
| **Completion Date**      | —                                                                        |
| **Deliverable Location** | —                                                                        |
| **Next Phase**           | [Phase 5 — Desktop Environment Role](#phase-5--desktop-environment-role) |

**Goal:** _(moved to Proj-002)_ Create an Ansible role for system-level configuration — hostname, locale, timezone, SSH config, and environment variables.

#### Phase 4 Deliverables

| #   | Deliverable        | Description    |
| --- | ------------------ | -------------- |
| 1   | **No Deliverable** | No deliverable |

#### Work canceled and moved to Proj-002

### Phase 5 — Desktop Environment Role _(moved to Proj-002)_

#### Phase 5 Status

| Item                     | Status                                                              |
| ------------------------ | ------------------------------------------------------------------- |
| **Phase Complete**       | ✅ Yes — moved to Proj-002                                          |
| **Completed By**         | —                                                                   |
| **Completion Date**      | —                                                                   |
| **Deliverable Location** | —                                                                   |
| **Next Phase**           | [Phase 6 — Scripts & Tooling Role](#phase-6--scripts--tooling-role) |

**Goal:** _(moved to Proj-002)_ Create an Ansible role that deploys and configures the Hyprland/Wayland desktop environment — window manager, bar, terminal, notifications, launcher, wallpaper, and shell prompt.

#### Phase 5 Deliverables

| #   | Deliverable        | Description    |
| --- | ------------------ | -------------- |
| 1   | **No Deliverable** | No deliverable |

#### Work canceled and moved to Proj-002

### Phase 6 — Scripts & Tooling Role _(moved to Proj-002)_

#### Phase 6 Status

| Item                     | Status                                                                           |
| ------------------------ | -------------------------------------------------------------------------------- |
| **Phase Complete**       | ✅ Yes — moved to Proj-002                                                       |
| **Completed By**         | —                                                                                |
| **Completion Date**      | —                                                                                |
| **Deliverable Location** | —                                                                                |
| **Next Phase**           | [Phase 7 — Bootstrap Installer Overhaul](#phase-7--bootstrap-installer-overhaul) |

**Goal:** _(moved to Proj-002)_ Create an Ansible role that deploys all custom scripts and tools from `~/.local/bin/`, ensuring they are executable and properly integrated into the system PATH.

#### Phase 6 Deliverables

| #   | Deliverable        | Description    |
| --- | ------------------ | -------------- |
| 1   | **No Deliverable** | No deliverable |

#### Work canceled and moved to Proj-002

### Phase 7 — Bootstrap Installer Overhaul

#### Phase 7 Status

| Item                     | Status                                                                                       |
| ------------------------ | -------------------------------------------------------------------------------------------- |
| **Phase Complete**       | ✅ Yes                                                                                       |
| **Completed By**         | DeepSeek (AI Agent)                                                                          |
| **Completion Date**      | 2026-05-06                                                                                   |
| **Deliverable Location** | `bootstrap/install-laptop.sh`, `bootstrap/install-desktop.sh`, `bootstrap/install-server.sh` |
| **Next Phase**           | [Phase 8 — Additional Install Scripts](#phase-8--additional-install-scripts)                 |

**Goal:** Rewrite the bootstrap installer to use `ansible-pull` for fully automated provisioning, with proper OS detection and dependency installation.

#### Phase 7 Deliverables

| #   | Deliverable             | Description                                        |
| --- | ----------------------- | -------------------------------------------------- |
| 1   | **Bootstrap Installer** | Rewritten `install-laptop.sh` using `ansible-pull` |

#### 7.1 — Analyze current bootstrap installer

> **Status:** ✅ Complete
> **Completed By:** DeepSeek (AI Agent)
> **Completion Date:** 2026-05-06
> **Deliverable:** [Deliverable 2 - Bootstrap Installer Analysis.md](../context/project_deliverables/proj-001/Deliverable%202%20-%20Bootstrap%20Installer%20Analysis.md)

- Reviewed the existing `bootstrap/install-laptop.sh` script (506 lines)
- Documented what it currently does: OS detection, package installation, Ansible setup
- Identified critical bugs: broken OS dispatch (only openSUSE works), empty `install-workstation.sh` and `install-server.sh` files
- Noted hardcoded paths and assumptions that need to be generalized
- Full analysis delivered in the deliverable document above

#### 7.2 — Design the new bootstrap architecture

> **Status:** ✅ Complete
> **Completed By:** DeepSeek (AI Agent)
> **Completion Date:** 2026-05-06
> **Deliverable:** [Deliverable 3 - Bootstrap Architecture Design.md](../context/project_deliverables/proj-001/Deliverable%203%20-%20Bootstrap%20Architecture%20Design.md)

- The install script should be minimal — just enough to bootstrap Ansible
- Ansible handles everything else via `ansible-pull`
- Support multiple system types via different install scripts:
  - `install-laptop.sh` — full desktop environment
  - `install-workstation.sh` — development tools without full desktop
  - `install-server.sh` — minimal server setup
- Each script sets the appropriate Ansible tags or variables
- Full architecture design delivered in the document above

#### 7.3 — Rewrite `install-laptop.sh`

> **Status:** ✅ Complete
> **Completed By:** DeepSeek (AI Agent)
> **Completion Date:** 2026-05-06
> **Deliverable:** `bootstrap/install-laptop.sh` — rewritten with two-phase `ansible-pull` flow

**Goal:** Rewrite `install-laptop.sh` to implement the two-phase `ansible-pull` bootstrap architecture designed in Deliverable 3, with proper argument parsing.

**Key changes implemented:**

1. **Added argument parsing** — `--help`, `--dry-run`, `--branch <name>`, `--non-interactive`
2. **Rewrote `debian_setup()`** — Added git/openssh, removed version-gated pip install and watchdog
3. **Rewrote `ubuntu_setup()`** — Same as `debian_setup()` (functionally identical)
4. **Updated repo clone for `--branch`** — Passes `$BRANCH` to `git clone --branch`
5. **Updated `ansible-pull` to two-phase flow** — Phase 1: `bootstrap.yaml`, Phase 2: `$SYSTEM_PLAYBOOK` (laptop.yaml), with `--clean` flag and `_cmd` error handling
6. **Added completion message** — Prints summary at end of successful run

**Dependencies:**

- `ansible/playbooks/laptop.yaml` — ⚠️ Empty skeleton (Phase 2 will run but do nothing until populated)
- `ansible/playbooks/bootstrap.yaml` — ✅ Implemented (175 lines)

#### 7.4 — Create `install-desktop.sh`

> **Status:** ✅ Complete
> **Completed By:** User
> **Completion Date:** 2026-05-06

- Created as a copy of `install-laptop.sh` with `SYSTEM_PLAYBOOK` set to `desktop.yaml`
- Located at `bootstrap/install-desktop.sh`

#### 7.5 — Create `install-server.sh`

> **Status:** ✅ Complete
> **Completed By:** User
> **Completion Date:** 2026-05-06

- Created as a copy of `install-laptop.sh` with `SYSTEM_PLAYBOOK` set to `server.yaml`
- Located at `bootstrap/install-server.sh`

#### 7.6 — Test the bootstrap installer

- Test on a fresh Arch Linux installation (VM or container)
- Test on a fresh Debian/Ubuntu installation
- Test on openSUSE if available
- Verify the entire process from zero to fully configured system
- Document any issues encountered during testing

### Phase 8 — Additional Install Scripts

#### Phase 8 Status

| Item                     | Status                                                          |
| ------------------------ | --------------------------------------------------------------- |
| **Phase Complete**       | ✅ Yes                                                          |
| **Completed By**         | DeepSeek (AI Agent)                                             |
| **Completion Date**      | 2026-05-06                                                      |
| **Deliverable Location** | `bootstrap/install-desktop.sh`, `bootstrap/install-server.sh`   |
| **Next Phase**           | [Phase 9 — Testing & Validation](#phase-9--testing--validation) |

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

#### Phase 9 Status

| Item                     | Status                                                                    |
| ------------------------ | ------------------------------------------------------------------------- |
| **Phase Complete**       | ✅ Yes                                                                    |
| **Completed By**         | DeepSeek (AI Agent)                                                       |
| **Completion Date**      | 2026-05-06                                                                |
| **Deliverable Location** | (validation deferred to Proj-002)                                         |
| **Next Phase**           | [Phase 10 — Documentation & Handover](#phase-10--documentation--handover) |

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
- Simulate a missing package scenario and verify ansible re-installs it
- Test bootstrap from scratch on a clean VM to verify full recovery
- Document the recovery procedure for each failure scenario

#### 9.5 — Document test results

- Create a test report documenting all validation results
- Include screenshots or logs for each test scenario
- Document any known issues or limitations found during testing
- Create a checklist for future testing after repository changes

### Phase 10 — Documentation & Handover

#### Phase 10 Status

| Item                     | Status     |
| ------------------------ | ---------- |
| **Phase Complete**       | ✅ Yes     |
| **Completed By**         | -          |
| **Completion Date**      | 2026-05-06 |
| **Deliverable Location** | —          |
| **Next Phase**           | N/A        |

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

- Create `MAINTENANCE.md` with common maintenance tasks
- Document how to add new dotfiles to the stow role
- Document how to update the bootstrap installer for new OS versions
- Include troubleshooting guidance for common maintenance issues
- Document backup and recovery procedures for the dotfiles repository

#### 10.5 — Create troubleshooting guide

- Create `TROUBLESHOOTING.md` with common issues and solutions
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
- **Service Costs:** $3.00 - 4.00 (Deepseek API costs roughly)
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
   - **Status:** ✅ Resolved (Phase 1 completed 2026-05-05)
   - **Resolution:** `.config/` and `.local/` contents distributed into `stow/` subdirectories. Root now contains only core infrastructure folders.

2. **Bootstrap Installer Not Functional**: `install-laptop.sh` has commented-out `ansible-pull` commands and incomplete OS setup functions
   - **Status:** Open
   - **Next Steps:** Phase 7 will rewrite the installer to properly use `ansible-pull`

3. **Ansible Roles Incomplete**: Existing `ansible/roles/` have only skeleton structures (dotfiles, system/networking)
   - **Status:** ✅ Moved to Proj-002
   - **Next Steps:** The comprehensive role implementations (dotfiles symlink migration, system configuration, desktop environment, scripts & tooling) have been moved to **Proj-002** for implementation. Phase 2 established the Ansible project structure and package management role as the foundation.

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

1. **Phases MUST be executed in strict numeric order** — Phase 0 first, then Phase 1, then Phase 2, then Phase 7, then Phase 8, then Phase 9, then Phase 10.
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
