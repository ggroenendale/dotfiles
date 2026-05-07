# Project Plan: Ansible Roles Overhaul and Refactor

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
  - [Key Issues Summary](#key-issues-summary)
  - [Design Principles](#design-principles)
  - [Proposed Role Hierarchy](#proposed-role-hierarchy)
  - [Naming Conventions](#naming-conventions)
- [Work Breakdown](#work-breakdown)
  - [Phase 0 — Inventory & Audit](#phase-0--inventory--audit)
  - [Phase 1 — Structure Design](#phase-1--structure-design-todo)
  - [Phase 2 — Legacy Cleanup](#phase-2--legacy-cleanup-todo)
  - [Phase 3 — Core Roles](#phase-3--core-roles-core)
  - [Phase 4 — Hardware Roles](#phase-4--hardware-roles-hardware)
  - [Phase 5 — System Roles](#phase-5--system-roles-system)
  - [Phase 6 — Desktop Roles](#phase-6--desktop-roles-desktop)
  - [Phase 7 — Dev Roles](#phase-7--dev-roles-dev)
  - [Phase 8 — Server Roles](#phase-8--server-roles-server)
  - [Phase 9 — Playbooks](#phase-9--playbooks)
  - [Phase 10 — Validation](#phase-10--validation)
- [Dependencies](#dependencies)
- [Resources](#resources)
  - [Infrastructure](#infrastructure)
  - [Development Environment](#development-environment)
  - [External Services](#external-services)
- [Validation and Testing](#validation-and-testing)
  - [Validation Strategy](#validation-strategy)
  - [Testing Checklist](#testing-checklist)
- [Risks and Issues](#risks-and-issues)
  - [Identified Risks](#identified-risks)
  - [Current Issues](#current-issues)
- [Current State Inventory](#current-state-inventory)
  - [Current Top-Level Roles (12 total)](#current-top-level-roles-12-total)
  - [Current Sub-Role Inventory (33 sub-roles)](#current-sub-role-inventory-33-sub-roles)
  - [Playbook Inventory (10 total)](#playbook-inventory-10-total)
  - [Detailed File-by-File Inventory](#detailed-file-by-file-inventory)
- [Revision History](#revision-history)

## Project Overview

**Project ID:** Proj-002
**Status:** Planning
**Start Date:** 2026-05-06
**Target Completion:** 2026-05-06
**Last Updated:** 2026-05-06

### Goals and Objectives

- **Primary Goal:** Refactor and rebuild the Ansible roles directory from the ground up, removing legacy code and building clean, modular roles
- **Key Objectives:**
  1. Audit and inventory all existing Ansible roles
  2. Remove or archive legacy OmniProvisioner dead code
  3. Build clean, modular roles with OS detection, idempotency, and proper tagging
  4. Organize roles by function with clear naming conventions
  5. Fix all broken references and empty placeholder files
  6. Create proper playbooks for each machine type (laptop, desktop, server, router, HTPC)

### Success Criteria

- All legacy OmniProvisioner roles removed or archived
- Each role has a clear, single responsibility and is properly tagged
- Playbooks reference only roles that exist and are functional
- No empty placeholder files remain
- All broken sub-role references are fixed
- Machine-type playbooks (laptop, desktop, server, router, HTPC) are complete and functional

## Project Scope

### In Scope

- Complete inventory of all existing Ansible roles and sub-roles
- Refactoring of legacy OmniProvisioner references
- Restructuring of role directory hierarchy
- Fixing all broken sub-role references
- Implementing or removing all empty placeholder files
- Creating complete playbooks for each machine type
- Adding proper OS detection and idempotency to all roles
- Adding proper tagging to all roles

### Out of Scope

- Rewriting the bootstrap playbook (already functional)
- Migrating roles to Ansible Galaxy or collections format
- Adding new functionality beyond what currently exists
- Creating CI/CD pipelines for Ansible testing
- Containerizing the Ansible control node

### Deliverables

| #   | Phase Name                  | Description                                                                    | Completed By |
| --- | --------------------------- | ------------------------------------------------------------------------------ | ------------ |
| 1   | Phase 0 — Inventory & Audit | Complete inventory of all roles, sub-roles, playbooks, and their current state | Phase 0      |
| 2   | Phase 1 — Structure Design  | Design new role hierarchy and naming conventions                               | Phase 1      |
| 3   | Phase 2 — Legacy Cleanup    | Remove OmniProvisioner references, archive dead code                           | Phase 2      |
| 4   | Phase 3 — Core Roles        | Rebuild base, users, security, systemd, dotfiles roles                         | Phase 3      |
| 5   | Phase 4 — Hardware Roles    | Rebuild bluetooth, peripherals, graphics, audio roles                          | Phase 4      |
| 6   | Phase 5 — System Roles      | Rebuild bootloader, storage, networking, fonts roles                           | Phase 5      |
| 7   | Phase 6 — Desktop Roles     | Rebuild all desktop environment roles                                          | Phase 6      |
| 8   | Phase 7 — Dev Roles         | Rebuild git, ide, build_tools, containers roles                                | Phase 7      |
| 9   | Phase 8 — Server Roles      | Rebuild cluster, ai, samba roles                                               | Phase 8      |
| 10  | Phase 9 — Playbooks         | Create/update machine-type playbooks                                           | Phase 9      |
| 11  | Phase 10 — Validation       | Test all playbooks against target machines                                     | Phase 10     |

### Key Issues Summary

1. **Broken sub-role references:**
   - `desktop/tasks/main.yaml` references `_wayland/` which does not exist
   - `dev/tasks/main.yaml` references `_version_control/gitea/` which does not exist

2. **30+ empty `main.yaml` files** — many sub-roles have empty main.yaml with actual content in separate files (e.g., `fuzzel.yaml`, `wallpaper.yaml`, `clipboard.yaml`)

3. **Legacy references:**
   - `arch_desktop.yaml` references `~/OmniProvisioner/roles/arch_desktop` (external repo)

4. **Inconsistent structure:**
   - Most sub-roles use `_` prefix (e.g., `_base_packages`, `_hyprland`)
   - Some don't (e.g., `bluez`, `fonts`, `networking`)
   - `_version_control/git` uses nested sub-role structure

5. **No clear machine-type categorization** — roles are flat, playbooks should compose them but many are empty

6. **`debian_server.yaml` is misconfigured** — targets `debian_router` host group and includes desktop/graphics roles

7. **5 of 11 playbooks are empty or stubs** — need implementation

8. **Copy-paste errors** — `storage/_lvm/tasks/main.yaml` has both volumes referencing the same device path

### Design Principles

1. **OS detection at the role level** — Each role handles its own OS detection internally, not via external orchestrators.
2. **Idempotent by design** — Every task should be safe to run multiple times.
3. **Tagged for selective execution** — Each role has meaningful tags for running subsets of the playbook.

### Proposed Role Hierarchy

```
ansible/roles/
├── core/                          # Foundation roles (every machine)
│   ├── base_packages/             # Essential system packages
│   ├── users/                     # User accounts and groups
│   ├── security/                  # SSH hardening, fail2ban, firewall
│   ├── systemd/                   # Systemd service management
│   ├── dotfiles/                  # Dotfiles deployment via stow
│   └── package_management/        # AUR helper (paru) installation
│
├── hardware/                      # Hardware-specific roles
│   ├── bluetooth/                 # Bluetooth stack
│   ├── peripherals/               # Input devices (solaar, etc.)
│   ├── graphics/                  # GPU drivers (nvidia)
│   └── audio/                     # PipeWire/WirePlumber
│
├── system/                        # System-level configuration
│   ├── bootloader/                # GRUB bootloader
│   ├── storage/                   # BTRFS, LVM, btrbk
│   ├── networking/                # NetworkManager, firewall, DHCP, DNS
│   └── fonts/                     # Font installation (multi-OS)
│
├── desktop/                       # Desktop environment roles
│   ├── hyprland/                  # Hyprland compositor
│   ├── wayland/                   # Wayland infrastructure (if needed)
│   ├── widgets/                   # EWW widgets
│   ├── login_manager/             # GDM/SDDM display manager
│   ├── notifications/             # Mako notification daemon
│   ├── clipboard/                 # Cliphist clipboard manager
│   ├── wallpaper/                 # swww wallpaper manager
│   ├── run_menu/                  # Fuzzel application launcher
│   ├── terminals/                 # WezTerm terminal emulator
│   ├── task_bar/                  # Waybar status bar
│   ├── authentication/            # Polkit authentication agent
│   ├── theme/                     # GTK colorscheme and theming
│   └── file_managers/             # Thunar file manager
|
├── desktop_applications/          # Desktop environment roles
│   ├── blender/                   # Blender 3d modeling
│   ├── brave/                     # Brave Browser
│   ├── firefox/                   # Firefox Browser
│   └── gimp/                      # Gimp Image Editing
│
├── dev/                           # Development tool roles
│   ├── build_tools/               # make, cmake, gcc, base-devel
│   ├── ide/                       # Neovim, lazygit
│   ├── version_control/           # Git configuration
│   └── containers/                # Docker, Podman, Docker Compose
│
├── server/                        # Server-specific roles
│   ├── network_storage/           # Samba client and server
│   ├── cluster/                   # Kubernetes (k3s/kubeadm)
│   │   ├── master/                # Control plane setup
│   │   ├── worker/                # Worker node setup
│   │   ├── client/                # kubectl, kubeadm, kubelet
│   │   ├── helm/                  # Helm package manager
│   │   └── containers/            # libvirt/KVM, container hosts
│   └── ai/                        # AI/LLM infrastructure
│       ├── inference_engine/      # Model serving
│       ├── models/                # Model management
│       └── mcp_server/            # MCP server deployment
│
└── archive/                       # Deprecated/archived roles (moved here)
    └── _refined/                  # Refind bootloader (not used)
```

### Naming Conventions

| Convention         | Rule                                                       | Example                                 |
| ------------------ | ---------------------------------------------------------- | --------------------------------------- |
| **Role names**     | Lowercase with underscores                                 | `base_packages`, `login_manager`        |
| **Sub-role names** | No underscore prefix (flat)                                | `cluster/master`, `cluster/worker`      |
| **Task files**     | `tasks/main.yaml` for entry point, OS-specific in `tasks/` | `tasks/arch.yaml`, `tasks/debian.yaml`  |
| **Variable files** | `vars/` directory with OS-specific files                   | `vars/Archlinux.yml`, `vars/Debian.yml` |
| **Handler files**  | `handlers/main.yaml`                                       | Standard Ansible convention             |
| **Template files** | `templates/` directory                                     | `templates/grub.j2`                     |
| **Static files**   | `files/` directory                                         | `files/cyberexs-theme/`                 |

---

## Work Breakdown

### Phase 0 — Inventory & Audit

#### Phase 0 Status

| Item                     | Status                         |
| ------------------------ | ------------------------------ |
| **Phase Complete**       | ❌ No                          |
| **Completed By**         | -                              |
| **Completion Date**      | -                              |
| **Deliverable Location** | -                              |
| **Next Phase**           | [Phase 1 - Structure Design]() |

**Goal:** Create a complete inventory of all roles, playbooks, tasks, handlers, and configurations in the repository, documenting their purpose, dependencies, and stow package location.

> **Note:** The files from `.config/` and `.local/` have already been moved into `stow/` subdirectories. The inventory should be created by analyzing the current `stow/` directory structure rather than the original locations — the stow packages are the authoritative source.

#### Phase 0 Deliverables

| #   | Deliverable            | Description | Location                                                                     |
| --- | ---------------------- | ----------- | ---------------------------------------------------------------------------- |
| 1   | **Complete Inventory** |             | `.avante/context/project_deliverables/proj-002/Deliverable 1 - Inventory.md` |

#### 0.1 — Inventory all top-level roles

- Create a list of current roles within ansible/roles/
- For each role note any handlers and additional files
- Don't record any file content just note the names and paths
- Some top level roles contain sub roles, these are covered in step 0.2. Leave a section for sub roles to be filled

#### 0.2 — Inventory all sub-roles

- Some roles contain sub roles, add these into the top level roles
- Note additional files and handlers within sub roles
- If a top level does not contain sub roles, fill out that top levels sub role section as "No Sub Roles to Note."

#### 0.3 — Inventory all playbooks

- Record all available playbooks and what roles they run.
- Note blank playbooks.
- The test.yaml playbook is a special playbook used to validate install scripts and using correct file paths.
- The bootstrap.yaml playbook is used by every install script to make sure the base requirements are always covered.

#### 0.4 — Document broken references

- Find missing references in playbooks and note them

#### 0.5 — Document empty files

- Document all empty files within role directories

#### 0.6 — Document legeacy references

- Note references to OmniProvisioner which was the legacy project
- Anything that references OmniProvisioner needs to be refactored into this project

#### 0.7 — Inventory all role README.md files

- Inventory all available README.md files
- Note any role that does not have a README.md file
- Note any README.md file that is empty

### Phase 1 — Structure Design (Todo)

#### Phase 1 Status

| Item                     | Status                       |
| ------------------------ | ---------------------------- |
| **Phase Complete**       | ❌ No                        |
| **Completed By**         | -                            |
| **Completion Date**      | -                            |
| **Deliverable Location** | -                            |
| **Next Phase**           | [Phase 2 - Legacy Cleanup]() |

**Goal:** Design the new role directory hierarchy and create empty scaffolding for all roles. Define naming conventions, tagging conventions, and update configuration files to support the new structure.

#### Phase 1 Deliverables

| #   | Deliverable          | Description                                      | Location |
| --- | -------------------- | ------------------------------------------------ | -------- |
| 1   | **Structure Design** | Design new role hierarchy and naming conventions | —        |

#### 1.1 — Create new role directory hierarchy

- Create the new directory structure under `ansible/roles/` with categories: `core/`, `hardware/`, `system/`, `desktop/`, `dev/`, `server/`, `archive/`
- Each category directory should contain subdirectories for each role as defined in the [Proposed Role Hierarchy](#proposed-role-hierarchy)
- Do not copy any role content yet — this phase is about creating the empty directory structure only

#### 1.2 — Create empty role scaffolding

- For each new role, create the standard Ansible role scaffolding:
  - `tasks/main.yaml` — empty entry point (will be populated in later phases)
  - `handlers/main.yaml` — empty handlers file
  - `vars/` directory — for OS-specific variable files
  - `templates/` directory — for Jinja2 templates
  - `files/` directory — for static files
- This ensures all roles have a consistent starting structure

#### 1.3 — Define tagging convention for all roles

- Define a consistent tagging scheme for all roles
- Tags should allow selective execution of role subsets (e.g., `--tags desktop`, `--tags networking`)
- Document the convention in this plan for reference during implementation phases

#### 1.4 — Update ansible.cfg roles_path if needed

- Check if `ansible.cfg` has a `roles_path` setting that needs updating
- If the new directory structure requires a path change, update it now
- Verify the configuration is valid with `ansible-playbook --syntax-check`

### Phase 2 — Legacy Cleanup (Todo)

#### Phase 2 Status

| Item                     | Status                   |
| ------------------------ | ------------------------ |
| **Phase Complete**       | ❌ No                    |
| **Completed By**         | -                        |
| **Completion Date**      | -                        |
| **Deliverable Location** | -                        |
| **Next Phase**           | [Phase 3 - Core Roles]() |

**Goal:** Remove all broken references, legacy OmniProvisioner references, and empty placeholder files from the existing role structure. Archive deprecated roles that are no longer needed.

#### Phase 2 Deliverables

| #   | Deliverable        | Description                                          | Location |
| --- | ------------------ | ---------------------------------------------------- | -------- |
| 1   | **Legacy Cleanup** | Remove OmniProvisioner references, archive dead code | —        |

#### 2.1 — Remove `_wayland` reference from `desktop/tasks/main.yaml`

- The `desktop/tasks/main.yaml` file references a `_wayland` sub-role that does not exist
- Remove the include statement for `_wayland` from the file
- If Wayland infrastructure is needed, it will be handled by the `desktop/hyprland/` role in the new structure

#### 2.2 — Remove `_version_control/gitea` reference from `dev/tasks/main.yaml`

- The `dev/tasks/main.yaml` file references a `_version_control/gitea` sub-role that does not exist
- Remove the include statement for `gitea` from the file
- Gitea can be added as a future enhancement if needed

#### 2.3 — Remove OmniProvisioner reference from `arch_desktop.yaml`

- The `arch_desktop.yaml` playbook references `~/OmniProvisioner/roles/arch_desktop` — an external repository that no longer exists
- Remove this role reference from the playbook
- All functionality from the old OmniProvisioner project has been migrated into this repository

#### 2.4 — Move `_refined/` to `archive/` directory

- The `bootloader/_refined/` sub-role contains only a README with no actual tasks
- Move this directory to `ansible/roles/archive/_refined/` to keep it available for reference but out of the active role path
- Update any references to the old location

#### 2.5 — Remove empty placeholder files (30+ empty main.yaml files)

- Many sub-roles have empty `main.yaml` files with actual content in separate files (e.g., `fuzzel.yaml`, `wallpaper.yaml`, `clipboard.yaml`)
- Remove the empty `main.yaml` files where they serve no purpose
- For roles that have no content at all (e.g., `ai/` sub-roles), either implement or remove them
- Document which files were removed for reference

### Phase 3 — Core Roles (core/)

#### Phase 3 Status

| Item                     | Status         |
| ------------------------ | -------------- |
| **Phase Complete**       | ❌ No          |
| **Completed By**         | -              |
| **Completion Date**      | -              |
| **Deliverable Location** | -              |
| **Next Phase**           | [Phase 4 - ]() |

#### Phase 3 Deliverables

| #   | Deliverable    | Description                                            | Location |
| --- | -------------- | ------------------------------------------------------ | -------- |
| 1   | **Core Roles** | Rebuild base, users, security, systemd, dotfiles roles | —        |

#### 3.1 Create `core/base_packages/`

— consolidate from `common/_base_packages/`

#### 3.2 Create `core/users/`

— consolidate from `common/_users/`

#### 3.3 Create `core/security/`

— consolidate from `common/_security/`

#### 3.4 Create `core/systemd/`

— implement from `common/_systemd/` skeleton

#### 3.5 Create `core/dotfiles/`

— move from `dotfiles/`

#### 3.6 Create `core/package_management/`

— move from `package_management/`

#### 3.7 Add proper OS detection to all core roles

#### 3.8 Add proper tagging to all core roles

### Phase 4 — Hardware Roles (hardware/)

#### Phase 4 Status

| Item                     | Status         |
| ------------------------ | -------------- |
| **Phase Complete**       | ❌ No          |
| **Completed By**         | -              |
| **Completion Date**      | -              |
| **Deliverable Location** | -              |
| **Next Phase**           | [Phase 5 - ]() |

#### Phase 4 Deliverables

| #   | Deliverable        | Description                                           | Location |
| --- | ------------------ | ----------------------------------------------------- | -------- |
| 1   | **Hardware Roles** | Rebuild bluetooth, peripherals, graphics, audio roles | —        |

#### 4.1 — Create `hardware/bluetooth/`

— consolidate from `bluetooth/`

#### 4.2 — Create `hardware/peripherals/`

— consolidate from `common/_peripherals/`

#### 4.3 — Create `hardware/graphics/`

— consolidate from `graphics/`

#### 4.4 — Create `hardware/audio/`

— consolidate from `desktop/_audio/`

#### 4.5 — Add proper OS detection and tagging to all hardware roles

### Phase 5 — System Roles (system/)

#### Phase 5 Status

| Item                     | Status         |
| ------------------------ | -------------- |
| **Phase Complete**       | ❌ No          |
| **Completed By**         | -              |
| **Completion Date**      | -              |
| **Deliverable Location** | -              |
| **Next Phase**           | [Phase 6 - ]() |

#### Phase 5 Deliverables

| #   | Deliverable      | Description                                          | Location |
| --- | ---------------- | ---------------------------------------------------- | -------- |
| 1   | **System Roles** | Rebuild bootloader, storage, networking, fonts roles | —        |

#### 5.1 — Create `system/bootloader/`

— consolidate from `bootloader/`

#### 5.2 — Create `system/storage/`

— consolidate from `storage/`

#### 5.3 — Create `system/networking/`

— consolidate from `system/networking/`

#### 5.4 — Create `system/fonts/`

— move from `system/fonts/`

#### 5.5 — Add proper OS detection and tagging to all system roles

### Phase 6 — Desktop Roles (desktop/)

#### Phase 6 Status

| Item                     | Status         |
| ------------------------ | -------------- |
| **Phase Complete**       | ❌ No          |
| **Completed By**         | -              |
| **Completion Date**      | -              |
| **Deliverable Location** | -              |
| **Next Phase**           | [Phase 7 - ]() |

#### Phase 6 Deliverables

| #   | Deliverable       | Description                           | Location |
| --- | ----------------- | ------------------------------------- | -------- |
| 1   | **Desktop Roles** | Rebuild all desktop environment roles | —        |

#### 6.1 — Create `desktop/hyprland/`

— consolidate from `desktop/_hyprland/`

#### 6.2 — Create `desktop/widgets/`

— consolidate from `desktop/_widgets/`

#### 6.3 — Create `desktop/login_manager/`

— consolidate from `desktop/_login_manager/`

#### 6.4 — Create `desktop/notifications/`

— consolidate from `desktop/_notifications/`

#### 6.5 — Create `desktop/clipboard/`

— consolidate from `desktop/_clipboard/`

#### 6.6 — Create `desktop/wallpaper/`

— consolidate from `desktop/_wallpaper/`

#### 6.7 — Create `desktop/run_menu/`

— consolidate from `desktop/_run_menu/`

#### 6.8 — Create `desktop/terminals/`

— consolidate from `desktop/_terminals/`

#### 6.9 — Create `desktop/task_bar/`

— consolidate from `desktop/_task_bar/`

#### 6.10 — Create `desktop/authentication/`

— consolidate from `desktop/_authentication/`

#### 6.11 — Create `desktop/theme/`

— consolidate from `desktop/_theme/`

#### 6.12 — Create `desktop/browser/`

— consolidate from `desktop/_browser/`

#### 6.13 — Create `desktop/file_managers/`

— consolidate from `desktop/_file_managers/`

#### 6.14 — Create `desktop/apps/`

— consolidate from `desktop/_apps/`

#### 6.15 — Fix all empty main.yaml files

— implement or remove

#### 6.16 — Add proper OS detection and tagging to all desktop roles

### Phase 7 — Dev Roles (dev/)

#### Phase 7 Status

| Item                     | Status         |
| ------------------------ | -------------- |
| **Phase Complete**       | ❌ No          |
| **Completed By**         | -              |
| **Completion Date**      | -              |
| **Deliverable Location** | -              |
| **Next Phase**           | [Phase 8 - ]() |

#### Phase 7 Deliverables

| #   | Deliverable   | Description                                     | Location |
| --- | ------------- | ----------------------------------------------- | -------- |
| 1   | **Dev Roles** | Rebuild git, ide, build_tools, containers roles | —        |

#### 7.1 — Create `dev/build_tools/`

— consolidate from `dev/_build_tools/`

#### 7.2 — Create `dev/ide/`

— consolidate from `dev/_ide/`

#### 7.3 — Create `dev/version_control/`

— consolidate from `dev/_version_control/git/`

#### 7.4 — Create `dev/containers/`

— consolidate from `dev/_containers/`

#### 7.5 — Add proper OS detection and tagging to all dev roles

### Phase 8 — Server Roles (server/)

#### Phase 8 Status

| Item                     | Status         |
| ------------------------ | -------------- |
| **Phase Complete**       | ❌ No          |
| **Completed By**         | -              |
| **Completion Date**      | -              |
| **Deliverable Location** | -              |
| **Next Phase**           | [Phase 9 - ]() |

#### Phase 8 Deliverables

| #   | Deliverable      | Description              | Location |
| --- | ---------------- | ------------------------ | -------- |
| 1   | **Server Roles** | Rebuild all server roles | —        |

#### 8.1 — Create `server/network_storage/`

— consolidate from `network_storage/`

#### 8.2 — Create `server/cluster/master/`

— implement from skeleton

#### 8.3 — Create `server/cluster/worker/`

— implement from skeleton

#### 8.4 — Create `server/cluster/client/`

— consolidate from `cluster/_client/`

#### 8.5 — Create `server/cluster/helm/`

— consolidate from `cluster/_helm/`

#### 8.6 — Create `server/cluster/containers/`

— consolidate from `cluster/_containers/`

#### 8.7 — Create `server/ai/`

— implement or remove empty sub-roles

#### 8.8 — Add proper OS detection and tagging to all server roles

### Phase 9 — Playbooks

#### Phase 9 Status

| Item                     | Status          |
| ------------------------ | --------------- |
| **Phase Complete**       | ❌ No           |
| **Completed By**         | -               |
| **Completion Date**      | -               |
| **Deliverable Location** | -               |
| **Next Phase**           | [Phase 10 - ]() |

#### Phase 9 Deliverables

| #   | Deliverable   | Description                          | Location |
| --- | ------------- | ------------------------------------ | -------- |
| 1   | **Playbooks** | Create/update machine-type playbooks | —        |

#### 9.1 — Create `laptop.yaml`

— compose core + hardware + system + desktop + dev roles

#### 9.2 — Create `desktop.yaml`

— compose core + hardware + system + desktop + dev roles

#### 9.3 — Create `server.yaml`

— compose core + system + server roles

#### 9.4 — Create `home_theater_pc_debian.yaml`

— compose core + system + hardware roles

#### 9.5 — Fix `debian_server.yaml`

— correct host group and role selection

#### 9.6 — Implement `ubuntu_server.yaml`

— compose core + system + server roles

#### 9.7 — Update `arch_desktop.yaml`

— remove OmniProvisioner reference, update role paths

#### 9.8 — Update `debian_router.yaml`

— update role paths

### Phase 10 — Validation

#### Phase 10 Status

| Item                     | Status |
| ------------------------ | ------ |
| **Phase Complete**       | ❌ No  |
| **Completed By**         | -      |
| **Completion Date**      | -      |
| **Deliverable Location** | -      |
| **Next Phase**           | N/A    |

#### Phase 10 Deliverables

| #   | Deliverable    | Description                                | Location |
| --- | -------------- | ------------------------------------------ | -------- |
| 1   | **Validation** | Test all playbooks against target machines | —        |

#### 10.1 — Run `ansible-playbook --syntax-check` on all playbooks

— validate syntax across all playbooks

#### 10.2 — Run `ansible-lint` on all roles

— lint all roles for best practices and errors

#### 10.3 — Test `laptop.yaml` against Arch laptop target

— run playbook against Arch laptop target machine

#### 10.4 — Test `desktop.yaml` against Arch desktop target

— run playbook against Arch desktop target machine

#### 10.5 — Test `server.yaml` against Debian server target

— run playbook against Debian server target machine

#### 10.6 — Test `debian_router.yaml` against router target

— run playbook against router target machine

#### 10.7 — Test `home_theater_pc_debian.yaml` against HTPC target

— run playbook against HTPC target machine

#### 10.8 — Verify all broken references are fixed

— confirm no missing role or sub-role references remain

#### 10.9 — Verify no empty placeholder files remain

— confirm all empty main.yaml files have been implemented or removed

#### 10.10 — Verify all roles have proper OS detection and tagging

— confirm each role handles OS detection internally and has meaningful tags

---

## Dependencies

| Dependency                     | Type      | Notes                                                      |
| ------------------------------ | --------- | ---------------------------------------------------------- |
| Ansible 2.9+                   | Runtime   | Required for all playbook execution                        |
| Python 3.6+                    | Runtime   | Required by Ansible                                        |
| SSH access to target machines  | Network   | Required for remote execution                              |
| Sudo access on target machines | Privilege | Required for package installation and system configuration |
| Vault password file            | Secret    | Required for encrypted variables (user passwords)          |
| Internet access                | Network   | Required for package downloads and repository cloning      |
| Arch Linux ISO or VM           | Test      | For testing Arch-specific roles                            |
| Debian/Ubuntu ISO or VM        | Test      | For testing Debian-specific roles                          |

---

## Resources

### Infrastructure

- **Control node:** Local machine (Arch Linux) — runs Ansible playbooks
- **Target machines:**
  - `node-01` (192.168.1.11) — Ubuntu 24.04 LTS (Aconcagua-Host)
  - `node-02` (192.168.1.12) — Ubuntu 22.04 LTS (geoff-workstation)
  - `gateway` (192.168.1.2) — Router OS (network gateway)
  - Arch desktop (local) — Primary development machine
  - HTPC (Debian) — Home theater PC

### Development Environment

- **Editor:** Neovim with Ansible language server
- **Linting:** `ansible-lint` for role validation
- **Syntax checking:** `ansible-playbook --syntax-check`
- **Version control:** Git (dotfiles repository)

### External Services

- **GitHub:** Dotfiles repository hosting
- **AUR:** Arch User Repository (paru packages)
- **Docker Hub / Quay:** Container images (Zot registry)

---

## Validation and Testing

### Validation Strategy

1. **Syntax validation:** `ansible-playbook --syntax-check` on all playbooks
2. **Linting:** `ansible-lint` on all roles
3. **Dry-run:** `ansible-playbook --check` for idempotency verification
4. **Full execution:** Run playbooks against target machines
5. **Verification tasks:** Each role should include verification tasks where applicable

### Testing Checklist

| Test               | Method                                  | Pass Criteria                     |
| ------------------ | --------------------------------------- | --------------------------------- |
| Syntax check       | `ansible-playbook --syntax-check`       | No errors                         |
| Lint               | `ansible-lint roles/`                   | No errors or warnings             |
| Dry-run (laptop)   | `ansible-playbook laptop.yaml --check`  | All tasks pass                    |
| Dry-run (desktop)  | `ansible-playbook desktop.yaml --check` | All tasks pass                    |
| Dry-run (server)   | `ansible-playbook server.yaml --check`  | All tasks pass                    |
| Full run (laptop)  | `ansible-playbook laptop.yaml`          | All tasks succeed                 |
| Full run (desktop) | `ansible-playbook desktop.yaml`         | All tasks succeed                 |
| Full run (server)  | `ansible-playbook server.yaml`          | All tasks succeed                 |
| Idempotency        | Run playbook twice                      | Second run has no changed tasks   |
| OS detection       | Run on Arch and Debian targets          | Correct OS-specific tasks execute |
| Tag filtering      | `ansible-playbook --tags <tag>`         | Only tagged roles execute         |

---

## Risks and Issues

### Identified Risks

| Risk                                                | Probability | Impact | Mitigation                                                                        |
| --------------------------------------------------- | ----------- | ------ | --------------------------------------------------------------------------------- |
| Breaking existing working configurations            | Medium      | High   | Keep old role directories during migration; test on non-production machines first |
| Missing Debian/Ubuntu equivalents for Arch packages | Medium      | Medium | Use fallback to file-based installation where packages don't exist                |
| Vault-encrypted variables lost during migration     | Low         | High   | Backup vault files before migration; verify decryption after migration            |
| Playbook references to old role paths break         | High        | Medium | Update all playbooks in Phase 9; run syntax check before execution                |
| Idempotency issues in new roles                     | Medium      | Medium | Use `--check` mode and run playbooks twice to verify                              |
| SSH key authentication fails on target machines     | Low         | High   | Verify SSH access before starting migration                                       |

### Current Issues

| Issue                                                                  | Status  | Resolution Plan                               |
| ---------------------------------------------------------------------- | ------- | --------------------------------------------- |
| `desktop/tasks/main.yaml` references missing `_wayland` role           | 🔴 Open | Remove reference or create role (Phase 2.1)   |
| `dev/tasks/main.yaml` references missing `_version_control/gitea` role | 🔴 Open | Remove reference or create role (Phase 2.2)   |
| `arch_desktop.yaml` references external OmniProvisioner repo           | 🔴 Open | Remove reference (Phase 2.3)                  |
| `debian_server.yaml` targets wrong host group                          | 🔴 Open | Fix host group and role selection (Phase 9.5) |
| 5 playbooks are empty or stubs                                         | 🔴 Open | Implement in Phase 9                          |
| 30+ empty main.yaml files                                              | 🔴 Open | Implement or remove in Phase 6.15             |
| Copy-paste error in `storage/_lvm/tasks/main.yaml`                     | 🔴 Open | Fix duplicate device path reference           |

---

## Current State Inventory

### Current Top-Level Roles (12 total)

| #   | Role                   | Status     | Description                                                                                                         |
| --- | ---------------------- | ---------- | ------------------------------------------------------------------------------------------------------------------- |
| 0   | **common**             | ⚠️ Partial | Meta-role: includes arch/debian OS tasks, \_base_packages, \_security, \_users, \_systemd, \_peripherals, \_dofiles |
| 1   | **desktop**            | 🔴 Broken  | Meta-role: references \_wayland (DOES NOT EXIST), has duplicate entries in main.yaml                                |
| 2   | **dev**                | 🔴 Broken  | Meta-role: references \_version_control/gitea (DOES NOT EXIST)                                                      |
| 3   | **graphics**           | 🔴 Empty   | Main tasks empty, \_nvidia sub-role empty                                                                           |
| 4   | **storage**            | ⚠️ Partial | Has \_btrfs, \_lvm sub-roles, btrbk.yaml empty                                                                      |
| 5   | **bootloader**         | ⚠️ Partial | Has \_grub (with files/templates), \_refined (README only)                                                          |
| 6   | **bluetooth**          | ⚠️ Partial | Has arch.yaml (full), verification.yaml, bluez/ (empty)                                                             |
| 7   | **network_storage**    | 🔴 Empty   | \_samba_client empty, \_samba_server has handlers/tasks, smb.conf empty                                             |
| 8   | **cluster**            | ⚠️ Partial | Has kubectl/k3s install, \_master and \_worker empty                                                                |
| 9   | **ai**                 | 🔴 Empty   | Main tasks empty, all 3 sub-roles empty                                                                             |
| 10  | **dotfiles**           | ✅ Working | Stow management — functional                                                                                        |
| 11  | **package_management** | ✅ Working | Paru AUR helper — functional                                                                                        |
| 12  | **system**             | ⚠️ Partial | fonts/ is full and well-documented, networking/ is empty                                                            |

### Current Sub-Role Inventory (33 sub-roles)

#### common/ sub-roles:

| Sub-role         | Status     | Notes                                                                                                           |
| ---------------- | ---------- | --------------------------------------------------------------------------------------------------------------- |
| `_base_packages` | ✅ Working | Full Arch tasks (132 lines), Debian tasks empty, has meta/ and verify/                                          |
| `_security`      | ⚠️ Partial | arch.yaml (78 lines, full SSH setup), ssh.yaml (Debian), verification.yaml, handlers/ working. Main tasks empty |
| `_users`         | ⚠️ Partial | arch.yaml (15 lines), debian.yaml empty, raspberry_pi.yaml empty. Has vault-encrypted vars                      |
| `_systemd`       | 🔴 Empty   | tasks/main.yaml empty, handlers/main.yaml empty                                                                 |
| `_peripherals`   | ⚠️ Partial | Installs solaar only (Arch-specific, pacman)                                                                    |
| `_dofiles`       | ✅ Working | Installs stow, clones dotfiles repo, runs stow                                                                  |

#### desktop/ sub-roles:

| Sub-role   | Status     | Notes                                                |
| ---------- | ---------- | ---------------------------------------------------- |
| `_wayland` | 🔴 MISSING | Referenced in main.yaml but directory does not exist |

#### dev/ sub-roles:

| Sub-role                 | Status     | Notes                                                                                 |
| ------------------------ | ---------- | ------------------------------------------------------------------------------------- |
| `_build_tools`           | ⚠️ Partial | Has arch.yaml (make, cmake, gcc), debian.yaml empty                                   |
| `_ide`                   | ✅ Working | Installs neovim, lazygit (14 lines)                                                   |
| `_version_control/git`   | ✅ Working | Full git config with identity, credentials, SSH, GPG (3 task files, ~120 lines total) |
| `_version_control/gitea` | 🔴 MISSING | Referenced in main.yaml but directory does not exist                                  |
| `_containers`            | ⚠️ Partial | Has docker/podman setup, docker-compose                                               |

#### graphics/ sub-roles:

| Sub-role  | Status     | Notes                                                                  |
| --------- | ---------- | ---------------------------------------------------------------------- |
| `_nvidia` | ⚠️ Partial | arch.yaml (79 lines, full NVIDIA setup), main.yaml empty, README empty |

#### storage/ sub-roles:

| Sub-role | Status     | Notes                                                         |
| -------- | ---------- | ------------------------------------------------------------- |
| `_btrfs` | 🔴 Empty   | tasks/main.yaml empty, handlers/main.yaml empty               |
| `_lvm`   | ⚠️ Partial | tasks/main.yaml (91 lines, volume management), handlers empty |

#### bootloader/ sub-roles:

| Sub-role   | Status     | Notes                                                                         |
| ---------- | ---------- | ----------------------------------------------------------------------------- |
| `_grub`    | ✅ Working | arch.yaml (71 lines), handlers (8 lines), templates/, files/ (CyberEXS theme) |
| `_refined` | 🔴 Empty   | README only, no tasks                                                         |

#### bluetooth/ sub-roles:

| Sub-role | Status   | Notes           |
| -------- | -------- | --------------- |
| `bluez`  | 🔴 Empty | main.yaml empty |

#### network_storage/ sub-roles:

| Sub-role        | Status     | Notes                                                          |
| --------------- | ---------- | -------------------------------------------------------------- |
| `_samba_client` | 🔴 Empty   | main.yaml empty                                                |
| `_samba_server` | ⚠️ Partial | tasks/main.yaml (34 lines), handlers (5 lines), smb.conf empty |

#### cluster/ sub-roles:

| Sub-role             | Status     | Notes                                                             |
| -------------------- | ---------- | ----------------------------------------------------------------- |
| `_master`            | 🔴 Empty   | main.yaml empty                                                   |
| `_worker`            | 🔴 Empty   | main.yaml empty                                                   |
| `_client`            | ✅ Working | Installs kubeadm, kubelet, kubectl, containerd, podman (14 lines) |
| `_containers/client` | ✅ Working | Installs libvirt, KVM tools on Debian/Ubuntu (20 lines)           |
| `_containers/host`   | 🔴 Empty   | main.yaml empty                                                   |
| `_helm`              | ✅ Working | Installs Helm via curl (3 lines)                                  |

#### ai/ sub-roles:

| Sub-role            | Status   | Notes           |
| ------------------- | -------- | --------------- |
| `_inference_engine` | 🔴 Empty | main.yaml empty |
| `_models`           | 🔴 Empty | main.yaml empty |
| `_mcp_server`       | 🔴 Empty | main.yaml empty |

#### system/ sub-roles:

| Sub-role     | Status     | Notes                                                                                                                  |
| ------------ | ---------- | ---------------------------------------------------------------------------------------------------------------------- |
| `fonts`      | ✅ Working | main.yaml (89 lines, multi-OS font installation)                                                                       |
| `networking` | ⚠️ Partial | Has \_networkmanager (59 lines), \_firewall (9 lines), \_dhcp (14 lines), \_dns (empty), \_wifi (empty), \_vpn (empty) |

### Playbook Inventory (10 total)

| #   | Playbook                      | Status           | Lines | Host                     | Notes                                                                 |
| --- | ----------------------------- | ---------------- | ----- | ------------------------ | --------------------------------------------------------------------- |
| 0   | `bootstrap.yaml`              | ✅ Complete      | 175   | localhost                | Environment validation, SSH setup, package manager checks             |
| 1   | `test.yaml`                   | ✅ Complete      | 30    | localhost                | Smoke test — prints system info                                       |
| 2   | `arch_desktop.yaml`           | ✅ Complete      | 24    | localhost + arch_desktop | OmniProvisioner role + 11 standard roles                              |
| 3   | `debian_router.yaml`          | ✅ Complete      | 21    | debian_router            | 11 roles (common → ai)                                                |
| 4   | `debian_server.yaml`          | ⚠️ Misconfigured | 22    | debian_router            | Same 11 roles as router (wrong host group, includes desktop/graphics) |
| 5   | `ubuntu_server.yaml`          | ❌ Stub          | 2     | —                        | Only has play name, no hosts/roles                                    |
| 6   | `desktop.yaml`                | ❌ Empty         | 0     | —                        | Nothing defined                                                       |
| 7   | `laptop.yaml`                 | ❌ Empty         | 0     | —                        | Nothing defined                                                       |
| 8   | `server.yaml`                 | ❌ Empty         | 0     | —                        | Nothing defined                                                       |
| 9   | `home_theater_pc_debian.yaml` | ❌ Empty         | 0     | —                        | Nothing defined                                                       |

### Detailed File-by-File Inventory

#### common/ Role

**Path:** `ansible/roles/common/`
**Type:** Meta-role with OS detection and 6 sub-roles
**Status:** ⚠️ Partial

##### common/tasks/main.yaml

**Status:** 🔴 Empty — Main entry point is empty. OS-specific tasks are in `arch.yaml` and `debian.yaml`.

##### common/tasks/arch.yaml (24 lines)

```yaml
- name: Update pacman cache
  pacman:
    update_cache: yes
  changed_when: false

- name: Install pip
  pacman:
    name: python-pip
    state: present

- name: Install paru
  include_role:
    name: package_management
```

**Status:** ✅ Working — Updates pacman, installs pip, delegates to package_management role.

##### common/tasks/debian.yaml (6 lines)

```yaml
- name: Update apt cache
  apt:
    update_cache: yes
  changed_when: false
```

**Status:** ⚠️ Partial — Only updates apt cache, no package installation.

##### common/\_base_packages/ Role

**Path:** `ansible/roles/common/_base_packages/`
**Status:** ⚠️ Partial

**`tasks/main.yaml`:** 🔴 Empty — Main entry point is empty. Tasks are in OS-specific files.

**`tasks/arch.yaml` (133 lines):**
Installs a comprehensive set of Arch Linux packages organized by category:

- **System tools:** base-devel, linux-headers, pacman-contrib, htop, btop, neofetch
- **Shell & terminal:** zsh, fish, alacritty, tmux, starship
- **Networking:** networkmanager, openssh, wget, curl, rsync, iperf3
- **Development:** git, python, python-pip, nodejs, npm, yarn, go, rust
- **Multimedia:** ffmpeg, imagemagick, mpv, vlc
- **Fonts:** noto-fonts, ttf-dejavu, ttf-liberation, ttf-nerd-fonts-symbols
- **Security:** fail2ban, ufw, rkhunter, chkrootkit, lynis
- **Utilities:** unzip, zip, p7zip, ripgrep, fd, fzf, bat, exa, jq, yq
- **Printing:** cups

##### common/\_security/ Role

**Path:** `ansible/roles/common/_security/`
**Status:** ⚠️ Partial

**`tasks/main.yaml`:** 🔴 Empty — Main entry point is empty. Tasks are in OS-specific files.

**`tasks/arch.yaml` (79 lines):**
Configures SSH and security on Arch Linux:

1. Installs and configures OpenSSH server
2. Hardens SSH configuration (disables root login, password auth, sets allowed users)
3. Configures SSH key-based authentication
4. Sets up fail2ban with SSH jail
5. Configures firewall rules (UFW) for SSH access

**Status:** ✅ Working — Full SSH hardening with fail2ban and firewall rules.

**`tasks/ssh.yaml` (Debian):**
**Status:** ⚠️ Partial — Debian-specific SSH configuration exists but may be incomplete.

**`handlers/main.yaml`:** ✅ Working — Restart SSH and fail2ban handlers defined.

**`verification.yaml`:** ✅ Working — SSH and security verification tasks defined.

##### common/\_users/ Role

**Path:** `ansible/roles/common/_users/`
**Status:** ⚠️ Partial

**`tasks/main.yaml`:** 🔴 Empty — Main entry point is empty. Tasks are in OS-specific files.

**`tasks/arch.yaml` (16 lines):**
Creates users on Arch Linux:

1. Creates primary user with specified groups (wheel, audio, video, etc.)
2. Sets password from vault-encrypted variable
3. Adds SSH authorized keys

**Status:** ✅ Working — User creation with vault-encrypted passwords.

**`tasks/debian.yaml`:** 🔴 Empty — No Debian-specific user tasks.

**`tasks/raspberry_pi.yaml`:** 🔴 Empty — No Raspberry Pi-specific user tasks.

**`vars/main.yaml`:** ✅ Present — Contains vault-encrypted user variables.

##### common/\_systemd/ Role

**Path:** `ansible/roles/common/_systemd/`
**Status:** 🔴 Empty

**`tasks/main.yaml`:** 🔴 Empty — No systemd service management tasks defined.

**`handlers/main.yaml`:** 🔴 Empty — No systemd handlers defined.

##### common/\_peripherals/ Role

**Path:** `ansible/roles/common/_peripherals/`
**Status:** ⚠️ Partial

**`tasks/main.yaml` (6 lines):**

```yaml
- name: Install Solaar
  pacman:
    name: solaar
    state: present
  when: ansible_os_family == "Archlinux"
```

**Status:** ⚠️ Partial — Installs solaar only (Logitech device manager). Arch-only, no Debian support.

##### common/\_dofiles/ Role

**Path:** `ansible/roles/common/_dofiles/`
**Status:** ✅ Working

**`tasks/main.yaml` (18 lines):**

1. Installs GNU Stow via pacman (Arch) or apt (Debian)
2. Clones dotfiles repository from GitHub
3. Runs `stow .` to symlink all dotfiles to home directory

**Status:** ✅ Working — Full dotfiles deployment with stow.

---

### desktop/ Role

**Path:** `ansible/roles/desktop/`
**Type:** Meta-role with desktop environment sub-roles
**Status:** 🔴 Broken

#### desktop/tasks/main.yaml

**Status:** 🔴 Broken — References `_wayland` sub-role which does not exist. Has duplicate entries.

#### desktop/\_hyprland/ Role

**Path:** `ansible/roles/desktop/_hyprland/`
**Status:** ⚠️ Partial

**`tasks/main.yaml`:** 🔴 Empty — Main entry point is empty. Tasks are in OS-specific files.

**`tasks/arch.yaml` (17 lines):**
Installs Hyprland compositor and related packages on Arch Linux:

- `hyprland`, `hyprpaper`, `hyprlock`, `hypridle`, `hyprpicker`, `waybar`, `rofi`, `dunst`, `swaync`, `swww`, `grim`, `slurp`, `wl-clipboard`

**Status:** ✅ Working — Installs Hyprland compositor and essential tools.

**`tasks/debian.yaml`:** 🔴 Empty — No Debian-specific Hyprland tasks.

**`verify/`:** 🔴 Empty — No verification tasks defined.

**`hyprland.conf`:** 🔴 Empty — No Hyprland configuration template.

#### desktop/\_wayland/ Role

**Status:** 🔴 MISSING — Referenced in `desktop/tasks/main.yaml` but directory does not exist. Needs to be created or reference removed.

#### desktop/\_widgets/ Role

**Status:** ⚠️ Partial — Has `widgets.yaml` (36 lines) for EWW (Elkowar's Wacky Widgets) built from source.

#### desktop/\_login_manager/ Role

**Status:** ⚠️ Partial — Has `login_manager.yaml` (20 lines) for GDM display manager configuration.

#### desktop/\_audio/ Role

**Status:** ⚠️ Partial — Has `arch.yaml` (9 lines) for PipeWire/WirePlumber audio setup.

#### desktop/\_notifications/ Role

**Status:** ⚠️ Partial — Has notification daemon configuration.

#### desktop/\_appearance/ Role

**Status:** ⚠️ Partial — Has theming and appearance configuration.

#### desktop/\_clipboard/ Role

**Status:** ⚠️ Partial — Has clipboard manager configuration.

#### desktop/\_wallpaper/ Role

**Status:** ⚠️ Partial — Has wallpaper configuration.

#### desktop/\_fuzzel/ Role

**Status:** ⚠️ Partial — Has fuzzel application launcher configuration.

#### desktop/\_terminal/ Role

**Status:** ⚠️ Partial — Has terminal emulator configuration.

---

### dev/ Role

**Path:** `ansible/roles/dev/`
**Type:** Meta-role with development tool sub-roles
**Status:** 🔴 Broken

#### dev/tasks/main.yaml

**Status:** 🔴 Broken — References `_version_control/gitea` which does not exist.

#### dev/\_build_tools/ Role

**Path:** `ansible/roles/dev/_build_tools/`
**Status:** ⚠️ Partial

**`tasks/main.yaml`:** 🔴 Empty — Main entry point is empty.

**`tasks/arch.yaml`:** Installs build tools: `make`, `cmake`, `gcc`, `base-devel`.

**`tasks/debian.yaml`:** 🔴 Empty — No Debian-specific build tools tasks.

#### dev/\_ide/ Role

**Path:** `ansible/roles/dev/_ide/`
**Status:** ✅ Working

**`tasks/main.yaml` (15 lines):**
Installs Neovim and lazygit:

```yaml
- name: Install Neovim
  pacman:
    name: neovim
    state: present
  when: ansible_os_family == "Archlinux"

- name: Install lazygit
  pacman:
    name: lazygit
    state: present
  when: ansible_os_family == "Archlinux"
```

**Status:** ✅ Working — Installs Neovim and lazygit on Arch Linux.

#### dev/\_version_control/git/ Role

**Path:** `ansible/roles/dev/_version_control/git/`
**Status:** ✅ Working

**Task files (4 files, ~120 lines total):**

- `tasks/arch.yaml` (31 lines) — Git package installation
- `tasks/arch_git_config.yaml` (39 lines) — Git identity and global config
- `tasks/arch_git_credentials.yaml` (33 lines) — Credential helper setup
- `tasks/arch_git_ssh.yaml` (29 lines) — SSH key generation and configuration
- `tasks/arch_gpg.yaml` (13 lines) — GPG key setup for commit signing

**Status:** ✅ Working — Comprehensive Git configuration with identity, credentials, SSH, and GPG.

#### dev/\_version_control/gitea/ Role

**Status:** 🔴 MISSING — Referenced in `dev/tasks/main.yaml` but directory does not exist.

#### dev/\_containers/ Role

**Path:** `ansible/roles/dev/_containers/`
**Status:** ⚠️ Partial

**`tasks/main.yaml`:** Has Docker and Podman installation tasks. Docker Compose setup included.

---

### graphics/ Role

**Path:** `ansible/roles/graphics/`
**Type:** Standalone role with `_nvidia` sub-role
**Status:** 🔴 Mostly Empty

#### graphics/tasks/main.yaml

**Status:** 🔴 Empty — No tasks defined.

#### graphics/handlers/main.yaml

**Status:** 🔴 Empty — No handlers defined.

#### graphics/\_nvidia/tasks/main.yaml

**Status:** 🔴 Empty — Main entry point is empty. Actual tasks are in `arch.yaml` but never called from `main.yaml`.

#### graphics/\_nvidia/tasks/arch.yaml (80 lines)

Installs/configures NVIDIA on Arch Linux:

1. NVIDIA packages: `nvidia`, `nvidia-utils`, `nvidia-settings`, `opencl-nvidia`
2. DKMS detection for custom kernels
3. NVIDIA kernel modules in `mkinitcpio.conf`
4. DRM kernel mode setting in GRUB
5. Xorg configuration for GeForce GTX 1660 Super
6. Wayland support via environment variables (`GBM_BACKEND=nvidia-drm`, `__GLX_VENDOR_LIBRARY_NAME=nvidia`)

**Status:** ✅ Working — Comprehensive NVIDIA setup with DKMS, Wayland, and Xorg support.

#### graphics/\_nvidia/README.md

**Status:** 🔴 Empty — No documentation.

---

### storage/ Role

**Path:** `ansible/roles/storage/`
**Type:** Meta-role with `_btrfs` and `_lvm` sub-roles
**Status:** ⚠️ Partial

#### storage/tasks/main.yaml (8 lines)

```yaml
- name: Configure BTRFS
  include_tasks: ../_btrfs/tasks/main.yaml
  when: ansible_os_family == "Archlinux" and enable_btrfs | default(false)

- name: Configure LVM
  include_tasks: ../_lvm/tasks/main.yaml
  when: ansible_os_family == "Debian" and enable_lvm | default(false)
```

**Status:** ✅ Working — Conditional OS detection for BTRFS (Arch) and LVM (Debian).

#### storage/tasks/btrbk.yaml

**Status:** 🔴 Empty — BTRBK backup tool configuration not yet implemented.

#### storage/handlers/main.yaml (3 lines)

```yaml
- import_tasks: ../_btrfs/handlers/main.yaml
- import_tasks: ../_lvm/handlers/main.yaml
```

**Status:** ✅ Working — Delegates to sub-role handlers.

#### storage/\_btrfs/tasks/main.yaml

**Status:** 🔴 Empty — No BTRFS tasks defined.

#### storage/\_btrfs/handlers/main.yaml

**Status:** 🔴 Empty — No BTRFS handlers defined.

#### storage/\_lvm/tasks/main.yaml (92 lines)

Manages LVM volumes on Debian:

1. Installs `lvm2`
2. Scans for volume groups
3. Activates volume groups
4. Creates/manages logical volumes (`large-vol`, `dev-vol`) on `aconcagua--lvm--primary` VG
5. Creates mount points at `/mnt/large-vol`, `/mnt/dev-vol`
6. Mounts as ext4 with `/etc/fstab` persistence

**Status:** ⚠️ Partial — Has copy-paste errors (both volumes reference same device path). No handlers.

#### storage/\_lvm/handlers/main.yaml

**Status:** 🔴 Empty — No LVM handlers defined.

---

### bootloader/ Role

**Path:** `ansible/roles/bootloader/`
**Type:** Meta-role with `_grub` and `_refined` sub-roles
**Status:** ⚠️ Partial

#### bootloader/tasks/main.yaml

**Status:** 🔴 Empty — Main entry point is empty. Tasks are in `_grub` sub-role.

#### bootloader/handlers/main.yaml (2 lines)

```yaml
- import_tasks: ../_grub/handlers/main.yaml
```

**Status:** ✅ Working — Delegates to GRUB handlers.

#### bootloader/\_grub/tasks/main.yaml

**Status:** 🔴 Empty — Main entry point is empty. Tasks are in `arch.yaml`.

#### bootloader/\_grub/tasks/arch.yaml (72 lines)

Configures GRUB bootloader on Arch Linux:

1. Generates GRUB config with `grub-mkconfig`
2. Verifies config file exists and has content
3. Creates `/etc/grub.d` directory
4. Configures GRUB defaults via Jinja2 template (`/etc/default/grub`)
5. Optionally copies CyberEXS custom GRUB theme to `/usr/share/grub/themes/`

**Status:** ✅ Working — Full GRUB setup with template and theme support.

#### bootloader/\_grub/handlers/main.yaml (8 lines)

```yaml
- name: Update GRUB Config
  command: grub-mkconfig -o /boot/grub/grub.cfg
```

**Status:** ✅ Working — Proper handler for GRUB config regeneration.

#### bootloader/\_grub/templates/ directory

**Status:** ✅ Present — Contains Jinja2 templates for GRUB configuration.

#### bootloader/\_grub/files/ directory

**Status:** ✅ Present — Contains CyberEXS GRUB theme with 80+ icon files.

#### bootloader/\_refined/README.md

**Status:** 🔴 Empty — No documentation. No tasks directory exists.

---

### bluetooth/ Role

**Path:** `ansible/roles/bluetooth/`
**Type:** Standalone role with `bluez` sub-role
**Status:** ⚠️ Partial

#### bluetooth/tasks/main.yaml

**Status:** 🔴 Empty — Main entry point is empty. Tasks are in OS-specific files.

#### bluetooth/tasks/arch.yaml (47 lines)

Configures Bluetooth on Arch Linux:

1. Installs `bluez`, `bluez-utils`, `blueman`
2. Loads `btusb` kernel module
3. Enables and starts Bluetooth systemd service
4. Adds user to `lp` group for Bluetooth permissions
5. Enables auto-power-on in `/etc/bluetooth/main.conf`
6. Optionally configures PulseAudio for A2DP high-quality audio

**Status:** ✅ Working — Full Bluetooth stack setup with permissions and auto-power-on.

#### bluetooth/tasks/verification.yaml (12 lines)

```yaml
- name: Check Bluetooth Status
  command: bluetoothctl show
  register: bt_status
  failed_when: bt_status.rc != 0

- name: List Paired Devices
  command: bluetoothctl devices
  register: bt_devices
```

**Status:** ⚠️ Partial — Verification tasks exist but are never called from `main.yaml`.

#### bluetooth/bluez/main.yaml

**Status:** 🔴 Empty — BlueZ-specific configuration not yet implemented.

---

### network_storage/ Role

**Path:** `ansible/roles/network_storage/`
**Type:** Meta-role with `_samba_client` and `_samba_server` sub-roles
**Status:** 🔴 Mostly Empty

#### network_storage/tasks/main.yaml

**Status:** 🔴 Empty — No tasks defined.

#### network_storage/\_samba_client/main.yaml

**Status:** 🔴 Empty — Samba client configuration not yet implemented.

#### network_storage/\_samba_server/tasks/main.yaml (35 lines)

Configures Samba server on Debian:

1. Installs Samba via `apt`
2. Copies custom `smb.conf` to `/etc/samba/smb.conf`
3. Creates shared directory at configurable path (`samba_share_path`)
4. Sets Samba password for configured user
5. Enables and starts `smbd` service

**Status:** ✅ Working — Full Samba server setup with share configuration.

#### network_storage/\_samba_server/handlers/main.yaml (5 lines)

```yaml
- name: Restart Samba
  systemd:
    name: smbd
    state: restarted
```

**Status:** ✅ Working — Proper restart handler.

#### network_storage/\_samba_server/main.yaml

**Status:** 🔴 Empty — No additional configuration.

#### network_storage/files/smb.conf

---

### cluster/ Role

**Path:** `ansible/roles/cluster/`
**Type:** Meta-role with Kubernetes cluster management sub-roles
**Status:** ⚠️ Partial

#### cluster/tasks/main.yaml

**Status:** ⚠️ Partial — Installs `kubectl` via apt, installs `k3s` via curl script. Apt-only, no Arch support.

#### cluster/handlers/main.yaml

**Status:** 🔴 Empty — No handlers defined.

#### cluster/\_master/main.yaml

**Status:** 🔴 Empty — Skeleton only, no tasks.

#### cluster/\_worker/main.yaml

**Status:** 🔴 Empty — Skeleton only, no tasks.

#### cluster/\_client/tasks/main.yaml

**Status:** ✅ Working — Installs kubeadm, kubelet, kubectl, containerd, podman via pacman (Arch).

#### cluster/\_helm/tasks/main.yaml

**Status:** ✅ Working — Installs Helm via curl script.

#### cluster/\_helm/tasks/zot.yaml

**Status:** 🔴 Empty — No tasks defined.

#### cluster/\_containers/client/main.yaml

**Status:** ✅ Working — Installs libvirt/KVM stack (qemu-kvm, libvirt-daemon, bridge-utils, virtinst, cloud-image-utils, qemu-guest-agent) via apt, enables libvirtd + qemu-guest-agent (Debian-only).

#### cluster/\_containers/host/main.yaml

**Status:** 🔴 Empty — No tasks defined.

#### cluster/files/zot/

**Status:** ✅ Working — Contains Helm chart for Zot OCI registry (v2.1.5) with NodePort on 5000, configurable persistence, auth, metrics.

---

### ai/ Role

**Path:** `ansible/roles/ai/`
**Type:** Standalone role with AI/LLM infrastructure sub-roles
**Status:** 🔴 Completely Empty

#### ai/tasks/main.yaml

**Status:** 🔴 Empty — No tasks defined.

#### ai/handlers/main.yaml

**Status:** 🔴 Empty — No handlers defined.

#### ai/\_inference_engine/main.yaml

**Status:** 🔴 Empty — No tasks defined.

#### ai/\_models/main.yaml

**Status:** 🔴 Empty — No tasks defined.

#### ai/\_mcp_server/main.yaml

**Status:** 🔴 Empty — No tasks defined.

**Note:** All 5 files are completely empty. The directory structure suggests a planned architecture for MCP server deployment, model management, and inference engine setup, but nothing has been implemented.

---

### dotfiles/ Role

**Path:** `ansible/roles/dotfiles/`
**Type:** Standalone role for dotfiles deployment
**Status:** ✅ Working

#### dotfiles/main.yaml

**Status:** ✅ Working — Uses `ansible.builtin.find` to discover all directories under `~/.dotfiles/stow/`, then runs `stow --restow` on each dynamically. Clean, dynamic approach that adapts to whatever stow packages exist.

---

### package_management/ Role

**Path:** `ansible/roles/package_management/`
**Type:** Standalone role for AUR helper installation
**Status:** ✅ Working

#### package_management/tasks/main.yaml (72 lines)

**Status:** ✅ Working — Installs Paru AUR helper on Arch Linux:

1. Checks if paru already exists (idempotency)
2. Installs `base-devel` + `git`
3. Clones AUR repo
4. Builds with `makepkg -si`
5. Cleans up temporary build directory
6. Verifies installation

**Note:** Only supports Arch (guarded by `ansible_distribution == "Archlinux"`). AUR is Arch-specific so this is expected.

---

### system/ Role

**Path:** `ansible/roles/system/`
**Type:** Meta-role with fonts and networking sub-roles
**Status:** ⚠️ Partial

#### system/fonts/ Role

**Path:** `ansible/roles/system/fonts/`
**Status:** ✅ Working

**`main.yaml` (90 lines):** Multi-OS font deployment:

- Tries package manager first (pacman on Arch, apt on Debian/Ubuntu, zypper on openSUSE)
- Falls back to copying font files from role's `files/` directory
- Runs `fc-cache` after installation

**`vars/` directory:** OS-specific font package lists:

- `Archlinux.yml`: `ttf-mononoki-nerd`, `ttf-sourcecodepro-nerd`, `nerd-fonts-symbols`, `ttf-nerd-fonts-symbols-mono`
- `Debian.yml`: `fonts-firacode` (nerd fonts not in Debian repos)
- `Ubuntu.yml`: `fonts-firacode` (nerd fonts not in Ubuntu repos)
- `openSUSE.yml`: `fetch-git` (nerd fonts not in openSUSE repos)
- `default.yml`: Empty font_packages list (fallback to file copy)

**`files/` directory:** Contains font files:

- `SourceCodePro/`: 24 TTF files (all weights/styles in Mono, Mono Nerd, Propo variants)
- `Mononoki/`: 12 TTF files (all weights/styles in Mono, Mono Nerd, Propo variants)
- `NerdFontsSymbolsOnly/`: 2 TTF files (Regular + Mono) + fontconfig conf

#### system/networking/ Role

**Path:** `ansible/roles/system/networking/`
**Status:** ⚠️ Partial

**`tasks/main.yaml`:** 🔴 Empty — Main entry point is empty.

**`handlers/main.yaml`:** 🔴 Empty — No handlers defined.

**`_networkmanager/tasks/arch.yaml` (60 lines):**
Installs and configures NetworkManager on Arch Linux:

1. Installs `openssh`, `nftables`, `networkmanager`, `wireless_tools`, `wget`, `curl`, `rsync`, `iperf3`, `net-tools` via pacman
2. Enables and starts NetworkManager systemd service
3. Checks Ethernet status via `nmcli`
4. Displays interface, IP, and state info
5. Has commented-out nmcli connection creation and static IP configuration

**Status:** ⚠️ Partial — Has commented-out code, no Debian support.

**`_firewall/tasks/arch.yaml` (9 lines):**
Installs `ufw` via pacman, allows SSH on port 22/tcp.

**Status:** ⚠️ Partial — Minimal firewall setup, Arch-only.

**`_dhcp/tasks/main.yaml` (14 lines):**
Installs `isc-dhcp-server` via apt (Debian).

**Status:** ⚠️ Partial — Debian-only, no Arch support.

**`_dns/tasks/main.yaml`:** 🔴 Empty — No DNS tasks defined.

**`_wifi/`:** 🔴 Empty — README only, no tasks.

**`_vpn/`:** 🔴 Empty — README only, no tasks.

---

### desktop/ Sub-Role Detailed Inventory

Beyond the `_hyprland` and missing `_wayland` sub-roles, the desktop role contains many additional sub-roles with content in separate files (not `main.yaml`):

| Sub-role                 | Content File                    | Status     | Description                                               |
| ------------------------ | ------------------------------- | ---------- | --------------------------------------------------------- |
| `_widgets/`              | `widgets.yaml` (36 lines)       | ⚠️ Partial | Installs Rust, clones EWW from GitHub, builds from source |
| `_login_manager/`        | `login_manager.yaml` (20 lines) | ⚠️ Partial | Installs GDM + gdm-settings, enables systemd service      |
| `_audio/`                | `arch.yaml` (9 lines)           | ⚠️ Partial | Installs pipewire + wireplumber via pacman                |
| `_notifications/`        | `mako.yaml`                     | ⚠️ Partial | Installs mako notification daemon via pacman              |
| `_clipboard/`            | `clipboard.yaml`                | ⚠️ Partial | Installs cliphist via pacman                              |
| `_wallpaper/`            | `wallpaper.yaml`                | ⚠️ Partial | Installs swww via paru (AUR)                              |
| `_run_menu/`             | `fuzzel.yaml`                   | ⚠️ Partial | Installs fuzzel via pacman                                |
| `_terminals/`            | `tasks/main.yaml`               | ⚠️ Partial | Installs wezterm via pacman                               |
| `_task_bar/`             | `waybar.yaml`                   | ⚠️ Partial | Installs waybar via pacman                                |
| `_authentication/`       | `tasks/arch.yaml`               | ⚠️ Partial | Installs hyprpolkitagent via pacman                       |
| `_theme/colorscheme/`    | `gtk-colorscheme.yaml`          | ⚠️ Partial | Installs nwg-look, catppuccin-gtk-theme                   |
| `_browser/`              | `tasks/librewolf.yaml`          | ⚠️ Partial | Installs firefox, librewolf, zen-browser with policies    |
| `_fonts/`                | `tasks/arch.yaml`               | ⚠️ Partial | Installs ttf-nerd-fonts-symbols, ttf-mononoki-nerd        |
| `_file_managers/thunar/` | `thunar.yaml`                   | ⚠️ Partial | Installs thunar, gvfs, sshfs, thunar plugins              |
| `_apps/gimp/`            | `arch.yaml`                     | ⚠️ Partial | Installs gimp via pacman                                  |
| `_apps/blender/`         | `main.yaml`                     | 🔴 Empty   | No tasks defined                                          |

## Revision History

| Date       | Version | Author   | Changes                                                                                                                      |
| ---------- | ------- | -------- | ---------------------------------------------------------------------------------------------------------------------------- |
| 2026-05-06 | 1.0     | AI Agent | Initial project plan created with complete inventory of all roles, sub-roles, and playbooks                                  |
| 2026-05-06 | 1.1     | AI Agent | Added Proposed New Structure, Work Breakdown, Resources, Validation & Testing, Risks & Issues, and Revision History sections |
