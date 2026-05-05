---
title: "Dotfiles Repository - System Architecture"
description: "Comprehensive technical architecture of the dotfiles repository system"
tags: [architecture, system-design, dotfiles, hyprland, neovim, ai-integration]
category: "System Architecture"
created: "2026-04-21"
last_edited: "2026-04-21"
version: "1.0"
author: "Geoff"
status: "Published"
---

# Dotfiles Repository - System Architecture

## Overview

This document describes the comprehensive system architecture of the dotfiles repository, which provides a complete personal computing environment for Arch Linux with Hyprland/Wayland, Neovim with AI integration, and custom productivity tools.

## Architectural Principles

### Core Design Principles
1. **Modularity**: Each component is independently configurable and replaceable
2. **AI-First Development**: Deep integration with AI assistants for enhanced productivity
3. **Wayland Native**: Built exclusively for modern Wayland compositors
4. **Developer Productivity**: Optimized for software development workflows
5. **Reproducibility**: System can be fully reproduced from the repository

### System Philosophy
- **Configuration as Code**: All system settings are version-controlled
- **Minimal Dependencies**: Prefer built-in tools over external dependencies
- **Cross-Component Integration**: Components work together seamlessly
- **Extensibility**: Easy to add new tools and configurations

## High-Level Architecture

### System Components Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    User Interface Layer                      │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Neovim  │  │  Waybar  │  │  Fuzzel  │  │  Mako    │   │
│  │ (Editor) │  │ (Status) │  │ (Launcher)│  │(Notifier)│   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
├─────────────────────────────────────────────────────────────┤
│                 Desktop Environment Layer                    │
├─────────────────────────────────────────────────────────────┤
│                    Hyprland (Wayland Compositor)             │
├─────────────────────────────────────────────────────────────┤
│                     System Services Layer                    │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Screen  │  │   AI     │  │  System  │  │  Bash    │   │
│  │ Capture  │  │ Services │  │ Provision│  │  Shell   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
├─────────────────────────────────────────────────────────────┤
│                     Operating System Layer                   │
├─────────────────────────────────────────────────────────────┤
│                    Arch Linux (Base System)                  │
└─────────────────────────────────────────────────────────────┘
```

## Component Architecture

### 1. Desktop Environment (Hyprland)

#### Core Components
- **Hyprland**: Wayland compositor providing window management
- **Configuration**: `~/.config/hypr/hyprland.conf`
- **Key Features**:
  - Tiling window management
  - Custom keybindings for developer workflow
  - Screen capture integration
  - Multi-monitor support

#### Integration Points
- **Waybar**: Status bar integration via IPC
- **Screen Capture**: Keybindings for screenshot/recording
- **Neovim**: Workspace management integration

### 2. Neovim Editor with AI Integration

#### Core Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                    Neovim Core                               │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ avante   │  │  LSP     │  │  Treesit │  │  UI/UX   │   │
│  │ (AI)     │  │  System  │  │  (Syntax)│  │  Plugins │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
├─────────────────────────────────────────────────────────────┤
│                    Plugin Management                         │
├─────────────────────────────────────────────────────────────┤
│                    lazy.nvim (Plugin Manager)                │
└─────────────────────────────────────────────────────────────┘
```

#### AI Integration Stack
- **avante.nvim**: Primary AI assistant framework
- **RAG Service**: Context retrieval with DeepSeek embeddings
- **Multiple LLM Providers**: DeepSeek, Gemini, Claude, Goose, Codex, Kimi
- **Custom Tools**: Debugging, message handling, dotfiles management

#### Plugin Categories
1. **Core & Foundation**: lazy.nvim, mason.nvim, nvim-lspconfig
2. **UI & Appearance**: alpha.nvim, bufferline.nvim, lualine.nvim
3. **Navigation & Search**: telescope.nvim, nvim-tree.lua
4. **Editing & Text Manipulation**: nvim-surround, comment.nvim
5. **Git Integration**: gitsigns.nvim, lazygit.nvim
6. **Debugging**: nvim-dap, nvim-dap-ui
7. **AI & Productivity**: avante.nvim, todo-comments.nvim

### 3. Screen Capture System

#### Architecture Overview
```
┌─────────────────────────────────────────────────────────────┐
│                    User Interface                            │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Waybar   │  │  Hyprland│  │  Fuzzel  │  │  Bash    │   │
│  │ Button   │  │ Keybinds │  │  Menu    │  │  Aliases │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
├─────────────────────────────────────────────────────────────┤
│                    Capture Engine                            │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │   grim   │  │  slurp   │  │ wf-record│  │wl-clipboard│  │
│  │(Screensh)│  │ (Region) │  │ (Record) │  │(Clipboard)│  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
├─────────────────────────────────────────────────────────────┤
│                    Storage & Organization                    │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Screenshots│ │Recordings│ │Date-based │ │File Naming│   │
│  │ Directory │ │ Directory│ │ Structure │ │  System   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
```

#### Capture Modes
1. **Full Screen Capture**: Entire screen to clipboard/file
2. **Region Selection**: Interactive area selection with slurp
3. **Active Window**: Capture focused window using hyprctl
4. **Screen Recording**: Video capture with wf-recorder

#### Integration Points
- **Waybar**: Custom module with left/right click actions
- **Hyprland**: Global keybindings (PRINT, SHIFT+PRINT, etc.)
- **Bash**: Command-line aliases and functions

### 4. AI Services Architecture

#### RAG Service Implementation
```
┌─────────────────────────────────────────────────────────────┐
│                    avante.nvim                               │
├─────────────────────────────────────────────────────────────┤
│                    RAG Client                                │
├─────────────────────────────────────────────────────────────┤
│                    HTTP API (Port 20250)                     │
├─────────────────────────────────────────────────────────────┤
│                    RAG Service Container                     │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  LLM     │  │Embedding │  │ Vector   │  │ Context  │   │
│  │ (DeepSeek)│ │ Model    │  │  Store   │  │ Retrieval│   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
```

#### Service Components
- **Container Runtime**: Podman (with Docker compatibility layer)
- **API Endpoint**: HTTP REST API on port 20250
- **LLM Provider**: DeepSeek API with configurable models
- **Embedding Model**: DeepSeek embeddings for context retrieval

### 5. Bash Shell Environment

#### Configuration Structure
```
┌─────────────────────────────────────────────────────────────┐
│                    .bashrc (Main Entry)                      │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Paths   │  │  Aliases │  │  DevTools│  │ Functions│   │
│  │ (10-*)   │  │  (20-*)  │  │  (30-*)  │  │  (40-*)  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
├─────────────────────────────────────────────────────────────┤
│                    Environment Variables                     │
├─────────────────────────────────────────────────────────────┤
│                    Custom Scripts (.my_scripts/)             │
└─────────────────────────────────────────────────────────────┘
```

#### Modular Components
1. **Paths Configuration**: System and custom PATH settings
2. **Aliases**: Shortcuts for common commands
3. **Development Tools**: Language-specific configurations
4. **Custom Functions**: Screen capture, system utilities

## Data Flow and Integration

### Screen Capture Workflow
1. **User Action**: Press PRINT key or click Waybar button
2. **Hyprland**: Captures keybinding and executes script
3. **Capture Script**: Calls grim/slurp/wf-recorder
4. **Processing**: Saves file, copies to clipboard, shows notification
5. **Feedback**: Desktop notification confirms capture

### AI Assistant Workflow
1. **User Request**: Type `:AIChat` or use keybinding in Neovim
2. **Context Gathering**: avante.nvim collects relevant context
3. **RAG Query**: Optional context retrieval from RAG service
4. **LLM Processing**: Send request to configured provider
5. **Response Handling**: Display response in Neovim buffer

### Dotfiles Management Workflow
1. **Configuration Change**: Edit file in `~/.dotfiles/`
2. **Stow Application**: Run `dotfiles_stow` tool from avante.nvim
3. **Symlink Creation**: GNU Stow creates symlinks in home directory
4. **Verification**: Check symlinks and test functionality

## Directory Structure Details

### Repository Root (`~/.dotfiles/`)
```
.dotfiles/
├── .config/                    # User configuration files
│   ├── nvim/                  # Neovim configuration (primary focus)
│   │   ├── lua/geoff/        # Custom Lua modules
│   │   │   ├── core/         # Core Neovim configuration
│   │   │   ├── plugins/      # Plugin configurations
│   │   │   └── keymaps/      # Key mappings
│   │   └── init.lua          # Neovim entry point
│   ├── hypr/                  # Hyprland configuration
│   │   ├── hyprland.conf     # Main configuration
│   │   ├── hyprlock.conf     # Lock screen
│   │   └── hyprpaper.conf    # Wallpaper
│   ├── waybar/               # Status bar configuration
│   │   ├── config.jsonc      # Module configuration
│   │   └── style.css         # Styling
│   ├── bash/                 # Bash configuration
│   │   ├── 00-env.sh         # Environment variables
│   │   ├── 10-paths.sh       # PATH configuration
│   │   ├── 20-aliases.sh     # Command aliases
│   │   ├── 30-devtools.sh    # Development tools
│   │   ├── 40-scripts.sh     # Custom scripts
│   │   └── 50-functions.sh   # Bash functions
│   └── [other configs]/      # Additional configurations
├── .local/bin/               # User scripts and binaries
│   └── screenshot-scripts/   # Screen capture system
│       ├── screenshot-*.sh   # Screenshot scripts
│       ├── screenrecord-*.sh # Recording scripts
│       └── README.md         # Documentation
├── ansible/                  # System provisioning
│   └── playbooks/           # Ansible playbooks
├── .avante/                  # AI project management
│   ├── context/             # Project context documents
│   │   ├── INDEX.md         # Main index (this file's parent)
│   │   ├── ARCHITECTURE.md  # This architecture document
│   │   └── [other docs]/    # Additional context
│   ├── plans/               # Project plans and tracking
│   │   ├── current.md       # Active work log
│   │   └── project-plan.md  # Project planning
│   └── rules/               # Project-specific AI rules
│       ├── *.avanterules    # Rule files
│       └── [custom rules]/  # Additional rules
└── [various files]/         # Individual configuration files
```

## Technology Stack

### Core Technologies
- **Operating System**: Arch Linux (rolling release)
- **Display Protocol**: Wayland (modern display protocol)
- **Compositor**: Hyprland (tiling Wayland compositor)
- **Editor**: Neovim (0.10.0+) with Lua configuration
- **Shell**: Bash 5.2+ with modular configuration
- **Container Runtime**: Podman 5.8+ (with Docker compatibility)

### AI/ML Stack
- **AI Framework**: avante.nvim (Neovim AI assistant)
- **Primary LLM**: DeepSeek API (deepseek-chat model)
- **Embedding Model**: DeepSeek embeddings
- **RAG Service**: Custom container with vector storage
- **Alternative Providers**: Gemini, Claude, Goose, Codex, Kimi

### Screen Capture Tools
- **Screenshots**: grim (Wayland screenshot utility)
- **Region Selection**: slurp (region selector for Wayland)
- **Screen Recording**: wf-recorder (Wayland screen recorder)
- **Clipboard**: wl-clipboard (Wayland clipboard utilities)

### Development Tools
- **Version Control**: Git with custom configuration
- **Package Management**: paru (AUR helper), pacman
- **System Provisioning**: Ansible
- **Dotfiles Management**: GNU Stow

## Configuration Management

### Symlink Management
- **Tool**: GNU Stow
- **Strategy**: Package-based symlinking
- **Ignore Patterns**: `.stow-local-ignore` for repository files
- **Custom Tool**: `dotfiles_stow` in avante.nvim

### Environment Variables
- **Location**: `.config/nvim/.env` (Neovim), `.config/bash/00-env.sh` (Bash)
- **Security**: API keys stored in environment variables
- **Loading**: Automatic loading via dotenv.nvim plugin

### Version Control Strategy
- **Repository**: Single git repository for all configurations
- **Branch Strategy**: Main branch with feature branches
- **Commit Convention**: Descriptive commits with context
- **Documentation**: AGENTS.md for agent operation history

## Security Architecture

### API Key Management
- **Storage**: Environment variables (not in version control)
- **Loading**: Secure loading via dotenv.nvim
- **Rotation**: Manual rotation as needed
- **Scope**: Minimal required permissions

### Container Security
- **Runtime**: Podman with rootless containers
- **Network**: Isolated container network
- **Resources**: Limited resource allocation
- **Updates**: Regular container updates

### System Security
- **Permissions**: Principle of least privilege
- **Authentication**: System-level authentication
- **Monitoring**: Basic system monitoring
- **Updates**: Regular Arch Linux updates

## Performance Considerations

### Startup Performance
- **Neovim**: Lazy loading of plugins with lazy.nvim
- **Hyprland**: Optimized configuration for fast startup
- **Bash**: Modular loading to reduce startup time
- **Services**: On-demand startup for AI services

### Resource Usage
- **Memory**: Monitoring of container and service memory usage
- **CPU**: Efficient screen capture and AI processing
- **Disk**: Organized storage with cleanup policies
- **Network**: Efficient API calls with caching

### Optimization Strategies
- **Caching**: API response caching where appropriate
- **Lazy Loading**: On-demand loading of components
- **Connection Pooling**: Reusable connections for services
- **Batch Processing**: Grouped operations where possible

## Scalability and Extensibility

### Adding New Components
1. **Configuration Files**: Add to appropriate `.config/` subdirectory
2. **Scripts**: Add to `.local/bin/` or `.my_scripts/`
3. **Neovim Plugins**: Add configuration to `lua/geoff/plugins/`
4. **AI Rules**: Add `.avanterules` files to `.avante/rules/`
5. **Context Documents**: Add markdown files to `.avante/context/`

### Extension Points
- **New AI Providers**: Add configuration to avante.nvim providers
- **Additional Capture Modes**: Extend screen capture scripts
- **Custom Bash Functions**: Add to `50-functions.sh`
- **System Services**: Add Ansible playbooks for provisioning

## Monitoring and Maintenance

### System Health Monitoring
- **Neovim**: Plugin updates and compatibility checks
- **Hyprland**: Configuration validation and performance
- **AI Services**: API connectivity and response times
- **Screen Capture**: Script functionality and tool availability

### Maintenance Procedures
1. **Regular Updates**: Update Arch Linux packages weekly
2. **Plugin Updates**: Update Neovim plugins as needed
3. **Configuration Review**: Monthly review of all configurations
4. **Backup Verification**: Verify backup integrity monthly
5. **Documentation Updates**: Update context documents with changes

### Troubleshooting Framework
1. **Issue Identification**: Use system logs and error messages
2. **Component Isolation**: Test components independently
3. **Configuration Rollback**: Revert to known working state
4. **Documentation Reference**: Check context documents for solutions
5. **Agent Assistance**: Use avante.nvim for troubleshooting guidance

## Future Architecture Directions

### Planned Enhancements
1. **Enhanced AI Integration**: More sophisticated context retrieval
2. **Multi-Machine Sync**: Synchronization across multiple systems
3. **Advanced Monitoring**: Comprehensive system health dashboard
4. **Automated Testing**: Automated validation of configurations
5. **Mobile Integration**: Integration with mobile devices

### Technical Debt Management
- **Regular Refactoring**: Quarterly architecture review
- **Documentation Updates**: Keep architecture documents current
- **Technology Evaluation**: Regular assessment of new tools
- **Deprecation Planning**: Graceful deprecation of old components

## Conclusion

This architecture provides a comprehensive, modular, and extensible foundation for a personal computing environment optimized for developer productivity with AI integration. The system is designed with clear separation of concerns, well-defined integration points, and robust error handling.

The architecture supports continuous evolution through its modular design, making it easy to add new components, update existing ones, and adapt to changing requirements while maintaining system stability and performance.

---

## Related Documents

- [INDEX.md](./INDEX.md) - Main project index and overview
- [System Overview](./system-overview.md) - High-level system description
- [Neovim Configuration](./neovim-configuration.md) - Detailed editor setup
- [Hyprland Configuration](./hyprland-configuration.md) - Desktop environment setup
- [Screen Capture System](./screen-capture-system.md) - Screenshot/recording system
- [AI Integration](./avante-nvim-setup.md) - AI assistant configuration
- [Development Workflow](./development-workflow.md) - Development processes

## Revision History

| Version | Date       | Changes                          | Author |
|---------|------------|----------------------------------|--------|
| 1.0     | 2026-04-21 | Initial architecture document    | Geoff  |

---

*This architecture document provides a comprehensive technical overview of the dotfiles repository system. Refer to individual component documents for detailed configuration information.*

