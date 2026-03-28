
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- import comment plugin safely
    local comment = require("Comment")

    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    -- enable comment with enhanced configuration for visual mode
    comment.setup({
      -- for commenting tsx, jsx, svelte, html files
      pre_hook = ts_context_commentstring.create_pre_hook(),

      -- Enable basic keymaps for consistency
      toggler = {
        line = 'gcc',        -- toggle current line
        block = 'gbc',       -- toggle current block
      },
      opleader = {
        line = 'gc',         -- toggle visual selection lines
        block = 'gb',        -- toggle visual selection block
      },
      extra = {
        above = 'gcO',       -- add comment above
        below = 'gco',       -- add comment below
        eol = 'gcA',         -- add comment at end of line
      },
    })
  end,
}
