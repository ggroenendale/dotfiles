# Ansible SSH Role

This role installs and configures OpenSSH (both server and client) on **Arch Linux**, **Debian**, **openSUSE**, and **Ubuntu**. It uses each distribution’s native package manager and service management, and includes optional hardening with `fail2ban`.

## Role Variables

All variables are optional and can be set in `group_vars`, `host_vars`, or via `vars` files.

| Variable            | Default | Description                                                                                                                                  |
| ------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `install_ssh_utils` | `false` | Install additional SSH‑related packages (`sshpass`, `mosh`, `sshfs`, `rsync`). ⚠️ `sshpass` is insecure – use only in isolated environments. |
| `configure_client`  | `false` | Deploy a templated `~/.ssh/config` file for the user running Ansible.                                                                        |
| `ssh_fail2ban`      | `false` | Install and configure `fail2ban` to protect SSH against brute‑force attacks.                                                                 |

## Role Structure

```tree
roles/ssh/
├── tasks/
│ ├── main.yml # Conditionally includes OS‑specific files
│ ├── arch.yml
│ ├── debian.yml
│ ├── opensuse.yml
│ └── ubuntu.yml
├── handlers/
│ └── main.yml # Restart sshd and fail2ban
├── templates/
│ ├── sshd_config.j2 # Server configuration
│ └── ssh_client_config.j2 # Client configuration (optional)
├── defaults/
│ └── main.yml # Default variable values
└── README.md
```

## Included Functionality

### Common to all distributions

- Install `openssh` (server and client)
- Create `/etc/ssh` directory with correct permissions
- Deploy `sshd_config.j2` template (secure defaults)
- Enable `sshd` service (start on boot)
- Generate all missing host keys (`ssh-keygen -A`)
- Start the SSH daemon

### Distribution‑specific notes

- **Arch Linux**
  - Package manager: `pacman` (no `update_cache` – dangerous on Arch)
  - Service name: `sshd`
  - fail2ban config: `/etc/fail2ban/jail.d/sshd.conf`

- **Debian**
  - Package manager: `apt` (with `update_cache: yes`)
  - Service name: `sshd` (alias; `ssh` also works)
  - fail2ban config: `/etc/fail2ban/jail.d/sshd.conf`

- **openSUSE**
  - Package manager: `zypper`
  - Service name: `sshd`
  - fail2ban config: `/etc/fail2ban/jail.d/sshd.conf`

- **Ubuntu** (special considerations)
  - Package manager: `apt` (with `update_cache: yes`)
  - Service name: **`ssh`** (the `sshd` alias was removed in Ubuntu 24.04+)
  - fail2ban config: `/etc/fail2ban/jail.local` (Ubuntu convention)
  - Default `sshd_config` includes `Include /etc/ssh/sshd_config.d/*.conf` – the role overwrites the main file intentionallye.

### Optional client configuration (`configure_client: true`)

- Creates `~/.ssh` and `~/.ssh/controlmasters` directories
- Deploys `~/.ssh/config` from `ssh_client_config.j2`
- The template includes sane security defaults (e.g., `PasswordAuthentication no`, connection multiplexing)

### Optional fail2ban hardening (`ssh_fail2ban: true`)

- Installs `fail2ban`
- Creates `/etc/fail2ban/jail.d/sshd.conf` (3 retries → 1 hour ban)
- Enables and starts the `fail2ban` service

## Handlers

- `Restart SSH` – restarts `sshd`
- `Restart fail2ban` – restarts `fail2ban`

## Template Customization

### `sshd_config.j2` – Recommended minimal settings

```jinja
# {{ ansible_managed }}
Port {{ ssh_port | default(22) }}
PermitRootLogin prohibit-password
PubkeyAuthentication yes
PasswordAuthentication {{ ssh_password_auth | default('no') }}
ChallengeResponseAuthentication no
AllowUsers {{ ssh_allowed_users | default([]) | join(' ') }}
Subsystem sftp /usr/lib/ssh/sftp-server

```

> Adjust variables like ssh_port or ssh_password_auth in your inventory.

### ssh_client_config.j2 – Example host block

```
Host work-server
    HostName 192.168.1.100
    User ansible
    IdentityFile ~/.ssh/id_ed25519_work
```

You can extend the template with loops, e.g.:

```
{% for host, config in ssh_client_hosts.items() %}
Host {{ host }}
    HostName {{ config.hostname }}
    User {{ config.user }}
{% endfor %}
```

### Example Usage

```yaml
- hosts: all
  roles:
    - role: ssh
      vars:
        install_ssh_utils: true
        configure_client: true
        ssh_fail2ban: true
        ssh_port: 2222
        ssh_allowed_users:
          - alice
          - bob
```

## References

### OpenSSH

- [OpenSSH Project](https://www.openssh.com/)
- [Arch Wiki: OpenSSH](https://wiki.archlinux.org/title/OpenSSH)
- [Debian Wiki: SSH](https://wiki.debian.org/SSH)
- [Ubuntu SSH Documentation](https://ubuntu.com/server/docs/service-openssh)
- [openSUSE SSH Guide](https://en.opensuse.org/Portal:OpenSSH)

### fail2ban

- [fail2ban Project](https://www.fail2ban.org/)
- [Arch Wiki: fail2ban](https://wiki.archlinux.org/title/Fail2ban)
- [DigitalOcean: How to Protect SSH with fail2ban](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-20-04)

### Ansible Modules

- [`pacman` module](https://docs.ansible.com/ansible/latest/collections/community/general/pacman_module.html)
- [`apt` module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html)
- [`zypper` module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/zypper_module.html)
- [`systemd` module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/systemd_module.html)
- [`template` module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)

## Security Hardening Tips

- **Disable password authentication** (`PasswordAuthentication no`) – force key‑based logins.
- **Change the default SSH port** to reduce automated attacks.
- **Use `AllowUsers`** to restrict login to specific users.
- **Enable fail2ban** (`ssh_fail2ban: true`) to block repeated failures.
- **Set `PermitRootLogin prohibit-password`** (or `no`) – never allow root login with a password.
- **Use `ed25519` host keys** – modern, small, and secure. The role generates all key types by default.

## Known Limitations

- The role does not manage known_hosts or authorized_keys files. Use a separate role (e.g., users) for public key deployment.
- sshpass is optional but insecure – use only in throwaway containers or test labs.
- On Arch Linux, update_cache is never used – the role relies on the user keeping their system up‑to‑date separately.
- The role uses the correct service name per distribution, but mixing distributions in the same playbook run requires proper when: conditions (already handled by the role’s conditional includes).
- On Ubuntu, the sshd service alias is not available from 24.04 onward; the role uses ssh to remain compatible.

## License

MIT

## Maintainer

Geoff Groenendale
