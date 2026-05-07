# Deliverable 3 — Bootstrap Architecture Design

**Project:** Proj-001 — Dotfiles Ansible Migration
**Phase:** Phase 7 — Bootstrap Installer Overhaul
**Step:** 7.2 — Design the new bootstrap architecture
**Date:** 2026-05-06
**Status:** Complete

---

## Overview

This document defines the architecture for the new bootstrap installer system, informed by the analysis in [Deliverable 2](./Deliverable%202%20-%20Bootstrap%20Installer%20Analysis.md).

---

## Design Principles

1. **Minimal install scripts** — Each script only detects OS, installs prerequisites (git, python3, ansible), and runs `ansible-pull`. Everything else is Ansible.
2. **No redundant repo cloning** — Script clones once. `ansible-pull` uses `--clean` (acceptable since repo is already cloned).
3. **One playbook per system type** — `laptop.yaml`, `workstation.yaml`, `server.yaml`.
4. **Shared bootstrap foundation** — All types share `bootstrap.yaml` for environment validation.
5. **Idempotent by default** — Safe to re-run. Second run produces no changes.
6. **Non-interactive by default** — Interactive prompts (GPG, gopass) deferred to post-install.
7. **Graceful error handling** — Failures don't cascade. Clear error messages.

---

## Architecture Overview

```
Install Script (install-laptop.sh / install-workstation.sh / install-server.sh)
│
├── 1. Parse arguments (--help, --dry-run, --branch)
├── 2. Detect OS
├── 3. Install prerequisites (git, python3, ansible)
├── 4. Clone/update dotfiles repo
├── 5. ansible-pull bootstrap.yaml  (Phase 1 — shared)
└── 6. ansible-pull <system-type>.yaml  (Phase 2 — specific)

Phase 1: bootstrap.yaml (shared — already implemented)
├── Environment validation (Python, Ansible versions)
├── Network connectivity check (GitHub)
├── SSH config setup
├── Package manager setup (Paru on Arch, verify apt/zypper)
└── Ansible collection verification

Phase 2: System-specific playbook
├── laptop.yaml: dotfiles, desktop env, dev tools, media, fonts, scripts, cluster, AI
├── workstation.yaml: dotfiles, dev tools, scripts, cluster, fonts
└── server.yaml: dotfiles (minimal), SSH config, firewall, k8s tools, NTP, log rotation
```

---

## System Type Profiles

### Laptop
- **Script:** `install-laptop.sh` | **Playbook:** `laptop.yaml`
- **Target:** Primary dev machine with full Hyprland/Wayland desktop
- **Key roles:** dotfiles, desktop env, dev tools, media apps, fonts, scripts, cluster, AI
- **Desktop:** ✅ | **GPU:** ✅ (NVIDIA or integrated) | **Audio:** ✅ (pipewire)

### Workstation
- **Script:** `install-workstation.sh` | **Playbook:** `workstation.yaml`
- **Target:** Secondary dev machine, no desktop environment
- **Key roles:** dotfiles, dev tools, scripts, cluster, fonts
- **Desktop:** ❌ | **GPU:** ❌ | **Audio:** ❌

### Server
- **Script:** `install-server.sh` | **Playbook:** `server.yaml`
- **Target:** Headless server (Kubernetes node, NAS, etc.)
- **Key roles:** dotfiles (minimal), SSH config, firewall, k8s tools, NTP, log rotation
- **Desktop:** ❌ | **GPU:** ❌ | **Audio:** ❌ | **Firewall:** ✅

---

## Install Script Design

### Shared Structure

All three scripts share the same structure. Differences are limited to: playbook name, tags filter, script name/help text.

### Script Flow

```
1. Parse arguments (--help, --dry-run, --branch, --non-interactive)
2. Detect OS (shared detect_os() function)
3. Run OS-specific prerequisite installation
4. Clone or update the dotfiles repository
5. Run ansible-pull with bootstrap.yaml
6. Run ansible-pull with <system-type>.yaml
7. Print completion message
```

### Arguments

| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| `--help` | Flag | — | Show usage information |
| `--dry-run` | Flag | — | Show what would be done without making changes |
| `--branch` | String | `main` | Git branch to use for the dotfiles repo |
| `--non-interactive` | Flag | — | Skip interactive prompts (for CI/automation) |

### OS Detection

Preserve the existing `detect_os()` function — it works correctly:

```bash
detect_os() {
  if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [[ $ID == opensuse* ]]; then echo "opensuse"
    else echo "$ID"; fi
  else
    echo $(uname -s | tr '[:upper:]' '[:lower:]')
  fi
}
```

### OS Dispatch (FIXED)

The critical bug from the current script is fixed — each OS case now calls its setup function:

```bash
case $dotfiles_os in
    debian)  debian_setup  ;;
    arch)    arch_setup    ;;
    ubuntu)  ubuntu_setup  ;;
    opensuse) opensuse_setup ;;
    *) echo "Unsupported OS: $dotfiles_os"; exit 1 ;;
esac
```

### OS-Specific Prerequisite Installation

Each OS setup function installs only: **git**, **python3**, **ansible**, and **openssh**. No GPG, no gopass, no locale setup — those are handled by Ansible roles.

**Arch Linux (`arch_setup`):**
```bash
pacman -Sy --noconfirm
pacman -S --noconfirm git python3 python-pip python-argcomplete ansible openssh
```

**Debian/Ubuntu (`debian_setup` / `ubuntu_setup`):**
```bash
apt-get update
apt-get install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible  # Ubuntu only
apt-get update
apt-get install -y ansible git python3 python3-pip python3-argcomplete openssh
```

**openSUSE (`opensuse_setup`):**
```bash
zypper --non-interactive refresh
zypper --non-interactive install git python3 python3-pip python3-argcomplete ansible openssh
```

### Repository Clone/Update

```bash
if ! [[ -d "$DOTFILES_DIR" ]]; then
    git clone --quiet $REPO_URL $DOTFILES_DIR
else
    git -C $DOTFILES_DIR pull --quiet
fi
```

Same as current implementation — works correctly. The `--branch` argument overrides the default `main`.

### ansible-pull Execution

```bash
# Phase 1: Bootstrap (shared)
ansible-pull \
    -U "$REPO_URL" -C "$BRANCH" \
    -i 127.0.0.1, --limit=all --clean \
    ansible/playbooks/bootstrap.yaml && \

# Phase 2: System-specific (only if bootstrap succeeded)
ansible-pull \
    -U "$REPO_URL" -C "$BRANCH" \
    -i 127.0.0.1, --limit=all --clean \
    ansible/playbooks/$SYSTEM_PLAYBOOK
```

Key design decisions:
- **`--clean` flag**: Removes cloned repo after each run. Acceptable because repo was already cloned manually in step 4.
- **Conditional Phase 2**: Uses `&&` so Phase 2 only runs if Phase 1 succeeds.
- **`$SYSTEM_PLAYBOOK`**: Set by each install script — `laptop.yaml`, `workstation.yaml`, or `server.yaml`.

---

## Playbook Architecture

### bootstrap.yaml (Shared — Phase 1)

**Status:** ✅ Already implemented (175 lines). No changes needed.

The existing `bootstrap.yaml` already handles: OS detection display, Python/Ansible version validation, git availability check, GitHub connectivity check, SSH config setup, Ansible collection verification, and package manager setup (Paru on Arch, apt/zypper verification).

### laptop.yaml (Phase 2 — Laptop)

**Status:** ❌ Empty file — needs to be implemented.

Proposed structure:
```yaml
---
- name: Provision Laptop
  hosts: localhost
  connection: local
  become: false
  gather_facts: true

  roles:
    - role: dotfiles
      tags: [dotfiles, stow]
    - role: system/fonts
      tags: [fonts]
    - role: desktop
      tags: [desktop]
    - role: dev
      tags: [dev]
    - role: cluster
      tags: [cluster]
    - role: ai
      tags: [ai]
```

### workstation.yaml (Phase 2 — Workstation)

**Status:** ❌ Empty file — needs to be implemented.

Proposed structure:
```yaml
---
- name: Provision Workstation
  hosts: localhost
  connection: local
  become: false
  gather_facts: true

  roles:
    - role: dotfiles
      tags: [dotfiles, stow]
    - role: system/fonts
      tags: [fonts]
    - role: dev
      tags: [dev]
    - role: cluster
      tags: [cluster]
```

### server.yaml (Phase 2 — Server)

**Status:** ❌ Empty file — needs to be implemented.

Proposed structure:
```yaml
---
- name: Provision Server
  hosts: localhost
  connection: local
  become: false
  gather_facts: true

  roles:
    - role: dotfiles
      tags: [dotfiles, stow]
    - role: system/networking
      tags: [networking, firewall]
    - role: cluster
      tags: [cluster]
```

---

## Error Handling Strategy

### Install Script Level

1. **`set -e`** — Exit on first error (already in current script, preserved).
2. **`_cmd()` function** — Captures stderr to log file, displays on failure, exits. Preserved from current script.
3. **Conditional Phase 2** — Phase 2 (`ansible-pull <system-type>.yaml`) only runs if Phase 1 (`bootstrap.yaml`) succeeds, using `&&` chaining.
4. **Log file preserved on failure** — Current behavior removes the log file on error. Changed to keep it for debugging: `echo "Log saved to: $DOTFILES_LOG"` on failure.

### Ansible Playbook Level

1. **`assert` module** — Used in `bootstrap.yaml` for version checks and availability assertions.
2. **`ignore_errors: true`** — Used sparingly for non-critical checks (e.g., GitHub connectivity is a warning, not a blocker).
3. **`failed_when: false`** — Used for informational checks that shouldn't fail the playbook.
4. **`changed_when: false`** — Used for read-only checks (e.g., `git --version`, `ansible --version`).

---

## Idempotency Strategy

### Install Script Level

- Package installation checks: `command -v <binary>` before installing (already in current script).
- Repository clone/update: `[[ -d "$DOTFILES_DIR" ]]` check before cloning.
- `ansible-pull` is inherently idempotent — Ansible tasks declare desired state.

### Ansible Playbook Level

- All roles should use Ansible modules that are idempotent by default (e.g., `package`, `file`, `copy`, `template`).
- The `dotfiles` role uses `stow --restow` which is idempotent — re-running updates existing symlinks.
- The `package_management` role checks `which paru` before building from AUR.
- The `system/fonts` role checks for system font packages before copying files.

---

## File Layout

### Install Scripts (bootstrap/)

| File | Status | Purpose |
|------|--------|---------|
| `bootstrap/install-laptop.sh` | ⚠️ Needs rewrite | Laptop installer (full desktop) |
| `bootstrap/install-workstation.sh` | ❌ Empty | Workstation installer (no desktop) |
| `bootstrap/install-server.sh` | ❌ Empty | Server installer (minimal) |
| `bootstrap/install-desktop.sh` | ❓ Orphan | Not in plan — delete or keep? |
| `bootstrap/fix-symlinks.sh` | ✅ Working | Symlink repair utility |

### Playbooks (ansible/playbooks/)

| File | Status | Purpose |
|------|--------|---------|
| `ansible/playbooks/bootstrap.yaml` | ✅ Implemented | Phase 1 — shared environment validation |
| `ansible/playbooks/laptop.yaml` | ❌ Empty | Phase 2 — laptop configuration |
| `ansible/playbooks/workstation.yaml` | ❌ Doesn't exist | Phase 2 — workstation configuration |
| `ansible/playbooks/server.yaml` | ❌ Empty | Phase 2 — server configuration |
| `ansible/playbooks/test.yaml` | ✅ Implemented | Simple validation playbook |

---

## Implementation Order

The implementation follows the install script flow from top to bottom:

1. **Shared helper functions** — Extract `detect_os()`, `_spinner()`, `__task()`, `_cmd()`, `_task_done()` into a shared library or keep inline (inline is simpler for standalone scripts).
2. **OS setup functions** — Rewrite `arch_setup()`, `debian_setup()`, `ubuntu_setup()`, `opensuse_setup()` to install only prerequisites.
3. **OS dispatch** — Fix the `case` statement to call the correct setup function.
4. **Argument parsing** — Add `--help`, `--dry-run`, `--branch`, `--non-interactive`.
5. **Repository management** — Keep current clone/update logic, add `--branch` support.
6. **ansible-pull execution** — Two-phase flow with conditional chaining.
7. **Playbook creation** — Populate `laptop.yaml`, create `workstation.yaml`, populate `server.yaml`.
8. **Testing** — Test each script on appropriate OS.

---

## Open Questions

1. **`install-desktop.sh`** — This file exists in `bootstrap/` but is not referenced in the project plan. Should it be deleted, or does it serve a purpose (e.g., desktop-only install without laptop-specific tools)?

2. **`workstation.yaml`** — This playbook doesn't exist yet (unlike `laptop.yaml` and `server.yaml` which are empty files). Should it be created as part of Phase 7, or deferred to Phase 8?

3. **Ansible collections in install script** — The current script runs `ansible-galaxy collection install` inline. Should this remain in the install script, or should it be moved to the `bootstrap.yaml` playbook? Recommendation: move to `bootstrap.yaml` for consistency.

4. **`--dry-run` implementation** — Should `--dry-run` skip the actual `ansible-pull` commands and just print what would run? Or should it pass `--check` to `ansible-pull`? Recommendation: print what would run AND pass `--check` to `ansible-pull`.

5. **Log file management** — Current script overwrites the log file on each `_cmd()` call. Should the log be append-only with timestamps? Recommendation: append with timestamps for debugging.

---

## Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-05-06 | Initial version — complete bootstrap architecture design |

