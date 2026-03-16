return {
	-- Main avante.nvim plugin
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- Set to "*" for latest release, false for latest code
		build = "make",

		-- LazyVim will merge this with your existing dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The following are optional dependencies
			"hrsh7th/nvim-cmp", -- autocompletion
			"nvim-tree/nvim-web-devicons", -- icons
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
					},
				},
			},
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},

		opts = {
			-- Provider setup
			provider = "deepseek", -- Set DeepSeek as the default provider

			providers = {
				-- Built-in providers can be overridden here if needed
				openai = {
					endpoint = "https://api.openai.com/v1",
					model = "gpt-4",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.7,
						max_tokens = 4096,
					},
				},

				-- Custom DeepSeek provider (formerly in 'vendors')
				deepseek = {
					__inherited_from = "openai",
					api_key_name = "DEEPSEEK_API_KEY",
					endpoint = "https://api.deepseek.com/v1",
					model = "deepseek-chat", -- or "deepseek-coder"

					-- Request body parameters go in extra_request_body
					extra_request_body = {
						temperature = 0.7,
						max_tokens = 4096,
						-- DeepSeek specific parameters if any
					},

					-- Disable tools if not needed
					disable_tools = false,
				},

				-- You can add multiple variants
				["deepseek-coder"] = {
					__inherited_from = "deepseek",
					model = "deepseek-coder",
					extra_request_body = {
						temperature = 0.2, -- Lower temperature for more precise coding
						max_tokens = 8192, -- More tokens for code generation
					},
				},
			},

			-- Behavior customization
			behaviour = {
				auto_suggestions = false, -- Disable auto-suggestions if they're annoying
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				support_paste_from_clipboard = true,
			},

			-- Window layout
			windows = {
				wrap = true, -- Wrap long lines
				width = 30, -- Percentage of editor width
				sidebar_header = {
					align = "center",
					rounded = true,
				},
			},

			-- Mappings (customize to avoid conflicts with LazyVim defaults)
			mappings = {
				--- @class AvanteConflictMappings
				ask = "<leader>aa", -- Ask avante
				edit = "<leader>ae", -- Edit based on selected
				refresh = "<leader>ar", -- Refresh sidebar
				focus = "<leader>af", -- Focus on avante sidebar

				-- These are less likely to conflict with LazyVim
				sidebar = {
					apply_text = "<C-CR>",
					retry = "<C-r>",
					close = "q",
				},
			},
		},

		-- LazyVim will handle the keys specification
		keys = {
			{ "<leader>aa", desc = "Avante: Ask" },
			{ "<leader>ae", desc = "Avante: Edit" },
			{ "<leader>ar", desc = "Avante: Refresh" },
			{ "<leader>af", desc = "Avante: Focus" },
		},

		-- Conditional build based on platform
		build = vim.fn.has("win32") == 1 and 'powershell -c "make ; .\\tiger.exe"' or "make",

		-- Ensure the plugin loads after LazyVim's starter
		init = function()
			-- You can add any initialization code here
			-- This runs before the plugin loads
		end,
	},

	-- Optional: Add custom keymaps specifically for avante
	--{
	--	"folke/which-key.nvim",
	--	optional = true,
	--	opts = {
	--		spec = {
	--			["<leader>a"] = { name = "+avante" },
	--		},
	--	},
	--},
}
