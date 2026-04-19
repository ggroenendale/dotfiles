return {
	-- Local plugin specification for lazy.nvim
	-- Use relative path from Neovim config directory
	dir = vim.fn.stdpath("config") .. "/lua/geoff/plugins/deepseek-budget",
	name = "deepseek-budget",
	-- Specify the main module
	main = "deepseek-budget",
	-- Load at startup to initialize balance fetching
	lazy = false,
	-- Use opts to configure the plugin (lazy.nvim will call require("deepseek-budget").setup(opts))
	opts = {
		-- API key (set via DEEPSEEK_API_KEY environment variable or here)
		api_key = os.getenv("DEEPSEEK_API_KEY"),

		-- Display configuration
		refresh_interval = 300, -- 5 minutes
		display_format = "$%.2f",
		show_icon = true,
		icon = "",

		-- UI integration
		position = "lualine_x", -- Add to lualine_x section

		-- Neovide global status bar
		enable_neovide_global_bar = true,
		global_bar_height = 1,
		global_bar_position = "bottom",

		-- Thresholds for color coding
		warning_threshold = 10.0,
		critical_threshold = 5.0,
	},
	config = function(_, opts)
		-- First, add the plugin directory to package.path
		local plugin_dir = vim.fn.stdpath("config") .. "/lua/geoff/plugins/deepseek-budget"
		package.path = package.path .. ";" .. plugin_dir .. "/?.lua"

		-- Now setup the plugin with options
		require("deepseek-budget").setup(opts)

		-- Optional: Create custom statusline for Neovide
		if vim.g.neovide then
			vim.opt.statusline = "%!v:lua.require('deepseek-budget').create_statusline()()"
		end
	end,
	dependencies = {
		"nvim-lualine/lualine.nvim",
	},
}
