# Maintenance Guide

This document covers common maintenance tasks for the dotfiles repository. It assumes you have the repository cloned at `~/.dotfiles` and are familiar with GNU Stow and Ansible basics.

## Table of Contents

- [Adding New Dotfiles](#adding-new-dotfiles)
- [Updating the Bootstrap Installer](#updating-the-bootstrap-installer)
- [Managing Stow Packages](#managing-stow-packages)
- [Working with Ansible Roles](#working-with-ansible-roles)
- [Updating Ansible Collections](#updating-ansible-collections)
- [Managing Fonts](#managing-fonts)
- [Managing the `.avante/` Directory](#managing-the-avante-directory)
- [Managing Logs](#managing-logs)
- [Managing Secrets and the `.env` File](#managing-secrets-and-the-env-file)
- [Working with the Ansible Runner and Callback Plugins](#working-with-the-ansible-runner-and-callback-plugins)
- [Managing Legacy Playbooks](#managing-legacy-playbooks)
- [Rolling Back Changes](#rolling-back-changes)
- [Repository Cleanup](#repository-cleanup)
- [Backup and Recovery](#backup-and-recovery)
- [Cross-Platform Maintenance](#cross-platform-maintenance)

## Adding New Dotfiles

### Adding a Config File to an Existing Stow Package

1. Place the file in the correct stow package directory under `stow/`:

   ```bash
   cp ~/.bash_aliases stow/bash/.bash_aliases
   ```

2. Re-stow the package to create the symlink:

   ```bash
   cd ~/.dotfiles/stow
   stow --restow bash
   ```

3. Verify the symlink was created:

   ```bash
   ls -la ~/.bash_aliases
   # Should show: ~/.bash_aliases -> .dotfiles/stow/bash/.bash_aliases
   ```

4. Commit the changes:

   ```bash
   cd ~/.dotfiles
   git add stow/bash/.bash_aliases
   git commit -m "Add bash aliases configuration"
   ```

### Creating a New Stow Package

1. Create the package directory:

   ```bash
   mkdir -p stow/my_new_package/.config
   ```

2. Add config files to the package:

   ```bash
   cp ~/.config/my_app/config.toml stow/my_new_package/.config/my_app/config.toml
   ```

3. Stow the new package:

   ```bash
   cd ~/.dotfiles/stow
   stow my_new_package
   ```

4. The Ansible dotfiles role dynamically discovers packages, so it should work automatically.

5. Commit the changes.

### Adding a New Script to `~/.local/bin/`

Scripts in `~/.local/bin/` live in the `stow/bash/` package:

```bash
cp ~/my-new-script.sh stow/bash/.local/bin/my-new-script.sh
chmod +x stow/bash/.local/bin/my-new-script.sh
cd ~/.dotfiles/stow
stow --restow bash
```

## Updating the Bootstrap Installer

The bootstrap installers (`bootstrap/install-laptop.sh`, `install-server.sh`, `install-desktop.sh`) handle OS detection, prerequisite installation, and Ansible invocation.

### Adding Support for a New OS

1. Add a new setup function in the install script following the existing pattern:

   ```bash
   fedora_setup() {
       __task "Updating package lists"
       _cmd "sudo dnf update -y"
       if ! [ -x "$(command -v git)" ]; then
           __task "Installing Git"
           _cmd "sudo dnf install -y git"
       fi
   }
   ```

2. Add the OS to the case statement:

   ```bash
   case $dotfiles_os in
       arch)
           arch_setup
           ;;
       fedora)
           fedora_setup
           ;;
   esac
   ```

3. Update the supported OS list in `bootstrap/README.md`.

### Adding a New Package to Prerequisites

Add the package installation to the appropriate OS setup function. For example, to add `tmux` to Arch Linux:

```bash
arch_setup() {
    # ... existing code ...
    if ! [ -x "$(command -v tmux)" ]; then
        __task "Installing tmux"
        _cmd "sudo pacman -S --noconfirm tmux"
    fi
}
```

### Updating the Ansible Playbook Target

To change which playbook an install script runs:

1. Edit the `SYSTEM_PLAYBOOK` variable at the top of the script:

   ```bash
   SYSTEM_PLAYBOOK="my_new_playbook.yaml"
   ```

2. Ensure the playbook exists at `ansible/playbooks/my_new_playbook.yaml`.

## Managing Stow Packages

### Checking Symlink Status

```bash
cd ~/.dotfiles
stow --no -v -d stow -t $HOME .

cd ~/.dotfiles/stow
stow --no -v bash
```

### Restowing All Packages

```bash
cd ~/.dotfiles/stow
for pkg in */; do
    stow --restow "${pkg%/}"
done
```

### Unstowing a Package

```bash
cd ~/.dotfiles/stow
stow --delete bash
```

### Fixing Broken Symlinks

```bash
cd ~/.dotfiles/stow
stow --restow bash

# Or use the fix-symlinks script
./bootstrap/fix-symlinks.sh
```

### Updating `.stow-local-ignore`

The `.stow-local-ignore` file at the repository root defines patterns for files that should never be symlinked. Current patterns exclude:

- `AGENTS.md` — Agent operations log
- `README.md` — Repository documentation
- `.avante/.*` — AI assistant context and plans
- `.gitignore` — Git ignore rules
- `.git/.*` — Git directory
- `.stow-local-ignore` — The ignore file itself
- `_scratch/.*` — Scratch directory
- `ansible/.*` — Ansible project files
- `nvim-plugins-source` — Local plugin source reference

To add a new exclusion:

```bash
echo "my_excluded_file" >> .stow-local-ignore
```

## Working with Ansible Roles

### Adding a New Role

1. Create the role directory structure:

   ```bash
   mkdir -p ansible/roles/my_category/my_role/tasks
   mkdir -p ansible/roles/my_category/my_role/vars
   ```

2. Create the main tasks file:

   ```yaml
   # ansible/roles/my_category/my_role/tasks/main.yaml
   ---
   - name: My task
     ansible.builtin.debug:
       msg: "Hello from my_role"
   ```

3. Add OS-specific variables if needed:

   ```yaml
   # ansible/roles/my_category/my_role/vars/Archlinux.yml
   ---
   package_name: my-package-arch
   ```

4. Include the role in the appropriate playbook:

   ```yaml
   # In ansible/playbooks/laptop.yaml
   my_roles_to_apply:
     - my_category/my_role
   ```

5. Test with syntax check:

   ```bash
   ansible-playbook --syntax-check ansible/playbooks/laptop.yaml
   ```

### Testing a Role

```bash
# Run a specific role with tags
ansible-playbook -i localhost, --tags my_role ansible/playbooks/laptop.yaml

# Check mode (dry run)
ansible-playbook -i localhost, --check ansible/playbooks/laptop.yaml

# Verbose output
ansible-playbook -i localhost, -v ansible/playbooks/laptop.yaml
```

### Updating OS-Specific Variables

OS-specific variables are stored in `vars/` subdirectories within each role:

```
ansible/roles/my_role/vars/
├── Archlinux.yml
├── Debian.yml
├── Ubuntu.yml
├── openSUSE.yml
└── default.yml
```

The role loads the correct variable file using `include_vars` with `with_first_found`:

```yaml
- name: Load OS-specific variables
  ansible.builtin.include_vars:
    file: "{{ lookup('first_found', params) }}"
  vars:
    params:
      files:
        - "{{ ansible_facts.distribution }}.yml"
        - "{{ ansible_facts.os_family }}.yml"
        - default.yml
      paths:
        - "vars"
```

## Updating Ansible Collections

Required Ansible collections are defined in `ansible/requirements/common.yaml`:

```yaml
---
collections:
  - community.general
  - ansible.posix
  - kubernetes.core
```

To update:

```bash
# Install or update collections
ansible-galaxy collection install -r ansible/requirements/common.yaml --force

# List installed collections
ansible-galaxy collection list
```

## Managing Fonts

Fonts are managed through the `ansible/roles/system/fonts/` role, which uses a package-first, files-fallback strategy.

### Adding a New Font

1. Create a directory for the font in the role's files:

   ```bash
   mkdir -p ansible/roles/system/fonts/files/MyNewFont
   ```

2. Add the TTF files and a LICENSE file:

   ```bash
   cp ~/Downloads/MyNewFont/*.ttf ansible/roles/system/fonts/files/MyNewFont/
   cp ~/Downloads/MyNewFont/LICENSE ansible/roles/system/fonts/files/MyNewFont/
   ```

3. If the font is available as a system package on Arch Linux, add it to the package list:

   ```yaml
   # ansible/roles/system/fonts/vars/Archlinux.yml
   ---
   font_packages:
     - ttf-mononoki-nerd
     - ttf-sourcecodepro-nerd
     - nerd-fonts-symbols
     - ttf-mynewfont-nerd
   ```

4. Test the role:

   ```bash
   ansible-playbook -i localhost, --tags fonts ansible/playbooks/laptop.yaml
   ```

### Updating Font Files

To update existing font files (e.g., a new version of a nerd font):

1. Replace the TTF files in the role's `files/` directory
2. Update the LICENSE file if the license changed
3. Re-run the fonts role to deploy the updated files

### Font File Size Considerations

Font files are large (56 TTF files, ~125MB total). Keep this in mind when cloning the repository:

- Initial clone will be larger due to font files
- Use `--depth 1` for shallow clones if fonts aren't needed immediately
- Consider whether a font needs to be in the repository at all — if it's available as a system package, prefer that

## Managing the `.avante/` Directory

The `.avante/` directory contains AI-assisted development context, plans, and rules used by avante.nvim.

### Directory Structure

```
.avante/
├── context/           # Project context and information
│   ├── INDEX.md      # Central index of project information
│   └── ARCHITECTURE.md # Detailed system architecture documentation
├── plans/            # Project plans and task management
│   ├── Proj-001-dotfiles-ansible-migration.md
│   └── Proj-002-ansible-roles-overhaul.md
└── rules/            # Project-specific rules for avante.nvim
     ├── dotfiles.avanterules
     └── stow-management.avanterules
```

### Updating Context

- **`INDEX.md`**: Update when adding new components, changing architecture, or modifying key configurations. Keep the `last_edited` date in the frontmatter current.
- **`ARCHITECTURE.md`**: Update when making significant architectural changes (new roles, new tools, restructuring). This is the authoritative technical reference.

### Managing Plans

- Project plans live in `.avante/plans/` with a `Proj-NNN-description.md` naming convention
- When starting a new project, create a new plan file using the template at `~/.config/nvim/avante/templates/project-plan.md`
- Mark phases as complete in the plan's status tables as work progresses
- When a project is complete, move it to the "Completed Projects" section of the project plan

### Managing Rules

- Project-specific rules go in `.avante/rules/` with `.avanterules` extension
- Global rules live in `~/.config/nvim/avante/rules/`
- Project rules override global rules (hierarchical loading)
- Rules are auto-loaded when avante.nvim starts

### The `_scratch/` Directory

The `_scratch/` directory at the repository root is for temporary files, experiments, and work-in-progress. It is excluded from git via `.gitignore` and from stow via `.stow-local-ignore`.

- Use `_scratch/` for testing new configurations before committing them
- Files in `_scratch/` are not tracked by git — they will be lost if the directory is deleted
- Clean up `_scratch/` periodically to avoid clutter

## Managing Logs

The bootstrap installer creates timestamped log files in `~/.dotfiles/logs/`.

### Log File Format

```
~/.dotfiles/logs/install-laptop-2026-05-07T12-00-00.log
```

Each log captures:

- System information (kernel, OS release)
- All command output and errors
- Task completion status

### Log Management

- Logs are not tracked in git (excluded by `.gitignore`)
- Clean up old logs periodically: `rm ~/.dotfiles/logs/*.log`
- Consider adding a cron job or systemd timer for automatic cleanup if logs accumulate
- Logs are useful for debugging bootstrap failures — check the most recent log first

## Managing Secrets and the `.env` File

### Current State

The file `stow/neovim_neovide/.config/nvim/.env` is tracked in git and symlinked by stow to `~/.config/nvim/.env`. This is a **temporary arrangement** — secrets, passwords, and API tokens should eventually be handled through a proper secrets management solution.

### What's in the `.env` File

The `.env` file contains API keys for AI services (DeepSeek, etc.) used by avante.nvim. These are loaded at Neovim startup by the `dotenv.nvim` plugin.

### Security Guidelines

- **Do not** add new secrets to the tracked `.env` file
- **Do not** commit the `.env` file if it's been removed from git tracking
- **Do not** share the `.env` file contents in issues, pull requests, or documentation
- **Future**: Migrate to Ansible vault, `pass`, `gopass`, or systemd credential storage

### Adding a New Secret

1. Add the variable to `~/.config/nvim/.env` (the symlinked target, not the repo file)
2. Reference the environment variable in your Neovim config using `vim.env.VARIABLE_NAME`
3. If the secret needs to be available system-wide, add it to `~/.config/environment.d/` or your shell profile

## Working with the Ansible Runner and Callback Plugins

### `ansible/runner.py`

The `runner.py` script provides an alternative to the `ansible-pull` CLI using the Python API (`PlaybookExecutor`).

```bash
python3 ansible/runner.py bootstrap.yaml
```

**Maintenance notes:**

- The runner takes a playbook filename as an argument and runs it against the localhost inventory
- It uses the same `ansible.cfg` configuration as the CLI
- If you add new playbooks, the runner works with them automatically — no changes needed
- The runner is a convenience tool; the primary method of running playbooks is via `ansible-pull` or `ansible-playbook`

### `ansible/callback_plugins/log_output_normalizer.py`

This custom stdout callback provides colorized output and logging. It is configured in `ansible.cfg`:

```ini
stdout_callback = log_output_normalizer
```

**Maintenance notes:**

- The callback plugin is registered automatically by being in the `callback_plugins/` directory
- If you change the callback, update the `ansible.cfg` configuration if needed
- To temporarily disable the custom callback, set `stdout_callback = yaml` or `stdout_callback = unixy` in `ansible.cfg`

### `ansible/.collections/`

Ansible collections are installed locally in `ansible/.collections/` (configured via `collections_path` in `ansible.cfg`).

- Collections are installed by the bootstrap installer and can be updated with `ansible-galaxy collection install -r ansible/requirements/common.yaml --force`
- If you add a new collection requirement, add it to `ansible/requirements/common.yaml` and reinstall
- The `.collections/` directory is excluded from git via `.gitignore`

## Managing Legacy Playbooks

The following legacy playbooks exist in `ansible/playbooks/` from a prior project structure:

- `arch_desktop.yaml`
- `debian_router.yaml`
- `debian_server.yaml`
- `ubuntu_server.yaml`
- `home_theater_pc_debian.yaml`

### Maintenance Policy

- **Preserve**: These playbooks are preserved for reference and may be useful if you need to set up a similar system
- **Do not modify**: Avoid making changes to legacy playbooks unless you're actively using them
- **Future removal**: These may be removed in a future cleanup pass once their functionality is verified to be covered by the new role structure
- **Reference only**: The primary playbooks (`bootstrap.yaml`, `laptop.yaml`, `desktop.yaml`, `server.yaml`) are the canonical configurations

### If You Need to Use a Legacy Playbook

1. Review the playbook to understand what roles and variables it uses
2. Check if those roles still exist in the current `ansible/roles/` structure
3. Run with `--check` mode first to verify it works: `ansible-playbook -i localhost, --check ansible/playbooks/arch_desktop.yaml`
4. Consider migrating the functionality to a new role instead of relying on the legacy playbook

## Rolling Back Changes

### Rolling Back a Stow Change

If a stow operation created incorrect symlinks:

```bash
# Unstow the package to remove all symlinks
cd ~/.dotfiles/stow
stow --delete my_package

# Restore the previous version of the config file
git checkout HEAD~1 -- stow/my_package/.config/my_app/config.toml

# Re-stow with the restored version
stow my_package
```

### Rolling Back an Ansible Change

If an Ansible playbook run made unwanted changes:

```bash
# 1. Identify the change in git history
cd ~/.dotfiles
git log --oneline -10

# 2. Revert the Ansible role changes
git revert <commit-hash>

# 3. Re-run the playbook to apply the reverted state
ansible-playbook -i localhost, ansible/playbooks/laptop.yaml
```

### Rolling Back a Git Commit

```bash
# 1. Undo the last commit but keep changes staged
git reset --soft HEAD~1

# 2. Or undo the last commit and unstage changes
git reset HEAD~1

# 3. Or completely discard the last commit's changes
git reset --hard HEAD~1
```

### Recovering from a Failed `ansible-pull` Run

```bash
# 1. Check the log file for errors
ls -lt ~/.dotfiles/logs/ | head -3
cat ~/.dotfiles/logs/$(ls -t ~/.dotfiles/logs/ | head -1)

# 2. Fix the issue (missing package, wrong path, etc
```

## Repository Cleanup

### Removing Old Branches

```bash
# List local branches that have been merged
git branch --merged main

# Delete a merged branch
git branch -d old-branch-name
```

### Cleaning Up Untracked Files

```bash
# Dry run — see what would be removed
git clean -n

# Remove untracked files
git clean -f

# Remove untracked directories
git clean -fd
```

### Checking Repository Size

```bash
# Check repository size
du -sh .git

# Find large files in git history
git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | awk '/^blob/ {print $4, $3}' | sort -rn | head -10
```

## Backup and Recovery

### Backing Up the Repository

```bash
# Standard backup (bare clone — no working directory)
git clone --bare ~/.dotfiles ~/backups/dotfiles-backup.git

# Full backup with all branches
git bundle create ~/backups/dotfiles-$(date +%Y-%m-%d).bundle --all
```

### Recovering from a Broken Symlink

If a stow symlink becomes broken or points to the wrong location:

```bash
# 1. Remove the broken symlink
rm ~/.config/myapp/config

# 2. Restow the package
cd ~/.dotfiles/stow
stow --restow my_package

# 3. Verify the symlink
ls -la ~/.config/myapp/config
```

### Recovering from a Corrupted Repository

If the local git repository becomes corrupted:

```bash
# 1. Backup any uncommitted changes
cp -r ~/.dotfiles ~/dotfiles-backup

# 2. Re-clone the repository
cd ~
mv .dotfiles .dotfiles-corrupted
git clone https://github.com/ggroenendale/dotfiles.git .dotfiles

# 3. Restore any uncommitted changes
cp -r ~/dotfiles-backup/stow/* ~/.dotfiles/stow/
cp -r ~/dotfiles-backup/ansible/* ~/.dotfiles/ansible/

# 4. Re-stow all packages
cd ~/.dotfiles/stow
for pkg in */; do
    stow --restow "${pkg%/}"
done
```

### Full System Recovery

To recover a system from scratch using the dotfiles:

```bash
# 1. Install the base OS (Arch, Debian, Ubuntu, or openSUSE)

# 2. Install prerequisites
sudo pacman -S git python3 ansible  # or apt/zypper equivalents

# 3. Clone and run the bootstrap installer
git clone https://github.com/ggroenendale/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap/install-laptop.sh
```

## Cross-Platform Maintenance

### Package Name Differences

When adding a new package to an Ansible role, you need to provide the correct package name for each supported OS:

| Purpose             | Arch Linux     | Debian/Ubuntu      | openSUSE             |
| ------------------- | -------------- | ------------------ | -------------------- |
| Package manager     | pacman         | apt                | zypper               |
| Package format      | `package-name` | `package-name`     | `package-name`       |
| Development headers | `package-name` | `package-name-dev` | `package-name-devel` |

### Path Differences

Some configuration paths differ between distributions:

| Component     | Arch/Debian/Ubuntu | openSUSE    |
| ------------- | ------------------ | ----------- |
| Locale config | `/etc/locale.gen`  | `localectl` |
| Default shell | `/bin/bash`        | `/bin/bash` |
| SSH server    | `openssh-server`   | `openssh`   |

### Testing on a New Distribution

When adding support for a new distribution:

1. Create a VM or container with the target OS
2. Run the bootstrap installer with `--dry-run` to verify OS detection
3. Run the full installer and note any failures
4. Fix package names and paths in the Ansible roles
5. Add OS-specific variable files to each role
6. Test idempotency by running the playbook twice
7. Update the supported OS list in all documentation
