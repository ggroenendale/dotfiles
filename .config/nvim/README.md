

## Introduction

---

Most of the configurations for neovim found in this repository come from this video:

https://www.youtube.com/watch?v=6pAG3BHurdM

As well as from this blog from the same creator:

https://www.josean.com/posts/how-to-setup-neovim-2024

## Surrounding Characters/Tags

Some notes on creating surrounding characters for things like html tags, double quotes,
brackets, etc.

|Old text                 |Command     |New text              |
|-------------------------|------------|----------------------|
|surr*ound_words          |ysiw)       |(surround_words)      |
|*make strings            |ys$"        |"make strings"        |
|[delete ar*ound me!]     |ds]         |delete around me!     |
|remove \<b>HTML t*ags\</b> |dst         |remove HTML tags      |
|'change quot*es'         |cs'"        |"change quotes"       |
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
