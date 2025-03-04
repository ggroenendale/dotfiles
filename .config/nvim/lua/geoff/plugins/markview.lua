return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.icons",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("markview").setup({
			markdown = {
				enable = true,
				block_quotes = {
					["^NOTE$"] = {},
				},
				code_blocks = {
					enable = true,
					style = "block", -- Display code blocks as blocks
					label_direction = "right", -- Label position
					border_hl = "MarkviewCode", -- Highlight group for borders
					info_hl = "MarkviewCodeInfo", -- Highlight group for info
					min_width = 60, -- Minimum width for code blocks
					pad_amount = 2, -- Padding around code blocks
					pad_char = " ", -- Padding character
					sign = true, -- Show sign column
					default = {
						block_hl = "MarkviewCodeInfo", -- Default highlight for code blocks
						pad_hl = "MarkviewCodeInfo", -- Default highlight for padding
					},
				},
			},
		})
	end,
}
