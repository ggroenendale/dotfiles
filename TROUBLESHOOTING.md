# Troubleshooting Guide

This document covers common issues encountered when using the dotfiles repository, bootstrap installers, and Ansible playbooks.

## Table of Contents

- [Bootstrap Failures](#bootstrap-failures)
- [Ansible Playbook Failures](#ansible-playbook-failures)
- [Stow Symlink Issues](#stow-symlink-issues)
- [Cross-Platform Issues](#cross-platform-issues)
- [Diagnostic Commands](#diagnostic-commands)
- [Gathering Debug Information](#gathering-debug-information)

## Bootstrap Failures

### "tput: command not found"

The bootstrap installer requires `tput` (from ncurses) for cursor control and spinner display.

**Solution:**

```bash
# Arch Linux
sudo pacman -S ncurses

# Debian/Ubuntu
sudo apt install ncurses-bin

# openSUSE
sudo zypper install ncurses-utils
```

### "Unsupported OS" Error

The installer detected an OS that isn't in the supported list.

**Diagnosis:**

```bash
cat /etc/os-release
```

Check the `ID` field. The installer supports: `arch`, `debian`, `ubuntu`, and any `opensuse*` variant.

**Solution:** If your OS is a derivative of a supported distribution (e.g., Linux Mint is Debian-based), you may need to add a new OS case to the installer script. See [MAINTENANCE.md](MAINTENANCE.md) for instructions.

### Network Issues During Bootstrap

The bootstrap installer needs to:
1. Download packages from OS repositories
2. Clone the dotfiles repository from GitHub
3. Run `ansible-pull` which also needs GitHub access

**Diagnosis:**

```bash
# Test GitHub connectivity
curl -s -o /dev/null -w "%{http_code}" https://github.com

# Test DNS resolution
nslookup github.com

# Check if behind a proxy
echo $http_proxy
echo $https_proxy
```

**Solutions:**

- Check internet connection: `ping -c 4 8.8.8.8`
- Check DNS: `ping -c 4 github.com`
- If behind a proxy, set `http_proxy` and `https_proxy` environment variables
- If GitHub is blocked, use a mirror or VPN
- If the repository is already cloned locally, `ansible-pull` can work offline with `--clean` disabled

### "git clone" Fails

**Diagnosis:**

```bash
# Check if the directory already exists
ls -la ~/.dotfiles

# Check git credentials
git config --global user.name
git config --global user.email
```

**Solutions:**

- If `~/.dotfiles` already exists, the installer will try to pull instead of clone
- If you don't have git credentials configured, set them:
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "your.email@example.com"
  ```
- If using SSH instead of HTTPS, ensure your SSH key is added to the agent:
  ```bash
  ssh-add -l
  ssh -T git@github.com
  ```

### Package Installation Fails During Bootstrap

**Diagnosis:**

```bash
# Check package manager status
sudo pacman -Sy  # Arch
sudo apt update  # Debian/Ubuntu
sudo zypper ref  # openSUSE
```

**Solutions:**

- Ensure you have sudo access: `sudo -v`
- Check if the package names are correct for your distribution
- If a specific package fails, try installing it manually first
- For Arch Linux, ensure pacman keyring is initialized:
  ```bash
  sudo pacman-key --init
  sudo pacman-key --populate archlinux
  ```

### "ansible-pull" Fails

**Diagnosis:**

```bash
# Check Ansible version
ansible --version

# Check if collections are installed
ansible-galaxy collection list

# Try running the playbook directly
cd ~/.dotfiles
ansible-playbook -i localhost, ansible/playbooks/bootstrap.yaml --syntax-check
```

**Solutions:**

- Ensure Ansible is installed and meets minimum version (2.14+)
- Install required collections:
  ```bash
  ansible-galaxy collection install community.general ansible.posix kubernetes.core
  ```
- Check the repository URL and branch are correct
- If the playbook has syntax errors, run with `--syntax-check`
- Run with verbose output: `ansible-pull -v ...`

## Ansible Playbook Failures

### Syntax Errors in Playbooks

**Diagnosis:**

```bash
cd ~/.dotfiles
ansible-playbook -i localhost, ansible/playbooks/laptop.yaml --syntax-check
```

**Solutions:**

- Check YAML indentation (Ansible requires consistent spacing)
- Verify all variable references use correct Jinja2 syntax (`{{ var_name }}`)
- Ensure all boolean values are lowercase (`true`, `false`, `yes`, `no`)
- Check for missing quotes around strings containing colons or special characters

### "Module Not Found" Errors

**Diagnosis:**

```bash
# List installed collections
ansible-galaxy collection list

# Check if a specific module is available
ansible-doc -l | grep module_name
```

**Solutions:**

- Install missing collections:
  ```bash
  ansible-galaxy collection install community.general ansible.posix kubernetes.core
  ```
- Ensure `collections_path` in `ansible.cfg` points to the correct directory
- If using a custom module, verify it's in the correct `library/` directory

### Permission Denied Errors

**Diagnosis:**

```bash
# Check if running with correct privileges
whoami
sudo -n true && echo "sudo available" || echo "sudo not available"
```

**Solutions:**

- Some tasks require `become: true` or `become: yes` for sudo access
- Check that the user has sudo privileges: `sudo -l`
- For file operations, verify the target directory is writable
- For SSH operations, verify key permissions: `chmod 600 ~/.ssh/*`

### "Variable Not Defined" Errors

**Diagnosis:**

```bash
# Check variable definitions in the playbook and role
grep -r "variable_name" ansible/playbooks/
grep -r "variable_name" ansible/roles/
```

**Solutions:**

- Ensure variables are defined in `vars/`, `defaults/`, or passed via `--extra-vars`
- Check for typos in variable names (Ansible is case-sensitive)
- Verify OS-specific variable files exist for the target distribution
- Use `| default('fallback_value')` for optional variables

### Idempotency Issues

If a playbook reports changes on every run, it's not idempotent.

**Diagnosis:**

```bash
# Run the playbook twice and compare output
ansible-playbook -i localhost, ansible/playbooks/laptop.yaml 2>&1 | grep "changed="
```

**Solutions:**

- Add `changed_when: false` to tasks that don't actually change state
- Use `creates` or `removes` parameters for command tasks
- Use `stat` module to check file existence before creating
- Use `lineinfile` instead of `blockinfile` for single-line changes
- Use `copy` with `checksum` verification instead of always copying

## Stow Symlink Issues

### Broken Symlinks After Repository Restructure

If symlinks are broken after moving files between stow packages:

**Diagnosis:**

```bash
# Find broken symlinks
find ~/.config -type l ! -exec test -e {} \; -print 2>/dev/null
find ~/.local -type l ! -exec test -e {} \; -print 2>/dev/null
```

**Solutions:**

```bash
# Restow all packages
cd ~/.dotfiles/stow
for pkg in */; do
    stow --restow "${pkg%/}"
done

# Or use the fix-symlinks script
./bootstrap/fix-symlinks.sh
```

### Stow Conflicts

If two stow packages try to create the same symlink:

**Diagnosis:**

```bash
cd ~/.dotfiles/stow
stow --verbose bash 2>&1
```

**Solutions:**

- Check for overlapping file paths between packages
- Use `--no-folding` to prevent directory-level conflicts
- Restructure packages to avoid overlap, or use `.stow-local-ignore` to exclude conflicting files
- If the conflict is intentional (e.g., `neovim_neovide` and `app_desktop_files` both managing `.local/share/applications/`), stow the more specific package first

### "No such directory" Error

**Diagnosis:**

```bash
# Check if the stow package directory exists
ls -la ~/.dotfiles/stow/
```

**Solutions:**

- Ensure the package directory exists under `stow/`
- Check for typos in the package name
- If the package was moved or renamed, update the reference

### Permission Denied on Symlinks

**Diagnosis:**

```bash
# Check symlink permissions
ls -la ~/.config/some_config
```

**Solutions:**

- Stow symlinks inherit the permissions of the target file
- Ensure the target file has the correct permissions: `chmod 644 file`
- For executable scripts: `chmod +x script.sh`
- For SSH files: `chmod 600 ~/.ssh/config`

## Cross-Platform Issues

### Package Name Differences

The same software may have different package names across distributions.

**Diagnosis:**

```bash
# Search for the package on each distribution
pacman -Ss package-name       # Arch
apt search package-name       # Debian/Ubuntu
zypper search package-name    # openSUSE
```

**Solutions:**

- Add OS-specific package names to the Ansible role's `vars/` directory
- Use the `package` module (which handles OS detection) instead of `apt`, `pacman`, or `zypper` directly
- Test on each supported distribution before committing changes

### Path Differences

Some configuration files and directories differ between distributions.

**Common differences:**

| Component | Arch/Debian/Ubuntu | openSUSE |
|-----------|-------------------|----------|
| Locale config | `/etc/locale.gen` | `localectl` |
| SSH server package | `openssh-server` | `openssh` |
| Default shell | `/bin/bash` | `/bin/bash` |

**Solutions:**

- Use Ansible facts (`ansible_facts.distribution`, `ansible_facts.os_family`) to conditionally set paths
- Test on each distribution before committing changes
- Document any known path differences in the role's README

### OS Detection Fails

**Diagnosis:**

```bash
# Check what the installer detects
cat /etc/os-release
echo $ID
```

**Solutions:**

- The installer reads the `ID` field from `/etc/os-release`
- For openSUSE variants, the installer normalizes `opensuse-tumbleweed`, `opensuse-leap`, etc. to `opensuse`
- If your distribution isn't detected, add a new case to the `detect_os()` function in the installer script

### Locale Issues

**Diagnosis:**

```bash
# Check current locale settings
locale
locale -a
```

**Solutions:**

- The bootstrap installer sets `en_US.UTF-8` locale on Arch and openSUSE
- On Debian/Ubuntu, locale is typically configured during OS installation
- If locale generation fails, check that the locale is uncommented in `/etc/locale.gen`
- On openSUSE, use `localectl set-locale LANG=en_US.UTF-8`

### Gathering Debug Information

When reporting an issue, include the following information to help diagnose the problem.

**System Information:**

```bash
# OS and kernel version
cat /etc/os-release
uname -a

# Ansible version
ansible --version 2>/dev/null || echo "Ansible not installed"

# Python version
python3 --version

# Git version
git --version

# Stow version
stow --version 2>/dev/null || echo "Stow not installed"
```

**Repository State:**

```bash
# Current branch and status
cd ~/.dotfiles
git branch -v
git status

# Recent commits
git log --oneline -10

# Uncommitted changes
git diff --stat
```

**Symlink Status:**

```bash
# Check all stow symlinks
cd ~/.dotfiles/stow
for pkg in */; do
    echo "=== ${pkg%/} ==="
    stow --no -v "${pkg%/}" 2>&1
done

# Find broken symlinks
find ~/.config -type l ! -exec test -e {} \; -print 2>/dev/null
find ~/.local -type l ! -exec test -e {} \; -print 2>/dev/null
```

**Ansible Debug Output:**

```bash
# Run with verbose output
cd ~/.dotfiles
ansible-playbook -i localhost, -vvv ansible/playbooks/bootstrap.yaml 2>&1 | tail -100

# Check for syntax errors
ansible-playbook --syntax-check ansible/playbooks/laptop.yaml 2>&1

# List installed collections
ansible-galaxy collection list 2>&1
```

**Bootstrap Logs:**

```bash
# Check the most recent bootstrap log
ls -lt ~/.dotfiles/logs/ | head -5
cat ~/.dotfiles/logs/$(ls -t ~/.dotfiles/logs/ | head -1) 2>/dev/null || echo "No logs found"
```

**Package Manager Status:**

```bash
# Check package manager health
sudo pacman -Sy 2>&1 || sudo apt update 2>&1 || sudo zypper ref 2>&1

# Check if specific packages are installed
pacman -Qi ansible 2>/dev/null || dpkg -l ansible 2>/dev/null || rpm -q ansible 2>/dev/null
```

**Network Connectivity:**

```bash
# Test GitHub access
curl -s -o /dev/null -w "%{http_code}" https://github.com

# Test DNS
nslookup github.com 2>/dev/null || host github.com 2>/dev/null

# Check proxy settings
echo "HTTP_PROXY=$HTTP_PROXY"
echo "HTTPS_PROXY=$HTTPS_PROXY"
```

**Environment Variables:**

```bash
# Check relevant environment variables
echo "HOME=$HOME"
echo "SHELL=$SHELL"
echo "PATH=$PATH"
echo "EDITOR=$EDITOR"
echo "XDG_CONFIG_HOME=$XDG_CONFIG_HOME"
echo "XDG_DATA_HOME=$XDG_DATA_HOME"
```

**How to Report an Issue:**

1. Run the diagnostic commands above and save the output
2. Describe what you were trying to do
3. Describe what actually happened (include error messages)
4. Describe what you expected to happen
5. Include any steps you've already taken to resolve the issue
6. Open an issue on GitHub or contact the repository maintainer

**Common Diagnostic Patterns:**

- If the bootstrap installer fails, check the log file first — it captures all output
- If a specific Ansible task fails, run it with `-vvv` for full debug output
- If symlinks are broken, run `find ~/.config -type l ! -exec test -e {} \; -print` to identify them
- If a package is missing, check the OS-specific package name in the Ansible role's `vars/` directory
- If the issue is cross-platform, note which distribution and version you're using

