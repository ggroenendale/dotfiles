# Core Neovim Configuration

This directory contains the core configuration files for Neovim. These files define the fundamental settings, keybindings, and behaviors that form the foundation of the editor.

## Table of Contents
- [Files](#files)
- [Configuration Overview](#configuration-overview)
- [Configuration Philosophy](#configuration-philosophy)
- [Customization Guide](#customization-guide)
- [Key Concepts](#key-concepts)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)
- [Integration with Plugins](#integration-with-plugins)

## Files

- **[init.lua](init.lua)** - Core initialization and module loading
- **[options.lua](options.lua)** - Neovim options and settings
- **[keymaps.lua](keymaps.lua)** - Key mappings and shortcuts
- **[gui.lua](gui.lua)** - GUI-specific settings (Neovide)
- **[gui-context-menu.lua](gui-context-menu.lua)** - GUI context menu configuration

## Configuration Overview

### 1. init.lua
The main initialization file that loads all core modules in the correct order:

```lua
-- Load core options and keymaps
require("geoff.core.options")
require("geoff.core.keymaps")

-- Load GUI configuration if running in GUI mode
if vim.g.neovide or vim.fn.has("gui_running") == 1 then
    require("geoff.core.gui").setup()
end
```

### 2. options.lua
Contains all Neovim option settings including:

#### Editor Behavior
- Line numbers (hybrid mode)
- Tab and indentation settings
- Search behavior (case-insensitive unless uppercase)
- Clipboard integration
- Undo and backup settings

#### UI Configuration
- Syntax highlighting
- Cursor behavior
- Sign column
- Color scheme settings
- Terminal behavior

#### Performance
- Swap file settings
- Undo persistence
- Completion behavior

### 3. keymaps.lua
Defines all key mappings organized by functionality:

#### Leader Key
The leader key is set to space: `vim.g.mapleader = " "`

#### Navigation
- Window navigation (`<C-h/j/k/l>`)
- Buffer navigation (`<leader>h/l`)
- Tab navigation (`<leader>tn/tp`)

#### Editing
- Save operations (`<leader>w`)
- Search and replace (`<leader>s`)
- Comment toggling (`<leader>/`)

#### Plugin Integration
Keybindings for various plugins including:
- Telescope (fuzzy finder)
- Nvim-tree (file explorer)
- LazyGit
- Trouble (diagnostics)
- Avante (AI assistant)

#### LSP Commands
- Code actions (`<leader>ca`)
- Rename (`<leader>rn`)
- Diagnostics navigation (`[d`/`]d`)

### 4. gui.lua
GUI-specific configuration for Neovide:

#### Visual Settings
- Font configuration (JetBrainsMono Nerd Font)
- Window opacity
- Cursor settings
- Scroll animation

#### Performance
- GPU acceleration settings
- Multigrid support
- Refresh rate

#### Input
- Keyboard settings
- Mouse behavior
- Touchpad support

### 5. gui-context-menu.lua
Custom right-click context menu for GUI versions:

#### Menu Items
- File operations (New, Open, Save)
- Editing commands (Cut, Copy, Paste)
- Search functions
- Plugin shortcuts
- Window management

## Configuration Philosophy

### Modular Design
Each configuration file has a single responsibility:
- `options.lua` - Only Neovim options
- `keymaps.lua` - Only key mappings
- `gui.lua` - Only GUI-specific settings

### Plugin-Agnostic Core
The core configuration focuses on Neovim's built-in functionality. Plugin-specific configurations are kept in the `plugins/` directory.

### Consistent Keybinding Patterns
Keybindings follow consistent patterns:
- `<leader>s` - Split/window operations
- `<leader>t` - Tab operations
- `<leader>g` - Git operations
- `<leader>f` - Find operations (Telescope)

## Customization Guide

### Adding New Options
To add new Neovim options, edit `options.lua`:

```lua
-- Add to options.lua
vim.opt.new_option = value
```

### Adding New Keybindings
To add new keybindings, edit `keymaps.lua`:

```lua
-- Add to keymaps.lua
vim.keymap.set("mode", "keys", "command", { desc = "Description" })
```

### GUI Customization
To modify GUI settings, edit `gui.lua`:

```lua
-- Add to gui.lua setup function
vim.g.neovide_setting = value
```

## Key Concepts

### Leader Key
The leader key (`<leader>`) is a modifier key that enables mnemonic key combinations. It's set to space for easy access.

### Which-Key Integration
Keybindings are designed to work with `which-key.nvim` which shows available keybindings after pressing the leader key.

### Mode-Specific Mappings
Keybindings are defined for specific modes:
- `"n"` - Normal mode
- `"v"` - Visual mode
- `"i"` - Insert mode
- `"t"` - Terminal mode

### Buffer-Local Mappings
Some mappings are buffer-local (especially LSP mappings) and only apply to specific file types.

## Troubleshooting

### Keybinding Conflicts
If a keybinding doesn't work:
1. Check for conflicts with `:verbose map <keys>`
2. Verify the mode (normal, visual, insert)
3. Check if a plugin is overriding the mapping

### Option Issues
If an option isn't taking effect:
1. Check syntax in `options.lua`
2. Verify the option name with `:help option-name`
3. Check for plugin overrides

### GUI Issues
If GUI features aren't working:
1. Verify you're running in GUI mode (`:echo vim.g.neovide`)
2. Check font installation
3. Verify Neovide version compatibility

## Best Practices

### 1. Keep Options Organized
Group related options together with comments:
```lua
-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
```

### 2. Use Descriptive Keybinding Descriptions
Always include descriptions for keybindings to help with which-key integration:
```lua
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
```

### 3. Test Changes Incrementally
After modifying core configuration:
1. Test individual changes
2. Check for conflicts
3. Verify plugin compatibility

### 4. Document Customizations
Add comments explaining why non-standard options are set:
```lua
-- Enable mouse for easier scrolling in terminals
vim.opt.mouse = "a"
```

## Integration with Plugins

The core configuration works with plugins by:

1. **Setting up prerequisites** - Options that plugins depend on
2. **Defining keybindings** - Global keybindings that trigger plugin functions
3. **Providing context** - Settings that affect plugin behavior

Plugins should not modify core settings directly but should be configured in their respective files in the `plugins/` directory.

