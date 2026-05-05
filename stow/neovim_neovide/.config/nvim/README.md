# Neovim Configuration

## Table of Contents
- [Introduction](#introduction)
- [Configuration Structure](#configuration-structure)
- [Plugin Configuration Files](#plugin-configuration-files)
- [Surrounding Characters/Tags](#surrounding-characterstags)
- [Keybind Reference](#keybind-reference)
- [Getting Started](#getting-started)
- [Plugin Management](#plugin-management)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Introduction

---

Most of the configurations for neovim found in this repository come from this video:

https://www.youtube.com/watch?v=6pAG3BHurdM

As well as from this blog from the same creator:

https://www.josean.com/posts/how-to-setup-neovim-2024

## Configuration Structure

This Neovim configuration is organized into a modular structure for easy maintenance and navigation:

```
.config/nvim/
├── init.lua                    # Main entry point
├── lazy.lua                    # Plugin manager configuration
├── lazy-lock.json              # Plugin lock file
├── .env                        # Environment variables
├── test_alpha_fix.lua          # Alpha dashboard test file
├── keyboard-shortcuts-analysis.md  # Keybind analysis
├── README.md                   # This file
└── lua/geoff/
    ├── lazy.lua                # Lazy.nvim setup
    ├── core/                   # Core configuration
    │   ├── init.lua           # Core initialization
    │   ├── options.lua        # Neovim options
    │   ├── keymaps.lua        # Key mappings
    │   ├── gui.lua            # GUI-specific settings
    │   └── gui-context-menu.lua # GUI context menu
    └── plugins/               # Plugin configurations
        ├── init.lua           # Base plugins
        ├── lsp/               # LSP configurations
        │   ├── mason.lua      # Mason package manager
        │   └── lspconfig.lua  # LSP server configurations
        └── credentials/       # Database credentials (gitignored)
```

## Plugin Configuration Files

### Core Plugins
- **[init.lua](lua/geoff/plugins/init.lua)** - Base plugins (plenary.nvim, vim-tmux-navigator)

### UI & Appearance
- **[alpha.lua](lua/geoff/plugins/alpha.lua)** - Startup dashboard
- **[bufferline.lua](lua/geoff/plugins/bufferline.lua)** - Buffer/tab line
- **[colorscheme.lua](lua/geoff/plugins/colorscheme.lua)** - Color scheme configuration
- **[dressing.lua](lua/geoff/plugins/dressing.lua)** - Improved UI for inputs and selects
- **[indent-blankline.lua](lua/geoff/plugins/indent-blankline.lua)** - Indentation guides
- **[lualine.lua](lua/geoff/plugins/lualine.lua)** - Status line
- **[nvim-tree.lua](lua/geoff/plugins/nvim-tree.lua)** - File explorer
- **[transparent.lua](lua/geoff/plugins/transparent.lua)** - Transparent background

### Navigation & Search
- **[telescope.lua](lua/geoff/plugins/telescope.lua)** - Fuzzy finder
- **[which-key.lua](lua/geoff/plugins/which-key.lua)** - Keybinding helper
- **[vim-maximizer.lua](lua/geoff/plugins/vim-maximizer.lua)** - Window maximize/minimize

### Editing & Text Manipulation
- **[autopairs.lua](lua/geoff/plugins/autopairs.lua)** - Auto-pair brackets, quotes, etc.
- **[comment.lua](lua/geoff/plugins/comment.lua)** - Comment toggling
- **[surround.lua](lua/geoff/plugins/surround.lua)** - Surround text with characters/tags
- **[treesitter.lua](lua/geoff/plugins/treesitter.lua)** - Syntax highlighting and parsing

### Git Integration
- **[gitsigns.lua](lua/geoff/plugins/gitsigns.lua)** - Git signs in gutter
- **[lazygit.lua](lua/geoff/plugins/lazygit.lua)** - LazyGit integration

### LSP & Completion
- **[nvim-cmp.lua](lua/geoff/plugins/nvim-cmp.lua)** - Auto-completion
- **[lsp/mason.lua](lua/geoff/plugins/lsp/mason.lua)** - LSP package manager
- **[lsp/lspconfig.lua](lua/geoff/plugins/lsp/lspconfig.lua)** - LSP server configurations

### Debugging
- **[nvim-dap.lua](lua/geoff/plugins/nvim-dap.lua)** - Debug Adapter Protocol
- **[nvim-dap-ui.lua](lua/geoff/plugins/nvim-dap-ui.lua)** - DAP UI
- **[nvim-dap-python.lua](lua/geoff/plugins/nvim-dap-python.lua)** - Python debugging

### Diagnostics & Troubleshooting
- **[trouble.lua](lua/geoff/plugins/trouble.lua)** - Diagnostic viewer
- **[linting.lua](lua/geoff/plugins/linting.lua)** - Linting configuration
- **[formatting.lua](lua/geoff/plugins/formatting.lua)** - Code formatting

### AI & Productivity
- **[avante.lua](lua/geoff/plugins/avante.lua)** - AI coding assistant
- **[todo-comments.lua](lua/geoff/plugins/todo-comments.lua)** - TODO comment highlighting
- **[auto-session.lua](lua/geoff/plugins/auto-session.lua)** - Session management

### Markdown & Documentation
- **[markdown-toc.lua](lua/geoff/plugins/markdown-toc.lua)** - Markdown table of contents
- **[markview.lua](lua/geoff/plugins/markview.lua)** - Markdown preview
- **[nvim-docs-view.lua](lua/geoff/plugins/nvim-docs-view.lua)** - Documentation viewer

### Database & DevOps
- **[dadbod.lua](lua/geoff/plugins/dadbod.lua)** - Database client
- **[lazydocker.lua](lua/geoff/plugins/lazydocker.lua)** - Docker management
- **[dotenv.lua](lua/geoff/plugins/dotenv.lua)** - .env file support

### Core Configuration Files
- **[core/init.lua](lua/geoff/core/init.lua)** - Core initialization
- **[core/options.lua](lua/geoff/core/options.lua)** - Neovim options and settings
- **[core/keymaps.lua](lua/geoff/core/keymaps.lua)** - Key mappings and shortcuts
- **[core/gui.lua](lua/geoff/core/gui.lua)** - GUI-specific settings (Neovide)
- **[core/gui-context-menu.lua](lua/geoff/core/gui-context-menu.lua)** - GUI context menu configuration

## Surrounding Characters/Tags

Some notes on creating surrounding characters for things like html tags, double quotes,
brackets, etc.

|Old text                 |Command     |New text              |
|-------------------------|------------|----------------------|
|surr*ound_words          |ysiw)       |(surround_words)      |
|*make strings            |ys$\"        |\"make strings\"        |
|[delete ar*ound me!]     |ds]         |delete around me!     |
|remove \<b>HTML t*ags\</b> |dst         |remove HTML tags      |
|'change quot*es'         |cs'\"        |\"change quotes\"       |
|\<b>or tag* types\</b>     |csth1<CR> |\<h1>or tag types\</h1> |
|delete(functi*on calls)  |dsf         |function calls        |

> Thanks to - https://github.com/kylechui/nvim-surround

## Keybind Reference

### Core Keybinds
- **Insert Mode**: `jk` → Exit insert mode
- **Search**: `<leader>nh` → Clear search highlights
- **Numbers**: `<leader>+` → Increment, `<leader>-` → Decrement
- **Window Management**:
  - `<leader>sv` → Split vertically
  - `<leader>sh` → Split horizontally
  - `<leader>se` → Equalize splits
  - `<leader>sx` → Close current split
- **Tab Management**:
  - `<leader>to` → New tab
  - `<leader>tx` → Close tab
  - `<leader>tn` → Next tab
  - `<leader>tp` → Previous tab
  - `<leader>tf` → Open buffer in new tab
- **LSP Navigation**:
  - `gd` → Go to definition
  - `gD` → Go to type definition
  - `gi` → Go to implementation

### Telescope
- `<leader>ff` → Find files
- `<leader>fr` → Find recent files
- `<leader>fs` → Live grep (find string)
- `<leader>fc` → Grep string under cursor
- `<leader>ft` → Find todos
- **Telescope UI**: `<C-k>`/`<C-j>` → Navigate results, `<C-q>` → Send to quickfix

### File Explorer (nvim-tree)
- `<leader>ee` → Toggle file explorer
- `<leader>ef` → Toggle explorer on current file
- `<leader>ec` → Collapse explorer
- `<leader>er` → Refresh explorer

### AI Assistant (avante.nvim)
- `<leader>aa` → Ask Avante
- `<leader>ae` → Edit with Avante
- `<leader>ar` → Refresh sidebar
- `<leader>af` → Focus sidebar
- **Sidebar**: `<C-CR>` → Apply text, `<C-r>` → Retry, `q` → Close

### Git Operations
- **LazyGit**: `<leader>gl` → Open LazyGit
- **Git Signs**:
  - `]h`/`[h` → Next/previous hunk
  - `<leader>hs` → Stage hunk
  - `<leader>hr` → Reset hunk
  - `<leader>hS` → Stage buffer
  - `<leader>hR` → Reset buffer
  - `<leader>hu` → Undo stage hunk
  - `<leader>hp` → Preview hunk
  - `<leader>hb` → Blame line
  - `<leader>hB` → Toggle line blame
  - `<leader>hd` → Diff this
  - `<leader>hD` → Diff this ~

### Diagnostics (Trouble)
- `<leader>xw` → Workspace diagnostics
- `<leader>xd` → Document diagnostics
- `<leader>xq` → Quickfix list
- `<leader>xl` → Location list
- `<leader>xt` → Todos

### LSP & Diagnostics
- `gR` → Show LSP references
- `gD` → Go to declaration
- `gd` → Show LSP definitions
- `gi` → Show LSP implementations
- `gt` → Show LSP type definitions
- `<leader>ca` → Code actions
- `<leader>rn` → Smart rename
- `<leader>D` → Show buffer diagnostics
- `<leader>d` → Show line diagnostics
- `[d`/`]d` → Previous/next diagnostic
- `K` → Hover documentation
- `<leader>rs` → Restart LSP

### Formatting & Linting
- **Formatting**: `<leader>mp` → Format file/range
- **Linting**: `<leader>l` → Trigger linting

### Session Management
- `<leader>wr` → Restore session
- `<leader>ws` → Save session

### Todo Comments
- `]t` → Next todo
- `[t` → Previous todo

### Window Management
- **Maximizer**: `<leader>sm` → Toggle maximize/minimize split

### Database
- `<leader>db` → Open DBUI

### Docker
- `<leader>ld` → Open Lazydocker

### Leader Key Patterns
- `<leader>s` → Split/window operations
- `<leader>t` → Tab operations
- `<leader>g` → Git operations
- `<leader>h` → Git hunk operations
- `<leader>x` → Trouble diagnostics
- `<leader>a` → Avante AI
- `<leader>e` → File explorer
- `<leader>f` → Telescope find
- `<leader>w` → Session management
- `<leader>l` → Linting
- `<leader>m` → Formatting
- `<leader>d` → Database

> Note: All keybinds use `<leader>` = space key

## Getting Started

1. **Clone the repository** to your Neovim config directory
2. **Install Neovim** (version 0.9 or higher recommended)
3. **Install a Nerd Font** (e.g., JetBrainsMono Nerd Font)
4. **Start Neovim** - plugins will be automatically installed via Lazy.nvim
5. **Configure environment variables** in `.env` if needed

## Plugin Management

This configuration uses [Lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management. Plugins are defined in individual files in the `lua/geoff/plugins/` directory.

- To update plugins: `:Lazy update`
- To check for updates: `:Lazy check`
- To clean unused plugins: `:Lazy clean`

## Troubleshooting

If you encounter issues:
1. Check the Neovim messages with `:messages`
2. Verify plugin installation with `:Lazy status`
3. Check LSP server status with `:LspInfo`
4. Review the [keyboard-shortcuts-analysis.md](keyboard-shortcuts-analysis.md) for keybind conflicts

## Contributing

When adding new plugins:
1. Create a new `.lua` file in `lua/geoff/plugins/`
2. Follow the existing pattern for plugin configuration
3. Add appropriate keybindings to `core/keymaps.lua` if needed
4. Update this README with the new plugin information
