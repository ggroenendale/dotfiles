# Deliverable 2 — Bootstrap Installer Analysis

**Project:** Proj-001 — Dotfiles Ansible Migration
**Phase:** Phase 7 — Bootstrap Installer Overhaul
**Step:** 7.1 — Analyze current bootstrap installer
**Date:** 2026-05-06
**Status:** Complete

---

## Overview

This document provides a comprehensive analysis of the existing `bootstrap/install-laptop.sh` script, documenting its current behavior, strengths, weaknesses, and specific issues that need to be addressed in the rewrite (Step 7.3).

---

## Script Overview

| Attribute | Value |
|-----------|-------|
| **File** | `bootstrap/install-laptop.sh` |
| **Lines** | 506 |
| **Language** | Bash |
| **Purpose** | Bootstrap a machine from zero to fully configured using Ansible |
| **Supported OS** | Arch Linux, Debian, Ubuntu, openSUSE |
| **Entry Point** | `curl ... \| bash` or `./install-laptop.sh` |
| **Execution Model** | 1. Detect OS → 2. Install prerequisites → 3. Run `ansible-pull` |

---

## Architecture

### Execution Flow

```
detect_os() → case $dotfiles_os → OS-specific setup function
                                    ↓
                          Install Ansible collections
                                    ↓
                          Clone/update dotfiles repo
                                    ↓
                          ansible-pull bootstrap.yaml
                                    ↓
                          ansible-pull test.yaml
```

### Helper Functions

| Function | Purpose | Status |
|----------|---------|--------|
| `_spinner()` | Animated spinner for background tasks (Braille characters) | ✅ Working |
| `__task()` | Start a new task with spinner, auto-completes previous task | ✅ Working |
| `_cmd()` | Execute command with error checking, logs to `$DOTFILES_LOG` | ✅ Working |
| `_task_done()` | Kill spinner, show checkmark, clear task | ✅ Working |
| `_clear_task()` | Reset `$TASK` variable | ✅ Working |
| `detect_os()` | Read `/etc/os-release`, normalize openSUSE variants | ✅ Working |

### OS Detection (`detect_os()`)

- Reads `/etc/os-release` and extracts the `ID` variable
- Normalizes openSUSE variants (`opensuse-tumbleweed`, `opensuse-leap`) to just `opensuse`
- Falls back to `uname -s` if `/etc/os-release` doesn't exist
- **Correctly handles:** arch, debian, ubuntu, opensuse (all variants)

---

## OS-Specific Setup Functions

### `arch_setup()` — Arch Linux

| Step | Command | Idempotent? | Notes |
|------|---------|-------------|-------|
| Update packages | `sudo pacman -Sy --noconfirm` | ❌ No | Always updates package DB |
| Install Git | `sudo pacman -S --noconfirm git` | ✅ Yes | Checks `command -v git` |
| Install Python3 | `sudo pacman -S --noconfirm python3` | ✅ Yes | Checks `command -v python3` |
| Install Pip | `sudo pacman -S --noconfirm python-pip` | ✅ Yes | Checks `command -v pip` |
| Install python-argcomplete | `sudo pacman -S --noconfirm python-argcomplete` | ✅ Yes | Checks `python3 -c "import argcomplete"` |
| Install Ansible | `sudo pacman -S --noconfirm ansible` | ✅ Yes | Checks `command -v ansible` |
| Install OpenSSH | `sudo pacman -S --noconfirm openssh` | ✅ Yes | Checks `command -v ssh` |
| Install gopass | `sudo pacman -S gopass gnupg` | ⚠️ Partial | Checks `command -v gopass` but GPG key gen is interactive |
| Install Python deps | `sudo pacman -S --noconfirm python-passlib python-kubernetes python-docker python-jmespath` | ✅ Yes | Always runs |
| Set locale | `sudo sed ... && sudo locale-gen` | ⚠️ Partial | Checks `locale -a` but sed always runs |

**Issues:**
1. `gopass init` is interactive — will hang in non-interactive mode
2. `gpg --full-generate-key` is interactive — will hang in non-interactive mode
3. GPG key check `gpg --list-secret-keys` doesn't check exit code properly (always succeeds even with no keys)
4. Locale setup uses `sed` which is fragile — better to use `localectl`
5. No check for `base-devel` group (needed for AUR builds like Paru)

### `debian_setup()` — Debian

| Step | Command | Idempotent? | Notes |
|------|---------|-------------|-------|
| Install Ansible | `apt-add-repository ppa:ansible/ansible` then `apt-get install ansible` | ⚠️ Partial | Checks `dpkg -s ansible` but PPA add is not idempotent |
| Install Python3 | `sudo apt-get install -y python3` | ✅ Yes | Checks `dpkg -s python3` |
| Install Pip (≤22 only) | `sudo apt-get install -y python3-pip` | ✅ Yes | Version-gated |
| Install Watchdog (≤22 only) | `sudo apt-get install -y python3-watchdog` | ✅ Yes | Version-gated |

**Issues:**
1. No git installation check (unlike arch/opensuse)
2. No OpenSSH installation
3. PPA-based Ansible install may not work on all Debian versions (PPA is Ubuntu-specific)
4. The `UBUNTU_MAJOR_VERSION` variable name is misleading for Debian
5. No locale setup
6. No Python argcomplete check via `import` (uses apt package instead)

### `ubuntu_setup()` — Ubuntu

| Step | Command | Idempotent? | Notes |
|------|---------|-------------|-------|
| Install Ansible | `apt-add-repository ppa:ansible/ansible` then `apt-get install ansible` | ⚠️ Partial | Checks `dpkg -s ansible` but PPA add is not idempotent |
| Install Python3 | `sudo apt-get install -y python3` | ✅ Yes | Checks `dpkg -s python3` |
| Install Pip (≤22 only) | `sudo apt-get install -y python3-pip` | ✅ Yes | Version-gated |
| Install Watchdog (≤22 only) | `sudo apt-get install -y python3-watchdog` | ✅ Yes | Version-gated |

**Issues:**
1. Identical to `debian_setup()` — code duplication
2. No git installation check
3. No OpenSSH installation
4. No locale setup
5. Version check `UBUNTU_MAJOR_VERSION -le 22` is fragile — Ubuntu 24.04+ won't get pip/watchdog even if needed

### `opensuse_setup()` — openSUSE

| Step | Command | Idempotent? | Notes |
|------|---------|-------------|-------|
| Update packages | `sudo zypper --non-interactive refresh` | ❌ No | Always refreshes |
| Install Git | `sudo zypper --non-interactive install git` | ✅ Yes | Checks `command -v git` |
| Install Python3 | `sudo zypper --non-interactive install python3` | ✅ Yes | Checks `command -v python3` |
| Install Pip | `sudo zypper --non-interactive install python3-pip` | ✅ Yes | Checks `command -v pip` |
| Install python-argcomplete | `sudo zypper --non-interactive install python3-argcomplete` | ✅ Yes | Checks `python3 -c "import argcomplete"` |
| Install Ansible | `sudo zypper --non-interactive install ansible` | ✅ Yes | Checks `command -v ansible` |
| Install OpenSSH | `sudo zypper --non-interactive install openssh` | ✅ Yes | Checks `command -v ssh` |
| Install Python deps | `sudo zypper --non-interactive install python3-passlib python3-kubernetes python3-docker python3-jmespath` | ✅ Yes | Always runs |
| Set locale | `sudo localectl set-locale ... && sudo locale-gen` | ⚠️ Partial | Checks `locale -a` |

**Issues:**
1. Python dependency package names may differ (e.g., `python3-kubernetes` vs `python3-kubernetes-client`)
2. Locale check uses `locale -a` but `localectl set-locale` may fail if locale is already set

---

## Critical Bug: Broken OS Dispatch

The `case` statement at the bottom of the script (lines ~460-475) is **broken** — only `opensuse` actually calls its setup function. The other three OS cases just echo a message and do nothing:

```bash
case $dotfiles_os in
    debian)
        echo "do debian"          # ← Just prints, doesn't call debian_setup
        ;;
    arch)
        echo "do arch"            # ← Just prints, doesn't call arch_setup
        ;;
    ubuntu)
        echo "do ubuntu"          # ← Just prints, doesn't call ubuntu_setup
        ;;
    opensuse)
        opensuse_setup            # ← Only this one actually works
        ;;
    *)
        __task "Unsupported OS"
        _cmd "echo 'Unsupported OS'"
    ;;
esac
```

**Impact:** On Arch Linux, Debian, and Ubuntu, the script will:
1. Skip all prerequisite installation (git, python3, ansible, etc.)
2. Proceed to install Ansible collections (which will fail if ansible isn't installed)
3. Clone the repo
4. Run `ansible-pull` (which will fail if ansible isn't installed)

**Root cause:** The setup functions were defined but never wired into the `case` statement. This appears to be an incomplete refactoring — the functions exist but the dispatch was never finished.

---

## Post-Setup Steps

### Ansible Collections Installation

```bash
ansible-galaxy collection install community.general ansible.posix kubernetes.core
```

- Runs unconditionally (not gated on OS setup success)
- Will fail if Ansible isn't installed (which happens on arch/debian/ubuntu due to the broken dispatch)
- No version pinning — always gets latest
- `kubernetes.core` may not be needed for all system types

### Repository Clone/Update

```bash
if ! [[ -d "$DOTFILES_DIR" ]]; then
    git clone --quiet $REPO_URL $DOTFILES_DIR
else
    git -C $DOTFILES_DIR pull --quiet
fi
```

- Clones from `https://github.com/ggroenendale/dotfiles.git` on `main` branch
- Uses `--quiet` flag (no progress output)
- Idempotent — updates existing repo if present
- **Issue:** No branch validation — if the repo is on a different branch, `pull` may fail or merge unexpectedly

### `ansible-pull` Execution

```bash
ansible-pull \
    -U "$REPO_URL" \
    -C "$BRANCH" \
    -i 127.0.0.1, \
    --limit=all \
    ansible/playbooks/bootstrap.yaml

ansible-pull \
    -U "$REPO_URL" \
    -C "$BRANCH" \
    -i 127.0.0.1, \
    --limit=all \
    ansible/playbooks/test.yaml
```

- Runs two `ansible-pull` commands sequentially
- First runs `bootstrap.yaml` (environment validation, SSH config, package manager setup)
- Then runs `test.yaml` (simple validation playbook)
- **Issue:** There's no `laptop.yaml` playbook yet — the bootstrap playbook validates the environment but doesn't configure the system
- **Issue:** `test.yaml` is a validation-only playbook — it doesn't configure anything
- **Issue:** If the first `ansible-pull` fails, the second one still runs (no error handling between them)
- **Issue:** The `ansible-pull` commands re-clone the repo each time, which is redundant since the repo was already cloned above

---

## Strengths (What Works Well)

1. **Spinner UI**: The Braille-character spinner with color-coded output is polished and user-friendly
2. **Error handling**: `_cmd()` captures stderr to a log file and displays it on failure
3. **OS detection**: Robust detection that handles openSUSE variants correctly
4. **Idempotent package checks**: Most package installations check if the binary exists first
5. **Color-coded output**: Green checkmarks for success, red X for errors
6. **Task tracking**: The `__task`/`_task_done` pattern provides clear progress indication
7. **Repository management**: Handles both fresh clone and existing repo update

---

## Weaknesses (What Needs Improvement)

1. **🔴 Broken OS dispatch**: Only openSUSE setup actually runs (see Critical Bug above)
2. **🔴 No `laptop.yaml` playbook**: `ansible-pull` runs `bootstrap.yaml` and `test.yaml`, but neither configures the full system
3. **🟡 Redundant repo clone**: The script clones the repo manually, then `ansible-pull` clones it again
4. **🟡 Interactive commands**: `gopass init` and `gpg --full-generate-key` will hang in non-interactive/CI mode
5. **🟡 Code duplication**: `debian_setup()` and `ubuntu_setup()` are nearly identical
6. **🟡 No non-interactive mode**: No `--yes` or `--non-interactive` flag support
7. **🟡 No dry-run mode**: No way to preview what the script would do
8. **🟢 Hardcoded paths**: `$HOME/.dotfiles` and `$HOME/.dotfiles_log` are hardcoded
9. **🟢 No version pinning**: Ansible collections are installed without version constraints
10. **🟢 No cleanup on failure**: The log file is removed on error, making debugging harder

---

## Recommendations for Step 7.3 (Rewrite)

### Must Fix

1. **Fix the OS dispatch**: Call the correct setup function for each OS in the `case` statement
2. **Create `laptop.yaml` playbook**: The `ansible-pull` needs a proper machine-specific playbook to run
3. **Remove redundant clone**: Either clone manually and skip `ansible-pull -U`, or let `ansible-pull` handle the clone and remove the manual clone step

### Should Fix

4. **Add `--non-interactive` flag**: Support headless/automated installation
5. **Add `--dry-run` flag**: Preview changes without applying them
6. **Merge debian/ubuntu setup**: They're nearly identical — use a shared function with OS-specific overrides
7. **Remove interactive commands from bootstrap**: Move `gopass` and GPG key setup to a post-install step or Ansible role
8. **Add error handling between `ansible-pull` calls**: Don't run the second if the first fails

### Nice to Have

9. **Add version pinning for Ansible collections**: Use `requirements.yml` instead of inline install
10. **Keep log file on failure**: Append to log instead of overwriting, keep it for debugging
11. **Add progress percentage**: Show overall progress (e.g., "Step 3 of 7")
12. **Support custom branch**: Allow `--branch` argument for testing feature branches

---

## Related Files

| File | Purpose | Status |
|------|---------|--------|
| `bootstrap/install-laptop.sh` | Main laptop installer | ⚠️ Broken (analyzed above) |
| `bootstrap/install-workstation.sh` | Workstation installer | ❌ Empty file |
| `bootstrap/install-server.sh` | Server installer | ❌ Empty file |
| `bootstrap/install-desktop.sh` | Desktop installer (not in plan) | ❌ Empty file |
| `bootstrap/fix-symlinks.sh` | Symlink repair utility | ✅ Working (153 lines) |
| `ansible/playbooks/bootstrap.yaml` | Bootstrap validation playbook | ✅ Working (175 lines) |
| `ansible/playbooks/test.yaml` | Test validation playbook | ✅ Working |
| `ansible/playbooks/laptop.yaml` | Laptop configuration playbook | ❌ Empty skeleton |
| `ansible/playbooks/workstation.yaml` | Workstation playbook | ❌ Doesn't exist |
| `ansible/playbooks/server.yaml` | Server playbook | ❌ Doesn't exist |

