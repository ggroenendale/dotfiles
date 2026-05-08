# Bootstrap Installers

This directory contains the bootstrap installers for provisioning a machine with the dotfiles configuration. Each script handles OS detection, prerequisite installation, repository cloning, and Ansible-driven configuration.

## Overview

The bootstrap process follows a two-phase architecture:

1. **Phase 1 — Bootstrap**: The install script detects the OS, installs prerequisites (git, Python, Ansible), clones the dotfiles repository, and runs `ansible-pull` with the `bootstrap.yaml` playbook for environment validation
2. **Phase 2 — System Configuration**: `ansible-pull` runs the system-specific playbook (e.g., `laptop.yaml`, `server.yaml`) for full configuration

## Install Scripts

| Script | System Type | Playbook | Description |
|--------|-------------|----------|-------------|
| `install-laptop.sh` | Laptop | `laptop.yaml` | Full desktop environment, development tools, media tools, fonts |
| `install-desktop.sh` | Desktop | `desktop.yaml` | Desktop configuration (placeholder) |
| `install-server.sh` | Server | `server.yaml` | Minimal server setup (placeholder) |

## Supported Operating Systems

| OS | Status | Notes |
|----|--------|-------|
| **Arch Linux** | ✅ Supported | Primary development platform. Installs Paru AUR helper via Ansible. |
| **Debian** | ✅ Supported | Tested on Debian 12+. Uses apt for package management. |
| **Ubuntu** | ✅ Supported | Tested on Ubuntu 22.04+. Uses apt with Ansible PPA. |
| **openSUSE** | ✅ Supported | Tested on openSUSE Tumbleweed. Uses zypper for package management. |

## Usage

### Quick Start (Fresh System)

```bash
# Clone the repository
git clone https://github.com/ggroenendale/dotfiles.git ~/.dotfiles

# Run the laptop installer
cd ~/.dotfiles
./bootstrap/install-laptop.sh
```

### With Options

```bash
# Dry run — show what would be done without making changes
./bootstrap/install-laptop.sh --dry-run

# Use a specific branch
./bootstrap/install-laptop.sh --branch develop

# Non-interactive mode (for automated provisioning)
./bootstrap/install-laptop.sh --non-interactive

# Show help
./bootstrap/install-laptop.sh --help
```

### Server Installation

```bash
./bootstrap/install-server.sh
```

### Desktop Installation

```bash
./bootstrap/install-desktop.sh
```

## What Each Script Does

### 1. OS Detection

The script reads `/etc/os-release` to determine the operating system. It normalizes openSUSE variants (Tumbleweed, Leap) to `opensuse`.

### 2. Prerequisite Installation

Each OS has a dedicated setup function:

| OS | Function | Packages Installed |
|----|----------|-------------------|
| **Arch Linux** | `arch_setup()` | git, python3, python-pip, python-argcomplete, ansible, openssh, gopass, python-passlib, python-kubernetes, python-docker, python-jmespath |
| **Debian** | `debian_setup()` | git, python3, python3-argcomplete, ansible (from PPA), openssh-server |
| **Ubuntu** | `ubuntu_setup()` | git, python3, python3-argcomplete, ansible (from PPA), openssh-server |
| **openSUSE** | `opensuse_setup()` | git, python3, python3-pip, python3-argcomplete, ansible, openssh, python3-passlib, python3-kubernetes, python3-docker, python3-jmespath |

### 3. Ansible Collection Installation

Installs required Ansible collections:
```bash
ansible-galaxy collection install community.general ansible.posix kubernetes.core
```

### 4. Repository Clone/Update

- If `~/.dotfiles` doesn't exist: clones the repository from GitHub
- If `~/.dotfiles` already exists: pulls the latest changes

### 5. Phase 1 — Bootstrap Playbook

Runs `ansible-pull` with the `bootstrap.yaml` playbook:
- Validates Python, Ansible, and git versions
- Checks network connectivity to GitHub
- Sets up `~/.ssh/` directory and SSH config
- Installs Paru AUR helper (Arch Linux only)
- Verifies package manager availability

### 6. Phase 2 — System Playbook

Runs `ansible-pull` with the system-specific playbook (e.g., `laptop.yaml`):
- Applies system roles (bootloader)
- Applies hardware roles (bluetooth, graphics)
- Applies core roles (users, security)
- Applies desktop roles (login manager, clipboard)
- Applies dev roles (build tools)

## Logging

Each install run creates a timestamped log file:

```
~/.dotfiles/logs/install-laptop-2026-05-07T12-00-00.log
```

The log file captures:
- System information (kernel, OS release)
- All command output and errors
- Task completion status

## Troubleshooting

### "tput: command not found"

Install ncurses:
```bash
# Arch Linux
sudo pacman -S ncurses

# Debian/Ubuntu
sudo apt install ncurses-bin

# openSUSE
sudo zypper install ncurses-utils
```

### "Unsupported OS"

The script detected an OS that isn't in the supported list. Check `/etc/os-release` and verify the `ID` field matches one of: `arch`, `debian`, `ubuntu`, or `opensuse*`.

### "ansible-pull" fails

1. Check network connectivity to GitHub
2. Verify the repository URL and branch are correct
3. Check that Ansible collections are installed
4. Run with `--dry-run` to preview changes

### Broken symlinks after installation

Run the symlink fixer:
```bash
./bootstrap/fix-symlinks.sh
```

## Notes

- The install scripts are designed to be idempotent — running them multiple times is safe and will not duplicate configuration
- The `--dry-run` flag shows what would be done without making any changes
- For server installations, the `install-server.sh` script skips all desktop environment, audio, and display-related packages
- The `install-desktop.sh` and `install-server.sh` scripts are simplified versions of `install-laptop.sh` with different playbook targets

