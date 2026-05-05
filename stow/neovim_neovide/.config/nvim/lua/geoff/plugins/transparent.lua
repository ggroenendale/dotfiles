return {
	"xiyaowong/transparent.nvim",
	lazy = false,
	config = function()
		require("transparent").setup({
			enable = true,
			groups = {
				"Normal",
				"NormalNC",
				"Comment",
				"Constant",
				"Special",
				"Identifier",
				"Statement",
				"PreProc",
				"Type",
				"Underlined",
				"Todo",
				"String",
				"Function",
				"Conditional",
				"Repeat",
				"Operator",
				"Structure",
				"LineNr",
				"NonText",
				"SignColumn",
				"CursorLine",
				"CursorLineNr",
				"StatusLine",
				"StatusLineNC",
				"EndOfBuffer",
			},
			exclude_groups = {},
		})

		vim.cmd([[
            highlight Normal guibg=none
            highlight NonText guibg=none
            highlight Normal ctermbg=none
            highlight NonText ctermbg=none
            highlight Special guibg=none
            highlight Special ctermbg=none
            highlight NormalNC guibg=none
            highlight NormalNC ctermbg=none
        ]])
	end,
}
