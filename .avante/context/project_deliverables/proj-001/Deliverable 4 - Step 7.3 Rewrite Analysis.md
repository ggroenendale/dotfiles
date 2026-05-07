# Deliverable 4 — Step 7.3 Rewrite Analysis

> **Project:** Proj-001 — Dotfiles Ansible Migration
> **Phase:** Phase 7 — Bootstrap Installer Overhaul
> **Step:** 7.3 — Rewrite `install-laptop.sh`
> **Status:** Analysis Complete — Awaiting Implementation Authorization
> **Date:** 2026-05-06
> **Author:** DeepSeek (AI Agent)

## Table of Contents

- [1. Current Script Structure](#1-current-script-structure)
- [2. What Needs to Change](#2-what-needs-to-change)
- [3. Specific Changes by Section](#3-specific-changes-by-section)
  - [3.1 Variables Section (Lines 27-44)](#31-variables-section-lines-27-44)
  - [3.2 Helper Functions (Lines 46-195)](#32-helper-functions-lines-46-195)
  - [3.3 OS Setup Functions (Lines 200-440)](#33-os-setup-functions-lines-200-440)
  - [3.4 OS Dispatch (Lines 442-465)](#34-os-dispatch-lines-442-465)
  - [3.5 Post-Setup (Lines 467-506)](#35-post-setup-lines-467-506)
  - [3.6 Argument Parsing (New)](#36-argument-parsing-new)
  - [3.7 Error Handling Improvements](#37-error-handling-improvements)
- [4. Dependencies](#4-dependencies)
- [5. Risks and Considerations](#5-risks-and-considerations)
- [6. Implementation Order](#6-implementation-order)

---

## 1. Current Script Structure

The existing `bootstrap/install-laptop.sh` is 506 lines with the following sections:

| Section              | Lines   | Description                                                                        |
| -------------------- | ------- | ---------------------------------------------------------------------------------- |
| Header/comment block | 1-25    | Script metadata, license, description                                              |
| Variables            | 27-44   | Configuration variables and paths                                                  |
| Helper functions     | 46-195  | `_spinner()`, `__task()`, `_cmd()`, `_clear_task()`, `_task_done()`, `detect_os()` |
| OS detection call    | 198     | `dotfiles_os=$(detect_os)`                                                         |
| OS setup functions   | 200-440 | `arch_setup()`, `debian_setup()`, `opensuse_setup()`, `ubuntu_setup()`             |
| Main dispatch        | 442-465 | Case statement (BROKEN — only openSUSE works)                                      |
| Post-setup           | 467-506 | Ansible collections, repo clone, `ansible-pull`                                    |

---

## 2. What Needs to Change

Based on the findings from Deliverable 2 (Bootstrap Installer Analysis) and the architecture design from Deliverable 3 (Bootstrap Architecture Design), the following categories of changes are needed:

1. **Variables**: Add new ones for the two-phase flow
2. **Helper functions**: Keep as-is (all work correctly)
3. **OS setup functions**: Major rewrite — strip non-prerequisite packages, keep only what's needed to bootstrap Ansible
4. **OS dispatch**: All OS's have setup function calls
5. **Post-setup**: Moderate changes — two-phase `ansible-pull` flow
6. **Argument parsing**: New feature — `--help`, `--dry-run`, `--branch`, `--non-interactive`
7. **Error handling**: Keep log on failure, add completion message

---

## 3. Specific Changes by Section

### 3.1 Variables Section (Lines 27-44)

**Keep:**

- `DOTFILES_LOG` — used for logging
- `DOTFILES_DIR` — used for repo path
- `SPINNER_PID` — used by spinner function
- `REPO_URL` — used for git clone
- `BRANCH` — used for git checkout
- `ANSIBLE_CONFIG` export — used by ansible-pull

**Add:**

- `SYSTEM_PLAYBOOK="laptop.yaml"` — the system playbook to run in Phase 2
- `ANSIBLE_PLAYBOOKS_DIR="$DOTFILES_DIR/ansible/playbooks"` — path to playbooks

### 3.2 Helper Functions (Lines 46-195)

**Keep all as-is:**

- `_spinner()` — animated spinner for long-running tasks
- `__task()` — task header display
- `_cmd()` — command execution with logging
- `_clear_task()` — clear task line
- `_task_done()` — mark task complete
- `detect_os()` — OS detection (works correctly)

No changes needed to this section.

### 3.3 OS Setup Functions (Lines 200-440)

Each OS setup function needs to be stripped down to only install the prerequisites needed to bootstrap Ansible:

- `git` — to clone the dotfiles repository
- `python3` — required by Ansible
- `python3-pip` / `python-pip` — for pip-based Ansible installs
- `python-argcomplete` — for Ansible tab completion
- `ansible` — the configuration management tool
- `openssh` — for SSH key management and `ansible-pull` from GitHub

**`arch_setup()` changes:**

- Keep: `pacman -Sy`, `git`, `python3`, `python-pip`, `python-argcomplete`, `ansible`, `openssh`

**`debian_setup()` changes:**

- Keep: `apt update`, `python3`, `python3-pip`, `python3-argcomplete`, `ansible`
- Add: `git`, `openssh-server`
- Remove: version-gated pip install,

**`ubuntu_setup()` changes:**

- Same as `debian_setup()` — these are functionally identical

**`opensuse_setup()` changes:**

- Keep: `zypper refresh`, `git`, `python3`, `python3-pip`, `python3-argcomplete`, `ansible`, `openssh`

### 3.4 OS Dispatch (Lines 442-465)

Fixed

**Old State:**

```bash
case "$dotfiles_os" in
    debian)
        echo "debian_setup"
        # debian_setup  # COMMENTED OUT
        ;;
    arch)
        echo "arch_setup"
        # arch_setup    # COMMENTED OUT
        ;;
    ubuntu)
        echo "ubuntu_setup"
        # ubuntu_setup  # COMMENTED OUT
        ;;
    opensuse)
        opensuse_setup  # ONLY THIS ONE ACTUALLY WORKS
        ;;
    *)
        echo "Unsupported OS: $dotfiles_os"
        exit 1
        ;;
esac
```

### 3.5 Post-Setup (Lines 467-506)

**Changes:**

- Keep the repo clone/update logic (works correctly)
- Add `--branch` support to git clone (currently hardcoded to `main`)
- Change `ansible-pull` to a two-phase flow:
  1. Phase 1: `ansible-pull -U $REPO_URL -C $BRANCH bootstrap.yaml` (prerequisites)
  2. Phase 2: `ansible-pull -U $REPO_URL -C $BRANCH $SYSTEM_PLAYBOOK` (full provisioning)
- Add `--clean` flag to `ansible-pull` to ensure clean checkout each time
- Add conditional chaining — Phase 2 only runs if Phase 1 succeeds
- Remove the redundant `test.yaml` `ansible-pull` (currently runs as a test after main pull)

**Current `ansible-pull` flow (to be replaced):**

```bash
# Current (simplified):
ansible-pull -U "$REPO_URL" ansible/playbooks/test.yaml
```

**New two-phase flow:**

```bash
# Phase 1: Bootstrap prerequisites
__task "Running bootstrap playbook"
_cmd ansible-pull -U "$REPO_URL" -C "$BRANCH" --clean \
    "$ANSIBLE_PLAYBOOKS_DIR/bootstrap.yaml" || {
    _clear_task
    echo "ERROR: Bootstrap playbook failed. Check $DOTFILES_LOG"
    exit 1
}
_task_done

# Phase 2: Full system provisioning
__task "Running $SYSTEM_PLAYBOOK playbook"
_cmd ansible-pull -U "$REPO_URL" -C "$BRANCH" --clean \
    "$ANSIBLE_PLAYBOOKS_DIR/$SYSTEM_PLAYBOOK" || {
    _clear_task
    echo "ERROR: $SYSTEM_PLAYBOOK playbook failed. Check $DOTFILES_LOG"
    exit 1
}
_task_done
```

### 3.6 Argument Parsing (New)

The current script has no argument parsing. Add support for:

- `--help` — Show usage information and exit
- `--dry-run` — Show what would be done without making changes
- `--branch <name>` — Use a specific git branch (default: `main`)
- `--non-interactive` — Skip any prompts (for automated provisioning)

**Implementation approach:**

```bash
# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --help, -h              Show this help message"
            echo "  --dry-run               Show what would be done without making changes"
            echo "  --branch <name>         Use a specific git branch (default: main)"
            echo "  --non-interactive       Skip prompts (for automated provisioning)"
            exit 0
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --branch)
            BRANCH="$2"
            shift 2
            ;;
        --non-interactive)
            NON_INTERACTIVE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--help] [--dry-run] [--branch <name>] [--non-interactive]"
            exit 1
            ;;
    esac
done
```

**Integration with existing code:**

- `DRY_RUN` flag should prefix commands with `echo` when set
- `NON_INTERACTIVE` flag should pass `--noconfirm` to pacman, `-y` to apt, etc.
- `BRANCH` is already used in the script — just needs to be exposed as an argument

### 3.7 Error Handling Improvements

**Current behavior:**

- Log file is removed on success (`rm -f "$DOTFILES_LOG"`)
- No explicit error messages for most failure modes
- No completion message

**Changes:**

- Keep log file on failure for debugging (remove only on success)
- Add explicit error messages with log file path when failures occur
- Add a completion message at the end of successful runs:

```bash
echo ""
echo "============================================"
echo "  Dotfiles installation complete!"
echo "  System playbook: $SYSTEM_PLAYBOOK"
echo "  Branch: $BRANCH"
echo "  Log: $DOTFILES_LOG"
echo "============================================"
echo ""
echo "You may need to restart your shell or log out"
echo "and back in for all changes to take effect."
```

---

## 4. Dependencies

For the rewritten script to actually work end-to-end, these other files need to exist:

| File                               | Status                     | Impact                                          |
| ---------------------------------- | -------------------------- | ----------------------------------------------- |
| `ansible/playbooks/laptop.yaml`    | ⚠️ Empty skeleton          | Script will run Phase 2 but nothing will happen |
| `ansible/playbooks/bootstrap.yaml` | ✅ Implemented (175 lines) | Phase 1 will work correctly                     |

**Key dependency issue:** The script can be rewritten and tested for the bootstrap phase (Phase 1), but the full end-to-end test won't work until `laptop.yaml` is populated. This is acceptable for Step 7.3 — the script rewrite is the deliverable. The playbook population is part of the implementation order (see Section 6).

---

## 5. Risks and Considerations

| #   | Risk                                    | Impact                                        | Mitigation                                                            |
| --- | --------------------------------------- | --------------------------------------------- | --------------------------------------------------------------------- |
| 1   | **`laptop.yaml` is empty**              | Phase 2 will run but do nothing               | Acceptable for Step 7.3 — script rewrite is the deliverable           |
| 2   | **Can't test on non-Arch systems**      | Only openSUSE has been tested historically    | After the OS dispatch fix, all four OS paths need testing on real VMs |
| 3   | **Spinner UI complexity**               | ~150 lines of boilerplate for UI              | Works well — keep as-is, don't simplify                               |
| 4   | **`--dry-run` with package managers**   | Dry run may still install packages            | Document limitation — true dry-run requires VM testing                |
| 5   | **`ansible-pull --clean` deletes repo** | Clean checkout each time, loses local changes | Acceptable for bootstrap — repo is read-only source of truth          |

---

## 6. Implementation Order

When implementation is authorized, the rewrite should proceed in this order:

| Step | Description                                 | Details                                                    |
| ---- | ------------------------------------------- | ---------------------------------------------------------- |
| 1    | **Add argument parsing**                    | Insert `while [[ $# -gt 0 ]]` loop after variables section |
| 2    | **Rewrite `debian_setup()`**                | Add git/openssh, remove version-gated logic                |
| 3    | **Rewrite `ubuntu_setup()`**                | Same as debian                                             |
| 4    | **Update repo clone for `--branch`**        | Pass `$BRANCH` to git clone/checkout                       |
| 5    | **Update `ansible-pull` to two-phase flow** | Phase 1: bootstrap.yaml, Phase 2: $SYSTEM_PLAYBOOK         |
| 6    | **Add completion message**                  | Print summary at end of successful run                     |
