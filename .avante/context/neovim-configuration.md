---
title: "Neovim Configuration"
description: "Comprehensive Neovim setup with avante.nvim AI integration, LSP, and 35+ plugins for development productivity"
tags: [neovim, editor, ai, lsp, plugins, configuration]
category: "Development Tools"
created: "2026-04-19"
last_edited: "2026-04-19"
version: "1.0"
author: "Geoff"
status: "Published"
---

# Neovim Configuration

## Overview
This document describes the Neovim configuration setup, which serves as the primary development environment with full AI integration via avante.nvim. The configuration includes 35+ plugins for LSP, completion, debugging, UI enhancements, and AI-assisted development.

## Configuration Structure

### Directory Layout
```
.config/nvim/
├── init.lua                    # Main entry point
├── lua/geoff/                  # Custom configuration modules
│   ├── core/                   # Core Neovim settings
│   │   ├── options.lua        # Basic editor options
│   │   ├── keymaps.lua        # Key mappings
│   │   ├── autocommands.lua   # Auto commands
│   │   └── colorscheme.lua    # Theme configuration
│   └── plugins/               # Plugin configurations
│       ├── init.lua           # Plugin manager setup (lazy.nvim)
│       ├── lsp.lua            # LSP configuration
│       ├── avante.lua         # AI assistant configuration
│       ├── deepseek-budget.lua # DeepSeek API budget plugin
│       └── [35+ plugin configs]
└── .env                       # Environment variables (API keys)
```

### Core Philosophy
- **Lua-First**: All configuration written in Lua for performance and maintainability
- **Modular Design**: Each component is independently configurable
- **AI Integration**: Deep integration with avante.nvim for AI-assisted development
- **Performance Focus**: Optimized startup time and responsiveness

## Key Components

### 1. Plugin Management (lazy.nvim)
- **Manager**: lazy.nvim for fast, lazy-loaded plugins
- **Plugin Count**: 35+ carefully selected plugins
- **Loading Strategy**: Lazy loading by event or command
- **Update Frequency**: Regular updates with version locking

### 2. AI Integration (avante.nvim)
- **Primary Provider**: DeepSeek via OpenAI-compatible API
- **ACP Providers**: Gemini, Claude, Goose, Codex, Kimi
- **RAG Service**: Enabled with DeepSeek embeddings
- **Custom Tools**:
  - `neovim_messages`: View Neovim message history
  - `neovim_echo`: Test echo functionality
  - `dotfiles_stow`: Manage dotfiles with GNU Stow

### 3. LSP and Completion
- **LSP Servers**: Mason-managed servers for Python, Lua, JavaScript, etc.
- **Completion**: nvim-cmp with multiple sources (LSP, buffer, path)
- **Formatting**: Built-in LSP formatting and external formatters
- **Diagnostics**: Real-time error checking and linting

### 4. UI and Appearance
- **Theme**: Custom colorscheme configuration
- **Status Line**: lualine.nvim with custom components
- **File Explorer**: nvim-tree for file navigation
- **Buffer Management**: bufferline.nvim for tab management
- **Indentation Guides**: indent-blankline.nvim

### 5. Development Tools
- **Debugging**: nvim-dap with UI and Python support
- **Git Integration**: gitsigns.nvim and lazygit.nvim
- **Treesitter**: Syntax highlighting and text objects
- **Telescope**: Fuzzy finding and search
- **Commenting**: comment.nvim for easy code comments

## Plugin Categories

### Core & Foundation
- `lazy.nvim` - Plugin manager
- `nvim-lspconfig` - LSP configuration
- `mason.nvim` - LSP server management

### UI & Appearance
- `alpha.nvim` - Startup screen
- `bufferline.nvim` - Buffer/tab management
- `lualine.nvim` - Status line
- `nvim-tree.lua` - File explorer
- `indent-blankline.nvim` - Indentation guides

### Navigation & Search
- `telescope.nvim` - Fuzzy finder
- `which-key.nvim` - Keybinding help
- `vim-maximizer` - Window management

### Editing & Text Manipulation
- `nvim-autopairs` - Auto-pairing
- `comment.nvim` - Code commenting
- `nvim-surround` - Surround text operations
- `nvim-treesitter` - Syntax parsing

### Git Integration
- `gitsigns.nvim` - Git signs in gutter
- `lazygit.nvim` - Lazygit integration

### LSP & Completion
- `nvim-cmp` - Completion engine
- `mason.nvim` - LSP server installer
- `nvim-lspconfig` - LSP configuration

### Debugging
- `nvim-dap` - Debug adapter protocol
- `nvim-dap-ui` - Debug UI
- `nvim-dap-python` - Python debugging

### AI & Productivity
- `avante.nvim` - AI assistant
- `todo-comments.nvim` - TODO highlighting
- `auto-session.nvim` - Session management

### Markdown & Documentation
- `markdown-toc` - Table of contents
- `markview` - Markdown preview
- `nvim-docs-view` - Documentation viewer

### Database & DevOps
- `dadbod.nvim` - Database client
- `lazydocker.nvim` - Docker management
- `dotenv.nvim` - Environment variable management

## AI Configuration Details

### avante.nvim Setup
```lua
-- Primary configuration in .config/nvim/lua/geoff/plugins/avante.lua
{
  enabled = true,
  provider = "deepseek",
  api_key = os.getenv("DEEPSEEK_API_KEY"),
  rag_service = {
    enabled = true,
    runner = "podman",  -- Fixed to work with podman
    port = 20250
  },
  rules = {
    enabled = true,
    global_rules_dir = vim.fn.stdpath("config") .. "/avante/rules",
    project_rules_dir = ".avante/rules"
  },
  custom_tools = {
    "neovim_messages",
    "neovim_echo",
    "dotfiles_stow"
  }
}
```

### DeepSeek Budget Plugin
- **Purpose**: Display API balance in status line
- **Location**: `.config/nvim/lua/geoff/plugins/deepseek-budget/`
- **Features**: Real-time balance, color-coded warnings, automatic refresh
- **Integration**: Shows in lualine status bar

## Keybindings Reference

### Leader Key
- **Leader**: `<Space>` (primary leader key)
- **Local Leader**: `,` (plugin-specific bindings)

### Common Operations
- **File Operations**: `<Leader>ff` (find files), `<Leader>fg` (live grep)
- **Buffer Management**: `<Leader>bd` (delete buffer), `<Leader>bn` (next buffer)
- **LSP Actions**: `gd` (go to definition), `gr` (find references)
- **AI Commands**: Configured through avante.nvim interface

## Environment Configuration

### API Keys
Stored in `.config/nvim/.env`:
```
DEEPSEEK_API_KEY=your_deepseek_api_key_here
TAVILY_API_KEY=your_tavily_api_key_here
```

### RAG Service Fix
Due to avante.nvim limitations with podman:
1. Created symlink: `~/.local/bin/docker -> /usr/bin/podman`
2. Patched avante.nvim to treat "podman" as "docker" runner
3. RAG service runs on port 20250 with DeepSeek embeddings

## Source Code References

### Primary Repositories
- **Neovim**: https://github.com/neovim/neovim
- **lazy.nvim**: https://github.com/folke/lazy.nvim
- **avante.nvim**: https://github.com/yetone/avante.nvim
- **nvim-lspconfig**: https://github.com/neovim/nvim-lspconfig
- **mason.nvim**: https://github.com/williamboman/mason.nvim

### Key Plugin Repositories
- **telescope.nvim**: https://github.com/nvim-telescope/telescope.nvim
- **nvim-cmp**: https://github.com/hrsh7th/nvim-cmp
- **nvim-tree.lua**: https://github.com/nvim-tree/nvim-tree.lua
- **lualine.nvim**: https://github.com/nvim-lualine/lualine.nvim
- **nvim-dap**: https://github.com/mfussenegger/nvim-dap

## Maintenance and Updates

### Regular Tasks
1. Update plugins: `:Lazy update`
2. Check LSP server updates: `:MasonUpdate`
3. Verify API connectivity for AI services
4. Test custom tools and RAG service
5. Review and optimize configuration

### Troubleshooting
- **Plugin Issues**: Check `:Lazy log` and `:Lazy profile`
- **LSP Problems**: Run `:LspInfo` and `:LspLog`
- **AI Service**: Verify API keys and RAG container status
- **Performance**: Use `:StartupTime` to profile startup

## Related Documents
- [avante.nvim Setup](./avante-nvim-setup.md) - Detailed AI configuration
- [Development Workflow](./development-workflow.md) - Daily development processes
- [Screen Capture System](../system/screen-capture-system.md) - Integration with editor

---

*This configuration represents a comprehensive Neovim setup optimized for AI-assisted development on Arch Linux with Hyprland. Last updated: 2026-04-19*

