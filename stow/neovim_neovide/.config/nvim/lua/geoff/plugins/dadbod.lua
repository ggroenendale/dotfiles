return {
	"kristijanhusak/vim-dadbod-ui", -- UI plugin for vim-dadbod
	dependencies = {
		"tpope/vim-dadbod", -- Core plugin for database interaction
		"kristijanhusak/vim-dadbod-completion", -- Autocompletion for vim-dadbod
	},
	ft = { "sql", "mysql", "plsql" },
	keys = {
		-- Open the DBUI interface
		{ "<leader>db", "<cmd>DBUI<CR>", desc = "Open DBUI" },
		-- Execute the current SQL query
		--{ "<leader>dq", "<cmd>DBUIExecuteQuery<CR>", desc = "Execute Query" },
	},
	init = function()
		local db_credentials = require("geoff.plugins.credentials.db_credentials")

		vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
		vim.g.db_ui_show_help = 1
		vim.g.db_ui_use_nerd_fonts = true
		vim.g.db_ui_show_database_icon = true
		vim.g.db_ui_show_query_results = true
		vim.g.db_ui_auto_execute_table_helpers = 1
		vim.g.db_ui_win_position = "left"
		vim.g.db_ui_winwidth = 50
		vim.g.db_ui_max_height = 20
		vim.g.vim_dadbod_cpmpletion_mark = "[DB]"
		vim.g.dbs = db_credentials

		-- Enable debug mode
		vim.g.db_debug = 1
	end,
}
