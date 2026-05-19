# System Users Role

Manages user accounts, groups, home directories, and related user configuration across all managed systems.

## Overview

This role handles the creation, modification, and removal of user accounts on target systems. It is designed to work across multiple Linux distributions (Arch Linux, Debian, Ubuntu, openSUSE) with OS-specific task files for distribution-specific concerns (e.g., group names, default shells, useradd conventions).

The role is invoked from the bootstrap playbook and machine-specific playbooks (e.g., `laptop.yaml`, `workstation.yaml`, `server.yaml`).

## Architecture

### Variable Source

All user variables are defined in a single source:

```
ansible/group_vars/all/vault_unencrypted.yaml  ← Source of truth (plaintext)
                        ↓ (ansible-vault encrypt)
ansible/group_vars/all/vault_encrypted.yaml     ← Imported by playbooks
                        ↓ (vars_files in playbook)
                    playbooks/*.yaml
                        ↓ (role invocation)
            ansible/roles/system/users/tasks/
```

The `vars/` directory inside this role has been removed — all user data comes from `group_vars/all/`. This avoids duplication and ensures a single source of truth for user definitions across all playbooks.

### Current User Configuration

```yaml
# ansible/group_vars/all/vault_unencrypted.yaml
users:
  - username: geoff
    password: "{{ '@S$ba11s' | password_hash('sha512') }}"
    uid: 1501
    comment: "Geoff Groenendale - Admin"
    shell: /bin/bash
    ssh_keys:
      - ""
    state: present
```

### Variable Schema

Each entry in the `users` list supports the following fields:

| Field              | Type   | Required | Description                                   |
| ------------------ | ------ | -------- | --------------------------------------------- |
| `username`         | string | ✓        | Login name                                    |
| `password`         | string | ✓        | Hashed password (use `password_hash` filter)  |
| `uid`              | number | ✗        | Specific UID assignment                       |
| `comment`          | string | ✗        | GECOS field (full name, description)          |
| `shell`            | string | ✗        | Login shell path (default: `/bin/bash`)       |
| `ssh_keys`         | list   | ✗        | SSH public keys for `authorized_keys`         |
| `state`            | string | ✗        | `present` (default) or `absent`               |
| `groups`           | string | ✗        | Comma-separated supplementary groups          |
| `append`           | bool   | ✗        | Append to groups instead of replacing         |
| `create_home`      | bool   | ✗        | Create home directory (default: true)         |
| `home`             | string | ✗        | Home directory path                           |
| `system`           | bool   | ✗        | Create as system user                         |
| `expires`          | number | ✗        | Account expiration (epoch seconds)            |
| `password_lock`    | bool   | ✗        | Lock password (disable login)                 |
| `generate_ssh_key` | bool   | ✗        | Generate SSH key pair                         |
| `ssh_key_type`     | string | ✗        | Key type: `ed25519` (default), `rsa`, `ecdsa` |
| `ssh_key_bits`     | number | ✗        | Key bits (default: 4096 for rsa)              |
| `update_password`  | string | ✗        | `always` or `on_create`                       |
| `remove`           | bool   | ✗        | Remove user if not in list (cleanup mode)     |

### Task Flow

```
main.yaml
├── arch.yaml      → Creates users from `users` variable (Arch)
├── debian.yaml    → Debug placeholder only
├── ubuntu.yaml    → Empty file
└── opensuse.yaml  → Debug placeholder only
```

## Current State

### What Works

| Feature                         | Arch | Debian | Ubuntu | openSUSE |
| ------------------------------- | ---- | ------ | ------ | -------- |
| User creation from `users` list | ✓    | ✗      | ✗      | ✗        |
| Password hashing                | ✓    | ✗      | ✗      | ✗        |
| Shell assignment                | ✓    | ✗      | ✗      | ✗        |
| UID assignment                  | ✓    | ✗      | ✗      | ✗        |
| GECOS comment field             | ✓    | ✗      | ✗      | ✗        |
| Group membership (`wheel`)      | ✓    | ✗      | ✗      | ✗        |
| Debug/placeholder tasks         | —    | ✓      | ✗      | ✓        |

### What Needs Work

- **Debian/Ubuntu/openSUSE task files** — Only have debug placeholders or are empty
- **SSH key deployment** — `ssh_keys` field exists in the schema but isn't wired up in tasks
- **User removal** — `state: absent` isn't handled
- **Group management** — No dedicated group creation tasks
- **Sudoers configuration** — Not implemented
- **Home directory permissions** — Not explicitly managed

## Requirements

### Defined Requirements (to be implemented)

#### 1. Cross-Distribution Task Files

Each distribution needs proper task implementation:

- **`tasks/arch.yaml`** — ✓ Basic implementation exists, needs expansion
- **`tasks/debian.yaml`** — ✗ Debug placeholder only
- **`tasks/ubuntu.yaml`** — ✗ Empty file
- **`tasks/opensuse.yaml`** — ✗ Debug placeholder only

#### 2. OS-Specific Group Handling

Different distributions use different group names for administrative access:

| Purpose     | Arch      | Debian/Ubuntu | openSUSE  |
| ----------- | --------- | ------------- | --------- |
| Sudo access | `wheel`   | `sudo`        | `wheel`   |
| Docker      | `docker`  | `docker`      | `docker`  |
| Video       | `video`   | `video`       | `video`   |
| Audio       | `audio`   | `audio`       | `audio`   |
| Input       | `input`   | `input`       | `input`   |
| Storage     | `storage` | `storage`     | `storage` |

The role should map common group names to distribution-appropriate ones, or define groups per-distribution in vars.

#### 3. Sudoers Configuration

- Ensure sudo is installed (via package management role)
- Configure sudoers file or drop-in snippets in `/etc/sudoers.d/`
- Support passwordless sudo for admin users (optional, configurable)
- Support per-user sudo rules (e.g., specific command restrictions)

```yaml
# Proposed variable structure (in group_vars)
sudo_users:
  - username: geoff
    privileges: "ALL=(ALL) ALL"
    nopasswd: true
```

#### 4. User Shell Management

- Set default shell per distribution (bash, zsh, fish)
- Ensure the shell binary is installed before assigning it
- Support per-user shell override via the `shell` field

#### 5. SSH Key Management

- Deploy SSH public keys from the `ssh_keys` list to `~/.ssh/authorized_keys`
- Generate SSH key pairs when `generate_ssh_key: true`
- Support multiple key types (ed25519, rsa, ecdsa)
- Remove stale SSH keys from `authorized_keys`
- Set proper permissions on `~/.ssh/` directory and files

#### 6. Home Directory Management

- Create home directories with correct permissions (750 or 700)
- Deploy skeleton files (`.bashrc`, `.profile`, `.bash_logout`, etc.) <- handled by dotfiles ofr user:geoff, if any other user then skeleton files would be necessary.
- Support custom skeleton directories per user or per distribution
- Handle home directory encryption (optional, e.g., eCryptfs, LUKS)

#### 7. User Cleanup and Deprovisioning

- Remove users when `state: absent`
- Optionally archive home directories before removal
- Remove user crontab, at jobs, and print jobs
- Remove user from all supplementary groups
- Lock account before removal (disable password, expire account)

```yaml
# Proposed variable structure (in group_vars)
user_removal_archive: true # Archive home dirs before removal
user_removal_archive_path: /var/backups/users/
```

#### 8. System User Management

- Create system users for services (e.g., `nginx`, `postgres`, `prometheus`)
- System users should have:
  - No login shell (`/sbin/nologin` or `/usr/sbin/nologin`)
  - No home directory (or restricted home)
  - UID in system range (< 1000)
  - Account expiration disabled

```yaml
# Proposed variable structure (in group_vars)
system_users:
  - username: prometheus
    shell: /sbin/nologin
    home: /var/lib/prometheus
    create_home: true
    groups: prometheus
    system: true
```

#### 9. User Groups Management

- Create supplementary groups before users that need them
- Support group-level configuration (GID, members, system group flag)

```yaml
# Proposed variable structure (in group_vars)
user_groups:
  - name: docker
    system: false
    gid: 985
  - name: developers
    gid: 2000
    members:
      - geoff
      - alice
```

#### 10. Password Policy Integration

- Integrate with system password policies (PAM, `chage`)
- Set password expiration and aging rules
- Force password change on first login
- Lock inactive accounts

```yaml
# Proposed variable structure (in group_vars)
password_policy:
  min_days: 0
  max_days: 90
  warn_days: 7
  inactive_days: 30
  expiration_date: null
  force_first_login_change: false
```

#### 11. Vault Auto-Update on SSH Key Generation

When the playbook generates an SSH key pair for a user, the public key should be automatically written back to the vault file so it can be deployed to other machines.

**The Problem:**

- SSH keys are generated on the local machine during playbook execution
- The public key value needs to be in the vault file so other playbooks (e.g., deploying `authorized_keys` to servers) can access it
- Manually copying the key back to the vault file is error-prone and breaks automation

**The Solution — Auto-Update Workflow:**

Since this is an **ansible-pull** setup (everything runs on localhost), the workflow is straightforward — no separate control node, no fetching needed:

```
Playbook starts (localhost)
    ↓
Check if SSH key exists on local machine (stat)
    ↓
If missing → Generate key pair (openssh_keypair module)
    ↓
Read the generated public key from disk (slurp/lookup)
    ↓
Read current vault_unencrypted.yaml
    ↓
Compare public key with existing ssh_keys entry
    ↓
If different → Update vault_unencrypted.yaml (lineinfile on localhost)
    ↓
Re-encrypt to vault_encrypted.yaml (ansible-vault encrypt)
    ↓
Commit changes to dotfiles repo (optional, flag-controlled)
```

**Key Design Decisions:**

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Vault file to modify | `vault_unencrypted.yaml` (plaintext) | Must decrypt, edit, re-encrypt |
| Encryption method | `ansible-vault encrypt` via command module | Standard Ansible approach, uses existing vault password |
| Vault password source | `.vault_pass.txt`, path in ansible.cfg | Must be available for re-encryption |
| Key comparison | Compare public key to existing `ssh_keys` | Avoid unnecessary vault file changes (and git churn) |
| Git commit | Optional, controlled by a flag | Some users want auto-commit, others prefer manual review |

**Handler Design:**

The vault update workflow uses Ansible handlers to batch operations and avoid redundant work. Multiple tasks can notify the same handlers, which run once at the end of the play.

```
Tasks (run in order):
  1. decrypt vault          → Decrypt vault_encrypted.yaml to vault_unencrypted.yaml
                             (if vault_unencrypted.yaml doesn't exist or is out of date)
  2. generate SSH keys      → Generate key pairs for users with generate_ssh_key=true
                             (notifies: update vault with SSH keys)
  3. update vault           → Write public keys to vault_unencrypted.yaml
                             (notifies: re-encrypt vault)

Handlers (run at end of play, once per unique notification):
  re-encrypt vault          → Encrypt vault_unencrypted.yaml → vault_encrypted.yaml
                             (notifies: commit vault changes)

  commit vault changes      → Git add + commit vault files
                             (notifies: push vault changes)

  push vault changes        → Git push to remote
```

**Handler: re-encrypt vault**

```yaml
# handlers/main.yaml
- name: re-encrypt vault
  ansible.builtin.command:
    cmd: >
      ansible-vault encrypt
      --vault-password-file {{ vault_auto_update.vault_password_file }}
      --output {{ vault_auto_update.vault_encrypted_path }}
      {{ vault_auto_update.vault_unencrypted_path }}
  changed_when: true
  listen: "re-encrypt vault"
```

**Handler: commit vault changes**

```yaml
- name: commit vault changes
  ansible.builtin.command:
    cmd: >
      git -C {{ ansible_facts.env.HOME }}/.dotfiles
      add {{ vault_auto_update.vault_unencrypted_path }}
      {{ vault_auto_update.vault_encrypted_path }}
      && git -C {{ ansible_facts.env.HOME }}/.dotfiles
      commit -m "{{ vault_auto_update.commit_message }}"
  changed_when: true
  when: vault_auto_update.auto_commit | default(false)
  listen: "commit vault changes"
```

**Handler: push vault changes**

```yaml
- name: push vault changes
  ansible.builtin.command:
    cmd: >
      git -C {{ ansible_facts.env.HOME }}/.dotfiles push
  changed_when: true
  when: vault_auto_update.auto_push | default(false)
  listen: "push vault changes"
```

**Proposed Variable Structure:**

```yaml
# In vault_unencrypted.yaml — ssh_keys gets auto-populated
users:
  - username: geoff
    password: "{{ 'mypassword' | password_hash('sha512') }}"
    uid: 1501
    generate_ssh_key: true
    ssh_key_type: ed25519
    # This field gets auto-populated by the playbook:
    ssh_keys:
      - "ssh-ed25519 AAAAC3... geoff@laptop"

# Control flags (in group_vars, not vault)
vault_auto_update:
  enabled: true
  vault_unencrypted_path: "{{ ansible_facts.env.HOME }}/.dotfiles/ansible/group_vars/all/vault_unencrypted.yaml"
  vault_encrypted_path: "{{ ansible_facts.env.HOME }}/.dotfiles/ansible/group_vars/all/vault_encrypted.yaml"
  vault_password_file: "{{ ansible_facts.env.HOME }}/.dotfiles/.vault_password"
  auto_commit: false
  auto_push: false
  commit_message: "chore: auto-update SSH public keys from playbook run"
```

## Cross-Device Key Distribution Workflow

The vault file in this repo acts as a **shared key exchange** between all your devices. Here's how it works:

```

GitHub (dotfiles repo)
│
├── Device A (laptop) pulls repo
│ ↓
│ Playbook generates SSH key (first run)
│ ↓
│ Public key written to vault_unencrypted.yaml
│ ↓
│ Vault re-encrypted to vault_encrypted.yaml
│ ↓
│ User commits & pushes to GitHub
│
├── Device B (desktop) pulls repo
│ ↓
│ Playbook reads Device A's public key from vault
│ ↓
│ Device A's key added to Device B's authorized_keys
│ ↓
│ Playbook generates Device B's SSH key (first run)
│ ↓
│ Device B's public key written to vault
│ ↓
│ User commits & pushes to GitHub
│
└── Device A pulls again
↓
Gets Device B's public key
↓
Device B's key added to Device A's authorized_keys
↓
✅ Both devices can now SSH into each other

```

This creates a **mesh trust network** — every device automatically gets the public keys of all other devices, and can SSH into any of them without manual key copying.

## Role Variables

### Main Variables

| Variable                    | Type   | Default               | Description                                                    |
| --------------------------- | ------ | --------------------- | -------------------------------------------------------------- |
| `users`                     | list   | `[]`                  | User definitions (single source of truth in `group_vars/all/`) |
| `sudo_users`                | list   | `[]`                  | Sudoers configuration per user                                 |
| `system_users`              | list   | `[]`                  | System user definitions for services                           |
| `user_groups`               | list   | `[]`                  | Supplementary group definitions                                |
| `password_policy`           | dict   | `{}`                  | Password aging and expiration rules                            |
| `user_removal_archive`      | bool   | `false`               | Archive home dirs before removal                               |
| `user_removal_archive_path` | string | `/var/backups/users/` | Path for archived home directories                             |

### OS Detection Flags

These flags are expected to be set by the bootstrap playbook or group_vars:

| Variable      | Type | Description                |
| ------------- | ---- | -------------------------- |
| `is_arch`     | bool | True on Arch Linux systems |
| `is_debian`   | bool | True on Debian systems     |
| `is_ubuntu`   | bool | True on Ubuntu systems     |
| `is_opensuse` | bool | True on openSUSE systems   |

## Directory Structure

```

ansible/roles/system/users/
├── README.md # This file
├── meta/
│ └── main.yaml # Galaxy info and dependencies
├── tasks/
│ ├── main.yaml # Task dispatcher (OS detection)
│ ├── arch.yaml # Arch Linux user tasks
│ ├── debian.yaml # Debian user tasks (placeholder)
│ ├── ubuntu.yaml # Ubuntu user tasks (empty)
│ └── opensuse.yaml # openSUSE user tasks (placeholder)
└── templates/ # (future) Sudoers snippets, skel files, etc.

```

## Usage

### Basic Usage

Include the role in a playbook:

```yaml
- name: Configure system users
  ansible.builtin.include_role:
    name: system/users
```

### Defining Users

Define users in `group_vars/all/vault_unencrypted.yaml`:

```yaml
users:
  - username: geoff
    password: "{{ 'mypassword' | password_hash('sha512') }}"
    uid: 1501
    comment: "Geoff Groenendale - Admin"
    shell: /bin/bash
    groups: wheel,docker
    append: true
    ssh_keys:
      - "ssh-ed25519 AAAAC3... geoff@laptop"
    state: present
```

Then encrypt to `vault_encrypted.yaml`:

```bash
ansible-vault encrypt ansible/group_vars/all/vault_unencrypted.yaml \
  --output ansible/group_vars/all/vault_encrypted.yaml
```

### Playbook Import

Playbooks import the vault file and include the role:

```yaml
# playbooks/laptop.yaml
- hosts: localhost
  connection: local
  vars_files:
    - "{{ ansible_facts.env.HOME }}/.dotfiles/ansible/group_vars/all/vault_encrypted.yaml"
  roles:
    - system/users
```

### Adding a New Distribution

1. Create `tasks/<distro>.yaml` with user creation tasks using the `users` variable
2. Add the include condition to `tasks/main.yaml`
3. Add the distribution to `meta/main.yaml` platforms list

## Dependencies

- **Ansible Collections**: `ansible.builtin` (core)
- **OS Detection**: The role relies on `is_arch`, `is_debian`, `is_ubuntu`, `is_opensuse` facts set by the bootstrap playbook or group_vars
- **Package Management**: Sudo installation is handled by the `system/package_management` role

## Related Roles

| Role                        | Relationship                                               |
| --------------------------- | ---------------------------------------------------------- |
| `system/package_management` | Installs sudo, shells, and other prerequisites             |
| `system/security/ssh`       | SSH server hardening (complementary to SSH key management) |
| `system/security/firewall`  | Firewall rules (may need to allow SSH access for users)    |
| `core/dotfiles`             | Deploys user dotfiles after user accounts exist            |

## Troubleshooting

### Common Issues

**User already exists with different UID/GID**

- Use `uid` in user definition to enforce specific IDs
- Or remove the user first with `state: absent` and recreate

**Password hashing fails**

- Ensure `python3-passlib` or `python3-crypt` is installed on the control node
- The `password_hash` filter requires the `passlib` library

**SSH key generation fails**

- Ensure `ssh-keygen` is available on the target system
- Check that `~/.ssh` directory has correct permissions (700)

**"useradd: group X does not exist"**

- Define the group in `user_groups` before referencing it in user `groups`
- Or ensure the group is created by another role (e.g., Docker group)

### Debugging

Run the role with increased verbosity:

```bash
ansible-playbook playbooks/laptop.yaml -vvv --tags users
```

Check the resulting user configuration on the target system:

```bash
id geoff
groups geoff
getent passwd geoff
sudo -l -U geoff
```

## Development

### Adding Features

1. Define the variable schema in this README
2. Add default values in `group_vars/all/vault_unencrypted.yaml`
3. Implement the tasks in the OS-specific task files
4. Add tests or validation in the playbook

### Testing

Test the role against a VM or container:

```bash
# Test user creation (check mode)
ansible-playbook -i inventory/test.yaml playbooks/test-users.yaml --check

# Apply to local machine
ansible-playbook playbooks/bootstrap.yaml --tags users
```
