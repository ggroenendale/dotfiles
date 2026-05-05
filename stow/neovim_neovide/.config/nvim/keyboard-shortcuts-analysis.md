# Neovim Keyboard Shortcuts Analysis & Productivity Recommendations

## Executive Summary

Based on an analysis of your current Neovim configuration, you have a well-structured setup with many useful plugins. However, there are significant opportunities to improve productivity through better keyboard shortcuts and keymap organization. This report identifies missing keymaps, suggests improvements, and provides recommendations for enhancing your workflow.

## Current Setup Analysis

### Installed Plugins & Keymaps

You have a comprehensive plugin setup including:

**Core Navigation & Search:**
- Telescope (`<leader>ff`, `fr`, `fs`, `fc`, `ft`)
- Nvim-tree (`<leader>ee`, `ef`, `ec`, `er`)
- Vim-tmux-navigator (no explicit keymaps, works with Ctrl+h/j/k/l)

**Version Control:**
- LazyGit (`<leader>gl`)
- Gitsigns (`<leader>hs`, `hr`, `hS`, `hR`, `hu`, `hp`, `hb`, `hB`, `hd`, `hD`)

**LSP & Diagnostics:**
- LSP (`gd`, `gD`, `gi`)
- Trouble (`<leader>xw`, `xd`, `xq`, `xl`, `xt`)
- Todo-comments (`]t`, `[t`)

**Code Quality:**
- Conform formatting (`<leader>mp`)
- Nvim-lint (`<leader>l`)

**UI & Appearance:**
- Bufferline (automatic tab management)
- Lualine (status line)
- Tokyonight colorscheme
- Transparent background

**Productivity Tools:**
- Avante AI (`<leader>aa`, `ae`, `ar`, `af`)
- Auto-session (`<leader>wr`, `ws`)
- Dadbod UI (`<leader>db`)
- Lazydocker (`<leader>ld`)

**Editing Enhancements:**
- Autopairs (automatic)
- Comment.nvim (no keymaps configured)
- Nvim-surround (no keymaps configured)
- Treesitter (incremental selection with `<C-space>`)

## Missing Keymaps & Productivity Gaps

### 1. **Buffer Management**
**Current:** No buffer navigation keymaps
**Recommended:**
- `<leader>bn` - Next buffer
- `<leader>bp` - Previous buffer
- `<leader>bd` - Delete buffer
- `<leader>ba` - List all buffers (Telescope)
- `<C-^>` - Alternate buffer (built-in but not documented)

### 2. **Quickfix & Location Lists**
**Current:** No navigation keymaps
**Recommended:**
- `]q` / `[q` - Next/previous quickfix item
- `]l` / `[l` - Next/previous location list item
- `<leader>co` - Open quickfix list
- `<leader>cc` - Close quickfix list
- `<leader>cf` - Populate quickfix from search results

### 3. **Window Navigation & Management**
**Current:** Basic split creation, missing movement and resizing
**Recommended:**
- `<C-h/j/k/l>` - Move between windows (vim-tmux-navigator should handle this)
- `<leader>wh` / `wj` / `wk` / `wl` - Move window to different position
- `<leader>w=` - Equalize window sizes
- `<leader>w_` / `w|` - Maximize window vertically/horizontally
- `<leader>w+` / `w-` - Increase/decrease window height
- `<leader>w>` / `w<` - Increase/decrease window width

### 4. **Text Objects & Editing**
**Current:** Basic editing, missing advanced text objects
**Recommended:**
- Configure nvim-surround:
  - `ysiw` - Add surround to inner word
  - `ds` - Delete surround
  - `cs` - Change surround
- Configure Comment.nvim:
  - `gcc` - Toggle line comment
  - `gc` - Toggle visual selection comment
- Add text object expansions:
  - `viw` - Visual select inner word
  - `vip` - Visual select inner paragraph
  - `vi"` - Visual select inside quotes
  - `va"` - Visual select around quotes

### 5. **Debugger Integration**
**Current:** DAP plugins installed but no keymaps
**Recommended:**
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue to next breakpoint
- `<leader>do` - Step over
- `<leader>di` - Step into
- `<leader>du` - Step out
- `<leader>dr` - Run/continue
- `<leader>dq` - Quit debugging session

### 6. **Markdown & Documentation**
**Current:** Plugins installed but no keymaps
**Recommended:**
- `<leader>md` - Toggle markdown preview (nvim-docs-view)
- `<leader>mt` - Generate/update TOC (markdown-toc)
- `<leader>mv` - Toggle markview
- `<leader>ms` - Toggle markdown syntax highlighting

### 7. **System Clipboard Integration**
**Current:** No system clipboard integration
**Recommended:**
- `"*y` - Yank to system clipboard
- `"*p` - Paste from system clipboard
- `"*d` - Delete to system clipboard
- Or set `clipboard=unnamedplus` in options

### 8. **Line Manipulation**
**Current:** Missing line operations
**Recommended:**
- `<leader>dj` - Duplicate line down
- `<leader>dk` - Duplicate line up
- `<leader>dd` - Delete line to black hole register
- `<leader>J` - Join lines
- `<leader>S` - Split line at cursor
- `<leader>cj` - Move line down
- `<leader>ck` - Move line up

### 9. **Search & Replace**
**Current:** Basic search, missing advanced operations
**Recommended:**
- `<leader>s` - Search and replace in buffer
- `<leader>S` - Search and replace in project
- `*` / `#` - Search word under cursor forward/backward
- `gn` - Go to next search result
- `gN` - Go to previous search result

### 10. **Folding Operations**
**Current:** No folding keymaps
**Recommended:**
- `za` - Toggle fold
- `zR` - Open all folds
- `zM` - Close all folds
- `zo` - Open fold
- `zc` - Close fold
- `zj` / `zk` - Move to next/previous fold

## Plugin-Specific Improvements

### Telescope Extensions
**Current:** Basic file searching
**Recommended:**
- `<leader>fg` - Live grep
- `<leader>fb` - Buffers
- `<leader>fh` - Help tags
- `<leader>fm` - Marks
- `<leader>fo` - Old files
- `<leader>fc` - Command history
- `<leader>fz` - Fuzzy find current buffer

### Nvim-tree Enhancements
**Current:** Basic file explorer operations
**Recommended:**
- `a` - Add file/folder
- `d` - Delete file/folder
- `r` - Rename file/folder
- `y` - Copy file/folder
- `x` - Cut file/folder
- `p` - Paste file/folder
- `-` - Go up directory
- `=` - Change root to current node

### Trouble Navigation
**Current:** Diagnostic windows, missing navigation
**Recommended:**
- `]x` - Next diagnostic
- `[x` - Previous diagnostic
- `<leader>xx` - Close trouble window
- `<leader>xr` - Refresh trouble window

### Gitsigns Enhancements
**Current:** Basic git operations
**Recommended:**
- `<leader>gb` - Blame line
- `<leader>gB` - Toggle line blame
- `<leader>gd` - Diff this
- `<leader>gD` - Diff this ~
- `<leader>gp` - Preview hunk
- `<leader>gu` - Undo stage hunk

## Keymap Organization Strategy

### 1. **Use Which-Key for Discovery**
Your which-key configuration is good but could be expanded:
- Add more descriptive groups
- Organize by workflow (editing, navigation, git, etc.)
- Include plugin-specific keymaps in which-key

### 2. **Consistent Naming Conventions**
- `<leader>f` - File operations (Telescope)
- `<leader>b` - Buffer operations
- `<leader>w` - Window operations
- `<leader>g` - Git operations
- `<leader>d` - Debug operations
- `<leader>m` - Markdown operations
- `<leader>s` - Search operations
- `<leader>t` - Terminal operations
- `<leader>l` - LSP operations
- `<leader>x` - Diagnostic operations

### 3. **Modal Keymaps**
Consider adding mode-specific keymaps:
- Visual mode specific operations
- Insert mode quick escapes
- Command line mode enhancements

## Productivity Workflow Recommendations

### 1. **Daily Workflow Optimization**
- **Morning:** `<leader>wr` to restore session
- **Coding:** Use LSP keymaps (`gd`, `K`, `<leader>ca`)
- **Debugging:** Configure DAP keymaps
- **Git:** Use lazygit and gitsigns keymaps
- **Search:** Telescope with fuzzy finding
- **Evening:** `<leader>ws` to save session

### 2. **Project Navigation**
- Use nvim-tree for file structure
- Use Telescope for fuzzy finding
- Use bufferline for tab management
- Use marks for important locations

### 3. **Code Review & Quality**
- Use trouble for diagnostics
- Use todo-comments for TODO tracking
- Use conform for formatting
- Use nvim-lint for linting

### 4. **Documentation & Notes**
- Use markdown tools for documentation
- Use avante for AI assistance
- Use auto-session for context preservation

## Implementation Priority

### High Priority (Immediate Impact)
1. Buffer navigation keymaps
2. Window movement keymaps
3. System clipboard integration
4. Comment plugin configuration
5. Surround plugin configuration

### Medium Priority (Significant Improvement)
1. Quickfix/location list navigation
2. Line manipulation operations
3. Search and replace enhancements
4. Folding operations
5. Telescope extensions

### Low Priority (Nice to Have)
1. Debugger keymaps
2. Markdown tool keymaps
3. Advanced text objects
4. Modal keymaps
5. Workflow-specific optimizations

## Next Steps

1. **Review current keymaps** in your alpha dashboard for reference
2. **Start with high-priority** keymaps for immediate productivity gains
3. **Test each keymap** before adding to ensure no conflicts
4. **Update which-key** configuration as you add new keymaps
5. **Consider creating** a keymap reference cheat sheet
6. **Regularly review** and optimize based on usage patterns

## Resources

- [Neovim Keymap Documentation](https://neovim.io/doc/user/map.html)
- [Which-key.nvim](https://github.com/folke/which-key.nvim)
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [Nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)
- [Trouble.nvim](https://github.com/folke/trouble.nvim)

This analysis provides a roadmap for significantly improving your Neovim productivity through better keyboard shortcuts. Start with the high-priority recommendations and gradually implement others based on your workflow needs.

