# Roles Overview

## Table of Contents

## Overview

The struggle I have had with determining a good role layout is that if you don't at the very least
have some kind of parent role structure to the softwares you install you quickly end up with a hundred
or more folders each named with a different software that you will forget the purpose of months later
when you go to clean up your ansible installation or setup a new machine or playbook. For example: how
do you easily remember that bind9 and unbound are tools to create your own local web domains when
developing websites for your home network? I'm not always going to remember that mako and fuzzel are
part of my hyprland desktop environment setup, and I might use different notification and run menu
solutions depending on the linux distribution I am using.

The roles also need to be easily separated by machine type. I have 3 primary systems: desktop, laptop,
and server. The desktop and laptop installations are the same for the most part with the exception
of desktops generally having more powerful components for things like gaming, designing, and development.
The server roles need to be separate enough so they can easily be ignored in the laptop and desktop roles,
but also when a server sets up a network service such as samba or kubernetes, their needs to be client
tasks to connect the desktop and laptops to.

My solution was to break things up. Starting with system, desktop environment, and desktop applications.
This separation allowed me to keep system configuration (bootloader, file system, networking) separate from
the desktop environment design (hyprland, waybar, awww & waypaper) and desktop applications (gimp, firefox,
steam, etc.). Then to solve the different machine types notably with a homelab, I defined server and client
roles next. The server roles would setup various services on Debian systems, notably kubernetes, gitea, and
samba. The client roles would then setup any tools to use those services (kubectl, k9s) or log into and
configure connections to those services (gitea, samba, etc.). I then deciced to create a role entirely
for developer tooling setup. I needed a space to be more specific than desktop applications as I use a wide
array of command line and cloud tools. Next came hardware specific roles. This allowed me to configure
specific bits of code for bluetooth settings, special mouse or keyboard scripts, and graphics drivers.

The last remaining hurdle was handling dependencies. Using role/meta/main.yaml files I began organizing
dependencies for each role and the problem I came across was how do I organize common dependencies
like rust, python, or git. I created a "common" role to attempt to address this. It still becomes
a headache for the order of operations. When setting up a system git is one of the first things needed
to get additional software installed, but we also want to setup ssh and firewall early.

## Role Inventory

### System Roles

#### Bootloader

Installing GRUB and my specific theme for GRUB as well as customizing the config
depending on the display is handled here.

#### File System

This is where btrfs is setup. Should this also include fzf and other command line tools?

#### Security

Within security we install ssh and firewall.

#### Networking

This role contains a series of sub roles as there is a lot to manage within networking. Networkmanager and wifi
settings are managed here as

### Core Roles

### Hardware Roles

### Desktop Environment Roles

### Desktop Application Roles

### Developer Roles

### Server Roles

### Client Roles

## Full Tree Hierarchy

```
ansible/roles/
├── core/                          # Foundation roles (every machine)
│   ├── base_packages/             # Essential system packages
│   ├── users/                     # User accounts and groups
│   ├── security/                  # SSH hardening, fail2ban, firewall
│   ├── systemd/                   # Systemd service management
│   ├── dotfiles/                  # Dotfiles deployment via stow
│   ├── fonts/                     # Font Installation
│   └── package_management/        # AUR helper (paru) installation
│
├── hardware/                      # Hardware-specific roles
│   ├── bluetooth/                 # Bluetooth stack
│   ├── peripherals/               # Input devices (solaar, etc.)
│   ├── graphics/                  # GPU drivers (nvidia)
│   └── audio/                     # PipeWire/WirePlumber
│
├── system/                        # System-level configuration
│   ├── bootloader/                # GRUB bootloader
│   ├── file_system/               # BTRFS, LVM, btrbk
│   └── networking/                # NetworkManager, firewall, DHCP, DNS
│
├── desktop/                       # Desktop environment roles
│   ├── hyprland/                  # Hyprland compositor
│   ├── wayland/                   # Wayland infrastructure (if needed)
│   ├── widgets/                   # EWW widgets
│   ├── login_manager/             # GDM/SDDM display manager
│   ├── notifications/             # Mako notification daemon
│   ├── clipboard/                 # Cliphist clipboard manager
│   ├── wallpaper/                 # swww wallpaper manager
│   ├── run_menu/                  # Fuzzel application launcher
│   ├── terminals/                 # WezTerm terminal emulator
│   ├── task_bar/                  # Waybar status bar
│   ├── authentication/            # Polkit authentication agent
│   ├── theme/                     # GTK colorscheme and theming
│   └── file_managers/             # Thunar file manager
│
├── desktop_applications/          # Desktop Application roles
│   ├── blender/                   # Blender 3d modeling
│   ├── brave/                     # Brave Browser
│   ├── firefox/                   # Firefox Browser
│   └── gimp/                      # Gimp Image Editing
│
├── dev/                           # Development tool roles
│   ├── build_tools/               # make, cmake, gcc, base-devel
│   ├── ide/                       # Neovim, lazygit
│   ├── version_control/           # Git configuration
│   └── containers/                # Docker, Podman, Docker Compose
│
├── server/                        # Server-specific roles
│   ├── network_storage/           # Samba client and server
│   ├── cluster/                   # Kubernetes (k3s/kubeadm)
│   │   ├── master/                # Control plane setup
│   │   ├── worker/                # Worker node setup
│   │   ├── client/                # kubectl, kubeadm, kubelet
│   │   ├── helm/                  # Helm package manager
│   │   └── containers/            # libvirt/KVM, container hosts
│   └── ai/                        # AI/LLM infrastructure
│       ├── inference_engine/      # Model serving
│       ├── models/                # Model management
│       └── mcp_server/            # MCP server deployment
```

### Missing meta analysis:

#### system

system/networking/dhcp/meta
system/networking/dns/meta
system/networking/networkmanager/meta
system/networking/vpn/meta
system/networking/wifi/meta
system/bootloader
system/file_system
system/package_management/meta
system/base_packages/tasks
system/users
system/security/firewall/meta
system/security/ssh/meta
system/systemd

#### desktop

desktop/hyprland
desktop/wallpaper/meta
desktop/theme
desktop/notifications
desktop/file_managers
desktop/terminals
desktop/widgets
desktop/task_bar
desktop/run_menu
desktop/clipboard
desktop/authentication
desktop/wayland/meta

#### dev

dev/build_tools/python
dev/build_tools/yaml
dev/build_tools/ruby
dev/build_tools/rust
dev/build_tools/terraform
dev/ide
dev/version_control/meta

#### core

core/fonts
core/package_management
core/dotfiles

#### hardware

hardware/bluetooth
hardware/mouse
hardware/graphics/meta
hardware/audio

#### desktop_applications

desktop_applications/firefox
desktop_applications/brave
desktop_applications/gimp
desktop_applications/blender
desktop_applications/librewolf
desktop_applications/zen_browser
desktop_applications/freecad/meta
desktop_applications/inkscape/meta
desktop_applications/steam
desktop_applications/video_player
desktop_applications/zoom
desktop_applications/notes

#### server

server/network_storage
server/cluster
server/cluster/helm
server/cluster/client
server/cluster/master
server/cluster/worker
server/cluster/containers
server/ai
server/ai/inference_engine
server/ai/mcp_server
server/ai/models
server/services/pxe_server
server/services/git_server
server/services/spark
