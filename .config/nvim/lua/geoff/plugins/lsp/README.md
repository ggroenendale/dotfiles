# LSP Plugin Configuration

This directory contains Language Server Protocol (LSP) related plugin configurations. LSP provides features like code completion, diagnostics, go-to-definition, and more for various programming languages.

## Table of Contents
- [Files](#files)
- [Mason Package Manager](#mason-package-manager)
- [Installed LSP Servers](#installed-lsp-servers)
- [Installed Tools](#installed-tools)
- [LSP Server Configurations](#lsp-server-configurations)
- [Usage Notes](#usage-notes)
- [Troubleshooting](#troubleshooting)

## Files

- **[mason.lua](mason.lua)** - Mason package manager configuration
- **[lspconfig.lua](lspconfig.lua)** - LSP server configurations

## Mason Package Manager

Mason is a package manager for LSP servers, linters, formatters, and debuggers. It automatically installs and manages language servers.

### Configuration Overview

The `mason.lua` file configures:
1. **Mason UI** - Package installation status icons
2. **Automatic installation** - Automatically installs LSP servers
3. **Tool installer** - Installs formatters, linters, and debuggers

### Installed LSP Servers

The following LSP servers are configured to be automatically installed:

#### Web Development
- `html` - HTML language server
- `cssls` - CSS language server
- `somesass_ls` - Sass/SCSS language server
- `css_variables` - CSS custom properties support
- `cssmodules_ls` - CSS Modules support
- `unocss` - UnoCSS utility-first CSS framework
- `eslint` - JavaScript/TypeScript linting
- `jsonls` - JSON language server
- `graphql` - GraphQL language server

#### Python
- `pylsp` - Python language server (with Jedi)
- `ruff` - Python linter and formatter

#### Lua
- `lua_ls` - Lua language server

#### Databases & DevOps
- `dockerls` - Dockerfile language server
- `docker_compose_language_service` - Docker Compose support
- `nginx_language_server` - Nginx configuration support
- `sqlls` - SQL language server
- `lemminx` - XML language server

#### Markdown
- `markdown_oxide` - Markdown language server

### Installed Tools

The following tools are installed via Mason Tool Installer:

#### Formatters
- `prettier` - JavaScript/TypeScript/CSS/HTML formatter
- `stylua` - Lua formatter
- `black` - Python formatter
- `htmlbeautifier` - HTML formatter

#### Linters
- `eslint_d` - Fast ESLint daemon
- `htmlhint` - HTML linter
- `biome` - JavaScript/JSON linter and formatter
- `pydocstyle` - Python docstring linter

#### Debuggers
- `debugpy` - Python debugger

#### Utilities
- `jupytext` - Jupyter notebook tools

## LSP Configuration

The `lspconfig.lua` file configures individual LSP servers with specific settings for each language.

### Key Features

1. **Automatic Attachment** - LSP servers automatically attach to relevant file types
2. **Enhanced Diagnostics** - Custom diagnostic symbols and hover windows
3. **Signature Help** - Function signature help with `lsp_signature.nvim`
4. **File Operations** - Enhanced file operations with `nvim-lsp-file-operations`
5. **Neodev Integration** - Better Lua development experience with `neodev.nvim`

### Server-Specific Configurations

#### Python (pylsp)
- Uses Jedi for code completion and navigation
- Configured to work with virtual environments
- Pycodestyle with custom ignore patterns
- Disabled redundant linters (pylint, mypy, flake8, etc.)

#### Lua (lua_ls)
- Special workspace configuration for Neovim development
- Recognizes `vim` global variable
- Proper runtime version (LuaJIT)

#### Markdown (markdown_oxide)
- Markdown-specific editor settings
- Enhanced navigation for wrapped lines

#### Docker (dockerls)
- Supports both `Dockerfile` and `ContainerFile` file types

#### GraphQL (graphql)
- Supports multiple file types including React components

#### Ruff (ruff)
- Python linter with custom ignore patterns
- Integrated as both linter and formatter

### Diagnostic Configuration

Custom diagnostic symbols are configured:
- Error: ``
- Warning: ``
- Info: `󰋼`
- Hint: `󰌵`

Hover documentation windows have rounded borders and a maximum width of 80 characters.

## Keybindings

LSP keybindings are configured in `../core/keymaps.lua`. Common LSP commands include:

### Navigation
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gt` - Go to type definition
- `gR` - Show references

### Actions
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `K` - Hover documentation

### Diagnostics
- `<leader>D` - Show buffer diagnostics
- `<leader>d` - Show line diagnostics
- `[d`/`]d` - Previous/next diagnostic
- `<leader>rs` - Restart LSP

## Usage Notes

### Virtual Environments (Python)
The Python LSP is configured to detect and use virtual environments:
1. Looks for `.venv` directory in project root
2. Automatically sets `VIRTUAL_ENV` environment variable
3. Configures Python executable path for the LSP server

### Customizing LSP Servers
To add or modify LSP server configurations:

1. **Add to mason.lua** - Add server name to `ensure_installed` list
2. **Configure in lspconfig.lua** - Add server configuration block
3. **Restart Neovim** or run `:LspRestart`

### Troubleshooting

If an LSP server isn't working:

1. **Check installation**: `:Mason` to see if server is installed
2. **Check attachment**: `:LspInfo` to see if server is attached to buffer
3. **Check logs**: `:messages` for error messages
4. **Check file type**: `:set filetype?` to ensure correct file type detection

### Updating Servers
- Update all Mason packages: `:MasonUpdate`
- Update specific server: `:MasonInstall <server-name>`
- Check for updates: `:MasonCheckUpdates`

## Dependencies

- `mason.nvim` - Package manager
- `mason-lspconfig.nvim` - Bridge between Mason and lspconfig
- `mason-tool-installer.nvim` - Tool installer
- `nvim-lspconfig` - LSP configuration framework
- `cmp-nvim-lsp` - Completion source for nvim-cmp
- `lsp_signature.nvim` - Signature help
- `nvim-lsp-file-operations` - Enhanced file operations
- `neodev.nvim` - Better Lua development

