# Firewall Role

This Ansible role configures host‑based firewalls on supported Linux distributions using their default firewall management tools:

| Distribution | Firewall Tool | Module / Method              |
| ------------ | ------------- | ---------------------------- |
| Arch Linux   | nftables      | Native nftables ruleset file |
| Debian       | UFW           | ufw Ansible module           |
| openSUSE     | firewalld     | firewalld Ansible module     |
| Ubuntu       | UFW           | ufw Ansible module           |

A conditional main playbook includes the appropriate OS‑specific task file based on ansible_os_family and ansible_distribution.

## Role Structure

```tree
roles/
└── firewall/
├── tasks/
│ ├── main.yml
│ ├── arch.yml
│ ├── debian.yml
│ ├── opensuse.yml
│ └── ubuntu.yml
└── handlers/
└── main.yml
```

The main.yml task file includes the appropriate OS‑specific firewall configuration based on distribution detection.

## 1. Arch Linux — nftables

Arch Linux uses nftables directly. The tasks install the nftables package, enable its systemd service, and deploy a basic ruleset file.

### nftables Background

nftables is the modern Linux packet‑filtering framework that replaces the legacy iptables, ip6tables, arptables, and ebtables tools. It has been the default firewall backend on Arch Linux since 2019 and on most major distributions (Debian 10+, Ubuntu 20.04+, RHEL 8+, Fedora 18+).
Key features over iptables:

    Unified IPv4/IPv6 – Single inet family handles both protocols

    Atomic rule updates – Loading an entire ruleset with nft -f happens in one transaction (no downtime)

    Built‑in sets and maps – O(1) lookups instead of linear evaluation; verdict maps allow one rule to handle many ports

    Simpler syntax – nft add rule inet filter input tcp dport 80 accept vs the flag‑heavy iptables equivalent

    Note: The Arch iptables package now defaults to an nftables backend (iptables-nft), which can be confusing. This role uses native nftables directly for clarity and future‑proofing.

Useful nftables commands:

| Command                                               | Description                     |
| ----------------------------------------------------- | ------------------------------- |
| `nft list ruleset`                                    | Display current ruleset         |
| `nft flush ruleset`                                   | Delete all rules                |
| `nft -f /etc/nftables.conf`                           | Load rules from file atomically |
| `nft add rule inet filter input tcp dport 443 accept` | Add HTTPS rule dynamically      |
| `nft delete rule inet filter input handle <handle>`   | Delete rule by its handle       |

Tip: You can get rule handles with nft -a list ruleset.

## 2. Debian / Ubuntu — UFW (Uncomplicated Firewall)

Debian and Ubuntu use UFW (Uncomplicated Firewall), a user‑friendly frontend to nftables (or legacy iptables). Default policies are set to deny incoming traffic, allow outgoing, and block forwarded traffic. An explicit rule allows SSH.

Note: UFW is the default firewall configuration tool on Ubuntu and Debian. While designed primarily for host‑based firewalls, it can also manage more complex routing configurations.

### UFW Background

UFW (Uncomplicated Firewall) is a frontend for managing a netfilter firewall. It was developed by the Ubuntu community to make iptables configuration easier and more user‑friendly. Modern versions can use either iptables or nftables as the underlying backend.

#### Key UFW commands:

| Command                      | Description                      |
| ---------------------------- | -------------------------------- |
| `ufw enable` / `ufw disable` | Turn firewall on/off             |
| `ufw status verbose`         | Show current rules and defaults  |
| `ufw allow 80/tcp`           | Allow HTTP traffic               |
| `ufw deny 22`                | Block SSH (use with caution)     |
| `ufw delete deny 22`         | Remove a rule                    |
| `ufw --dry-run allow http`   | Preview changes without applying |
| `ufw reset`                  | Reset to installation defaults   |

The default log location for UFW is /var/log/ufw.log.

## 3. openSUSE — firewalld

openSUSE uses firewalld – a dynamic firewall management daemon that implements zone‑based security policies.

Task file: firewall_opensuse.yml
yaml

### firewalld Background

firewalld is a dynamic firewall management service that allows configuration changes without interrupting existing connections. It uses a zone‑based model where each zone represents a different level of trust.
Zones:

firewalld comes with several predefined zones:

- drop – Drops all incoming packets (stealth mode)
- block – Rejects connections with an ICMP message
- public – For untrusted public networks (default on many systems)
- home / internal – For more trusted environments
- trusted – Accepts all traffic

In the public zone, all incoming connections are rejected by default unless explicitly allowed.

#### Key commands:

| Command                                       | Description                        |
| --------------------------------------------- | ---------------------------------- |
| `firewall-cmd --get-default-zone`             | Show current default zone          |
| `firewall-cmd --set-default-zone=home`        | Change default zone                |
| `firewall-cmd --add-service=http --permanent` | Allow HTTP permanently             |
| `firewall-cmd --reload`                       | Apply permanent rules              |
| `firewall-cmd --list-all`                     | Show active rules for current zone |

## References

### nftables

- [ArchWiki: nftables](https://wiki.archlinux.org/title/Nftables) – Official Arch Linux documentation
- [nftables Wiki](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page) – Project documentation
- [nft(8) man page](https://man.archlinux.org/man/nft.8) – Complete command reference
- [nftables vs iptables (2026)](https://dargslan.com/blog/nftables-vs-iptables-2026-comparison-migration-guide) – Detailed comparison and migration guide

### UFW

- [Ubuntu Firewall Documentation](https://ubuntu.com/server/docs/security-firewall) – Official Ubuntu guide
- [ufw(8) man page](https://manpages.ubuntu.com/manpages/jammy/man8/ufw.8.html) – Complete UFW manual
- [Community Help Wiki: UFW](https://help.ubuntu.com/community/UFW) – General UFW usage

### firewalld

- [SUSE: Introduction to firewalld](https://documentation.suse.com/sles-sap/16.0/html/SAP-intro-firewalld/index.html) – Official SUSE documentation
- [firewalld Project](https://firewalld.org/) – Upstream project home
- [firewall-cmd(1) man page](https://firewalld.org/documentation/man-pages/firewall-cmd.html) – Command reference

### Ansible Modules

- [`iptables` module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/iptables_module.html) – Direct iptables management
- [`ufw` module](https://docs.ansible.com/ansible/latest/collections/community/general/ufw_module.html) – UFW management
- [`firewalld` module](https://docs.ansible.com/ansible/latest/collections/ansible/posix/firewalld_module.html) – firewalld management

## Customisation

Adding extra allowed ports

For nftables (Arch), add lines inside the input chain of /etc/nftables.conf:
text

tcp dport 80 accept
tcp dport 443 accept

For UFW (Debian/Ubuntu), additional ufw tasks can be added before enabling the firewall:

```yaml
- name: Allow HTTP and HTTPS
  ufw:
  rule: allow
  port: "{{ item }}"
  proto: tcp
  loop: [80, 443]
```

For firewalld (openSUSE), use the firewalld module to enable services or direct ports:

```yaml
- name: Allow HTTP service
  firewalld:
  service: http
  permanent: yes
  immediate: yes
  state: enabled
```

Changing SSH port

If your SSH daemon listens on a non‑standard port, update the port number in the firewall rules accordingly:

- Arch: Replace tcp dport 22 accept in /etc/nftables.conf with your port number.
- Debian/Ubuntu: Update the port: '22' parameter in the ufw allow task.
- openSUSE: Either change the firewalld service rule to target a custom port instead of the ssh service, or add a direct port rule.

## Testing

Before applying firewall changes in production, consider using --check mode to preview changes:
bash

ansible-playbook --check --diff main.yml

For systems where firewall changes could lock you out (e.g., remote servers), consider these safeguards:

- Keep an existing SSH session open while testing.
- Use a serial console or out‑of‑band management for recovery.
- Test in a staging environment first, especially on Arch Linux where the nftables service is not enabled by default.

## License

MIT

## Maintainer

Geoff Groenendale
