# Ansible Project Structure

This directory contains the Ansible-driven configuration management system for the dotfiles repository. It provides automated provisioning for laptops, desktops, workstations, and servers across multiple Linux distributions.

## Overview

The Ansible project follows a modular role-based architecture. Playbooks define the high-level configuration for each system type, while roles encapsulate reusable configuration logic. The system is designed to be invoked via `ansible-pull` from the bootstrap installers, but can also be run locally for testing.

### Architecture Principles

- **Idempotency**: All playbooks and roles are designed to be safe to run multiple times — the second run should produce no changes
- **Cross-Platform**: Roles use OS detection to adapt package names and configuration paths for Arch Linux, Debian, Ubuntu, and openSUSE
- **Modularity**: Each concern (dotfiles, fonts, networking, etc.) has its own role, making the system easy to extend and maintain
- **Minimal Bootstrap**: The install scripts install only prerequisites (git, Python, Ansible); everything else is handled by Ansible

## Directory Structure

```
ansible/
├── ansible.cfg                    # Ansible configuration (roles_path, collections_path, callback plugin)
├── runner.py                      # Python API runner for Ansible playbooks (alternative to CLI)
├── callback_plugins/
│   └── log_output_normalizer.py   # Custom stdout callback with colorized output and logging
├── requirements/
│   └── common.yaml                # Required Ansible collections (community.general, ansible.posix, kubernetes.core)
├── playbooks/
│   ├── bootstrap.yaml             # Environment validation and prerequisites
│   ├── laptop.yaml                # Full laptop configuration (desktop + dev tools)
│   ├── desktop.yaml               # Desktop configuration (placeholder)
│   ├── server.yaml                # Server configuration (placeholder)
│   ├── test.yaml                  # Simple validation playbook for testing
│   ├── arch_desktop.yaml          # Legacy Arch Linux desktop playbook
│   ├── debian_router.yaml         # Legacy Debian router playbook
│   ├── debian_server.yaml         # Legacy Debian server playbook
│   ├── ubuntu_server.yaml         # Legacy Ubuntu server playbook
│   └── home_theater_pc_debian.yaml# Legacy HTPC Debian playbook
└── roles/
    ├── core/
    │   ├── package_management/    # AUR helper installation (Paru for Arch Linux)
    │   ├── security/              # Security configuration
    │   └── users/                 # User management
    ├── desktop/
    │   ├── clipboard/             # Clipboard manager configuration
    │   └── login_manager/         # Display/login manager configuration
    ├── dev/                       # Development tools (placeholder)
    ├── dotfiles/                  # GNU Stow symlink management
    ├── hardware/
    │   ├── bluetooth/             # Bluetooth configuration
    │   └── graphics/              # Graphics driver configuration
    └── system/
        ├── bootloader/            # Bootloader configuration
        ├── fonts/                 # Font installation (package-first, files-fallback)
        └── networking/            # Network configuration
```

## Playbooks

### Primary Playbooks

| Playbook | Purpose | Used By |
|----------|---------|---------|
| `bootstrap.yaml` | Validates environment (Python, Ansible, git versions), checks network connectivity to GitHub, sets up SSH config, installs AUR helper (Arch), verifies package managers | All install scripts (Phase 1) |
| `laptop.yaml` | Full system configuration: system roles, hardware roles, core roles, desktop roles, dev roles | `install-laptop.sh` |
| `desktop.yaml` | Desktop-specific configuration (placeholder) | `install-desktop.sh` |
| `server.yaml` | Server-specific configuration (placeholder) | `install-server.sh` |
| `test.yaml` | Simple validation — prints system info and confirms Ansible is working | Manual testing |

### Legacy Playbooks

These playbooks exist from a prior project structure and are preserved for reference. They may be refactored or removed in future updates:

- `arch_desktop.yaml`
- `debian_router.yaml`
- `debian_server.yaml`
- `ubuntu_server.yaml`
- `home_theater_pc_debian.yaml`

## Roles

### Core Roles

| Role | Description |
|------|-------------|
| `core/package_management` | Installs Paru AUR helper on Arch Linux. Checks if `paru` binary exists before building. Only runs on Arch systems. |
| `core/security` | Security hardening and configuration |
| `core/users` | User account management |

### Desktop Roles

| Role | Description |
|------|-------------|
| `desktop/clipboard` | Clipboard manager configuration |
| `desktop/login_manager` | Display/login manager setup |

### Dev Roles

| Role | Description |
|------|-------------|
| `dev` | Development tools (placeholder — to be implemented) |

### Dotfiles Role

| Role | Description |
|------|-------------|
| `dotfiles` | Discovers stow packages in `~/.dotfiles/stow/` and runs `stow --restow` on each. This is the core symlink management role. |

### Hardware Roles

| Role | Description |
|------|-------------|
| `hardware/bluetooth` | Bluetooth configuration |
| `hardware/graphics` | Graphics driver setup |

### System Roles

| Role | Description |
|------|-------------|
| `system/bootloader` | Bootloader configuration |
| `system/fonts` | Font installation with package-first, files-fallback strategy. On Arch, installs via pacman (`ttf-mononoki-nerd`, `ttf-sourcecodepro-nerd`, etc.). Falls back to copying font files from the role's `files/` directory on other distributions. |
| `system/networking` | Network configuration |

## Configuration

### `ansible.cfg`

The Ansible configuration file sets:

- **`roles_path`**: `~/.dotfiles/ansible/roles` — where Ansible looks for roles
- **`collections_path`**: `~/.dotfiles/ansible/.collections` — where Ansible collections are installed
- **`interpreter_python`**: `/usr/bin/python3` — explicit Python interpreter path
- **`stdout_callback`**: `log_output_normalizer` — custom callback plugin for colorized output
- **`host_key_checking`**: `False` — disables SSH host key checking (for local connections)
- **`retry_files_enabled`**: `False` — disables retry file generation

### `runner.py`

An alternative to the `ansible-pull` CLI that uses the Python API (`PlaybookExecutor`) to run playbooks. Takes a playbook filename as an argument and runs it against the localhost inventory.

Usage:
```bash
python3 ansible/runner.py bootstrap.yaml
```

### Collections

Required Ansible collections are defined in `requirements/common.yaml`:

- `community.general` — General-purpose modules
- `ansible.posix` — POSIX-specific modules (mount, selinux, etc.)
- `kubernetes.core` — Kubernetes management modules

Install with:
```bash
ansible-galaxy collection install -r ansible/requirements/common.yaml
```

## Running Playbooks

### Via `ansible-pull` (recommended for provisioning)

```bash
ansible-pull -U https://github.com/ggroenendale/dotfiles.git \
  -C main \
  -i 127.0.0.1, \
  --limit=all \
  --clean \
  ansible/playbooks/bootstrap.yaml
```

### Via `ansible-playbook` (for local testing)

```bash
cd ~/.dotfiles
ansible-playbook -i localhost, ansible/playbooks/test.yaml
```

### Via bootstrap install scripts

```bash
# Full laptop setup
./bootstrap/install-laptop.sh

# Server setup
./bootstrap/install-server.sh

# Desktop setup
./bootstrap/install-desktop.sh
```

## Adding a New Role

1. Create the role directory: `ansible/roles/<category>/<role_name>/`
2. Add a `tasks/main.yaml` file with your tasks
3. Add a `README.md` documenting the role's purpose and variables
4. Include the role in the appropriate playbook (e.g., `laptop.yaml`)
5. Add OS-specific variables in `vars/` subdirectory if needed
6. Test with `ansible-playbook --syntax-check`

## Notes

- The `stow/` directory at the repository root contains the actual dotfiles organized into stow packages. The `dotfiles` role discovers and stows these packages dynamically.
- Legacy playbooks are preserved but not actively maintained. New configurations should use the primary playbook structure.
- The `bootstrap.yaml` playbook runs as Phase 1 of the two-phase `ansible-pull` flow. The system-specific playbook (e.g., `laptop.yaml`) runs as Phase 2.

