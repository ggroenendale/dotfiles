---
title: "Dotfiles Repository - Main Index"
description: "Comprehensive overview of the dotfiles repository for Arch Linux with Hyprland/Wayland, Neovim, and AI integration"
tags: [dotfiles, arch-linux, hyprland, neovim, ai, configuration]
category: "System Configuration"
created: "2026-04-19"
last_edited: "2026-04-21"
version: "1.0"
author: "Geoff"
status: "Published"
---

# Dotfiles Repository - Main Index

## Repository Overview
**Repository Name:** Personal Dotfiles Configuration
**Repository ID:** Proj-DF-001
**Description:** Comprehensive system configuration for Arch Linux with Hyprland/Wayland, Neovim with AI integration, and custom productivity tools
**Status:** Active (continuously maintained)
**Start Date:** 2026-03-19
**Repository Location:** `~/.dotfiles/`

## Core Philosophy
- **Modular Design**: Each component is independently configurable
- **AI-First Development**: Deep integration with avante.nvim for AI-assisted development
- **Wayland Native**: Built for modern Wayland compositors (Hyprland)
- **Productivity Focus**: Custom tools for screen capture, development workflows, and system management

## System Architecture

### Core Components
1. **Desktop Environment**: Hyprland (Wayland compositor)
2. **Editor**: Neovim with avante.nvim AI integration
3. **Status Bar**: Waybar with custom modules
4. **Shell**: Bash with custom functions and aliases
5. **Screen Capture**: Comprehensive screenshot/recording system
6. **System Provisioning**: Ansible playbooks

### AI Integration Stack
- **Primary AI**: avante.nvim with DeepSeek API
- **RAG Service**: Context retrieval with DeepSeek embeddings
- **Multiple Providers**: Gemini, Claude, Goose, Codex, Kimi
- **Custom Tools**: Neovim debugging, message handling, dotfiles management

## Directory Structure

```
.dotfiles/
├── .config/                    # User configuration files
│   ├── nvim/                  # Neovim configuration (primary focus)
│   ├── hypr/                  # Hyprland configuration
│   ├── waybar/                # Waybar configuration
│   └── bash/                  # Bash configuration
├── .local/bin/                # User scripts and binaries
│   └── screenshot-scripts/    # Screen capture system
├── ansible/                   # System provisioning
├── .avante/                   # AI project management
│   ├── context/              # Project context documents (this folder)
│   ├── plans/                # Project plans and tracking
│   └── rules/                # Project-specific AI rules
└── [various config files]    # Individual configuration files
```

## Key Features

### 1. Neovim with AI Integration
- **avante.nvim**: Full AI assistant integration
- **DeepSeek API**: Primary LLM provider
- **RAG Service**: Enhanced context retrieval
- **Custom Tools**: Debugging, message handling, stow management
- **Plugin Ecosystem**: 35+ plugins for development productivity

### 2. Hyprland/Wayland Desktop
- **Hyprland**: Modern Wayland compositor
- **Waybar**: Customizable status bar with screen capture button
- **Screen Capture**: Full suite of screenshot/recording tools
- **Keybindings**: Optimized for developer workflow

### 3. Screen Capture System
- **Multiple Capture Modes**: Full screen, region, active window
- **Screen Recording**: Video capture with wf-recorder
- **Waybar Integration**: One-click access from status bar
- **Organized Storage**: Date-based file naming and directories

### 4. Development Environment
- **Bash Configuration**: Custom functions and aliases
- **Git Integration**: Comprehensive workflow
- **System Tools**: Package management, system monitoring
- **Dotfiles Management**: GNU Stow for symlink management

## Context Documents

### System Configuration
- [System Architecture](./ARCHITECTURE.md) - Comprehensive technical architecture and design
- [Hyprland Configuration](./hyprland-configuration.md) - Desktop environment setup
- [Screen Capture System](./screen-capture-system.md) - Screenshot and recording tools

### Development Tools
- [Neovim Configuration](./neovim-configuration.md) - Editor setup with AI integration
- [Development Workflow](./development-workflow.md) - Daily development processes

### AI Integration
- [avante.nvim Setup](./avante-nvim-setup.md) - AI assistant configuration

### Knowledge Management
- [Lessons Learned](./LESSONS_LEARNED.md) - Collection of insights and best practices
- [Session Logs](./sessions/) - Timestamped records of work sessions

### Templates
- [Metadata Template](./metadata-template.md) - Template for new context documents
  - [Session Template](./sessions/session-template.md) - Template for new session logs

## Source Code References

### External Repositories
- **avante.nvim**: https://github.com/yetone/avante.nvim
- **Hyprland**: https://github.com/hyprwm/Hyprland
- **Waybar**: https://github.com/Alexays/Waybar
- **Neovim**: https://github.com/neovim/neovim
- **GNU Stow**: https://github.com/aspiers/stow

### Key Tools and Libraries
- **grim/slurp**: Wayland screenshot tools
- **wf-recorder**: Wayland screen recording
- **wl-clipboard**: Wayland clipboard utilities
- **fuzzel**: Application launcher (optional)

## Maintenance and Updates

### Regular Maintenance Tasks
1. Update Neovim plugins and configurations
2. Review and optimize Hyprland configuration
3. Test screen capture system functionality
4. Verify AI service connectivity and API keys
5. Update system provisioning scripts

### Update Strategy
- **Incremental Updates**: Small, frequent changes
- **Testing**: Verify changes in isolated environment
- **Documentation**: Update context documents and AGENTS.md
- **Backup**: Maintain backup of critical configurations

## Related Resources

### Documentation
- [AGENTS.md](../AGENTS.md) - Complete history of agent operations
- [README.md](../README.md) - Main repository documentation
- [.avante/plans/](../plans/) - Project plans and active work tracking

### Configuration Files
- [.config/nvim/](../.config/nvim/) - Neovim configuration
- [.config/hypr/](../.config/hypr/) - Hyprland configuration
- [.config/waybar/](../.config/waybar/) - Waybar configuration
- [.config/bash/](../.config/bash/) - Bash configuration

## Contact and Support

### Primary Maintainer
- **Name**: Geoff
- **Role**: System administrator and developer
- **Focus**: AI-assisted development, system configuration, productivity tools

### Issue Tracking
- Use Git issues for bug reports and feature requests
- Document significant changes in AGENTS.md
- Maintain context documents for system understanding

---

*This index document provides an overview of the dotfiles repository. For detailed information on specific components, refer to the individual context documents linked above. Last updated: 2026-04-21*

