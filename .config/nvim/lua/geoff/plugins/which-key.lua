return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		-- your configuration goes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		mappings = {
			["<leader>gl"] = { "<cmd>LazyGit<CR>", "Open LazyGit" },
			["<leader>db"] = { "<cmd>DBUI<CR>", "Open Dadbod UI" },
			["<leader>dq"] = { "<cmd>DBUIExecuteQuery<CR>", "Execute SQL Query" },
		},
	},
}
