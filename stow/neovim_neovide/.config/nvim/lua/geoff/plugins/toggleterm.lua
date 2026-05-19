return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local toggleterm = require("toggleterm")
		local Terminal = require("toggleterm.terminal").Terminal

		toggleterm.setup({
			size = 20,
			open_mapping = nil,
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 3,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})

		-- Keymaps
		local keymap = vim.keymap

		-- Toggle floating terminal
		keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle floating terminal" })
		keymap.set("t", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle floating terminal" })

		-- Toggle horizontal terminal
		keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })

		-- Toggle vertical terminal
		keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })

		-- Toggle terminal #2 (lazy git)
		keymap.set("n", "<leader>tg", "<cmd>2ToggleTerm<CR>", { desc = "Toggle terminal #2 (git)" })

		-- Escape terminal mode with jk
		keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })
	end,
}

