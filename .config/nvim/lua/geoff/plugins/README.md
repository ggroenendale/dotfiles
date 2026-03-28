# Plugin Configuration Directory

This directory contains all plugin configurations for the Neovim setup. Each plugin has its own `.lua` file that defines its setup, configuration, and keybindings.

## Table of Contents
- [Directory Structure](#directory-structure)
- [Plugin Categories](#plugin-categories)
- [Adding New Plugins](#adding-new-plugins)
- [Plugin Management](#plugin-management)
- [Troubleshooting](#troubleshooting)

## Directory Structure

```
plugins/
├── README.md                    # This file
├── init.lua                    # Base plugins (plenary.nvim, vim-tmux-navigator)
├── lsp/                        # LSP-related plugins
│   ├── mason.lua              # Mason package manager
│   ├── lspconfig.lua          # LSP server configurations
│   └── README.md              # LSP plugins documentation
├── credentials/                # Database credentials (gitignored)
│   ├── db_credentials.lua     # Database credentials
│   ├── db_credentials-sample.lua # Sample credentials template
│   └── README.md              # Credentials documentation
└── *.lua                      # Individual plugin configuration files
```

## Plugin Categories

### Core & Foundation
- **[init.lua](init.lua)** - Essential foundation plugins
  - `plenary.nvim` - Lua functions library used by many plugins
  - `vim-tmux-navigator` - Seamless navigation between tmux and Neovim splits

### UI & Appearance
- **[alpha.lua](alpha.lua)** - Startup dashboard with custom layout
- **[bufferline.lua](bufferline.lua)** - Tab/buffer line at the top
- **[colorscheme.lua](colorscheme.lua)** - Color scheme configuration (tokyonight)
- **[dressing.lua](dressing.lua)** - Improved UI for inputs and selects
- **[indent-blankline.lua](indent-blankline.lua)** - Indentation guides
- **[lualine.lua](lualine.lua)** - Customizable status line
- **[nvim-tree.lua](nvim-tree.lua)** - File explorer sidebar
- **[transparent.lua](transparent.lua)** - Transparent background support

### Navigation & Search
- **[telescope.lua](telescope.lua)** - Fuzzy finder with fzf extension
- **[which-key.lua](which-key.lua)** - Keybinding helper and discoverability
- **[vim-maximizer.lua](vim-maximizer.lua)** - Window maximize/minimize toggle

### Editing & Text Manipulation
- **[autopairs.lua](autopairs.lua)** - Auto-pair brackets, quotes, etc.
- **[comment.lua](comment.lua)** - Comment toggling with `gc` operator
- **[surround.lua](surround.lua)** - Surround text with characters/tags
- **[treesitter.lua](treesitter.lua)** - Syntax highlighting and parsing

### Git Integration
- **[gitsigns.lua](gitsigns.lua)** - Git signs in gutter with hunk navigation
- **[lazygit.lua](lazygit.lua)** - LazyGit terminal UI integration

### LSP & Completion
- **[nvim-cmp.lua](nvim-cmp.lua)** - Auto-completion engine
- See [lsp/README.md](lsp/README.md) for LSP-specific plugins

### Debugging
- **[nvim-dap.lua](nvim-dap.lua)** - Debug Adapter Protocol client
- **[nvim-dap-ui.lua](nvim-dap-ui.lua)** - Debugger UI
- **[nvim-dap-python.lua](nvim-dap-python.lua)** - Python debugging configuration

### Diagnostics & Code Quality
- **[trouble.lua](trouble.lua)** - Diagnostic viewer with quickfix integration
- **[linting.lua](linting.lua)** - Linting configuration
- **[formatting.lua](formatting.lua)** - Code formatting configuration

### AI & Productivity
- **[avante.lua](avante.lua)** - AI coding assistant integration
- **[todo-comments.lua](todo-comments.lua)** - TODO comment highlighting and navigation
- **[auto-session.lua](auto-session.lua)** - Session management and restoration

### Markdown & Documentation
- **[markdown-toc.lua](markdown-toc.lua)** - Markdown table of contents generator
- **[markview.lua](markview.lua)** - Markdown preview functionality
- **[nvim-docs-view.lua](nvim-docs-view.lua)** - Documentation viewer

### Database & DevOps
- **[dadbod.lua](dadbod.lua)** - Database client with UI
- **[lazydocker.lua](lazydocker.lua)** - Docker management terminal UI
- **[dotenv.lua](dotenv.lua)** - .env file support and management

## Adding New Plugins

When adding a new plugin:

1. **Create a new `.lua` file** in this directory
2. **Follow the existing pattern** - each file should return a table with plugin configuration
3. **Add keybindings** if needed (update `../core/keymaps.lua`)
4. **Update documentation** in the main README.md and this file
5. **Test the plugin** functionality

### Example Plugin Structure

```lua
return {
    "author/plugin-name",
    version = "*", -- or specific version
    dependencies = {
        "other/required-plugin",
    },
    config = function()
        -- Plugin configuration here
        require("plugin").setup({
            -- configuration options
        })

        -- Keybindings (if plugin-specific)
        vim.keymap.set("n", "<leader>xx", "<cmd>PluginCommand<cr>", { desc = "Plugin description" })
    end,
}
```

## Plugin Management

Plugins are managed by [Lazy.nvim](https://github.com/folke/lazy.nvim). The plugin manager is configured in `../lazy.lua`.

### Common Commands
- `:Lazy` - Open plugin manager UI
- `:Lazy update` - Update all plugins
- `:Lazy check` - Check for plugin updates
- `:Lazy clean` - Remove unused plugins
- `:Lazy sync` - Install missing plugins

## Troubleshooting

If a plugin isn't working:

1. **Check installation**: `:Lazy status` to see if plugin is installed
2. **Check configuration**: Verify the plugin's `.lua` file syntax
3. **Check dependencies**: Ensure all required dependencies are installed
4. **Check conflicts**: Look for conflicting keybindings or settings
5. **Check logs**: Use `:messages` to see error messages

## Notes

- Plugin files are loaded alphabetically by Lazy.nvim
- Dependencies are automatically resolved by Lazy.nvim
- Each plugin should be as self-contained as possible
- Keybindings that are plugin-specific can be defined in the plugin file
- Keybindings that are part of the core workflow should be added to `../core/keymaps.lua`

