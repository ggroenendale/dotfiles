return {}
--[[ return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		--"neovim/nvim-lspconfig",
		{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
		"mfussenegger/nvim-dap",
		"mfussenegger/nvim-dap-python",
	},
	lazy = false,
	branch = "regexp",
	config = function()
		require("venv-selector").setup()
	end,
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<CR>" },
		{ "<leader>vc", "<cmd>VenvSelectCached<CR>" },
	},
} ]]
