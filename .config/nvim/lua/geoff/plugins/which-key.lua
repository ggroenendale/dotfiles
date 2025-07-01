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
			-- Lazy Git Mappings
			["<leader>gl"] = { "<cmd>LazyGit<CR>", "Open LazyGit" },

			-- DBUI Mappings
			["<leader>db"] = { "<cmd>DBUI<CR>", "Open Dadbod UI" },
			["<leader>dq"] = { "<cmd>DBUIExecuteQuery<CR>", "Execute SQL Query" },

			-- LSP Mappings
			["gR"] = { "<cmd>Telescope lsp_references<CR>", "Show LSP references" }, -- show definition, references
			["gD"] = { vim.lsp.buf.declaration, "Go to declaration" }, -- go to declaration
			["gd"] = { "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions" }, -- show lsp definitions
			["gi"] = { "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations" }, -- show lsp implementations
			["gt"] = { "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions" }, -- show lsp type definitions
			["<leader>ca"] = { vim.lsp.buf.code_action, "See available code actions" }, -- see available code actions, in visual mode will apply to selection
			["<leader>rn"] = { vim.lsp.buf.rename, "Smart rename" }, -- smart rename
			["<leader>D"] = { "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics" }, -- show  diagnostics for file
			["<leader>d"] = { vim.diagnostic.open_float, "Show line diagnostics" }, -- show diagnostics for line
			["[d"] = { vim.diagnostic.goto_prev, "Go to previous diagnostic" }, -- jump to previous diagnostic in buffer
			["]d"] = { vim.diagnostic.goto_next, "Go to next diagnostic" }, -- jump to next diagnostic in buffer
			["K"] = { vim.lsp.buf.hover, "Show documentation for what is under cursor" }, -- show documentation for what is under cursor
			["<leader>rs"] = { ":LspRestart<CR>", "Restart LSP" }, -- mapping to restart lsp if necessary
		},
	},
	keys = {
		{ "gD", vim.lsp.buf.declaration, desc = "Go to the Declaration", mode = "n" },
	},
}

-- config = function(_, opts)
-- 		local wk = require("which-key")
-- 		wk.setup(opts)
--
-- 		-- Apply buffer-specific LSP keymaps when attached
-- 		vim.api.nvim_create_autocmd("LspAttach", {
-- 			callback = function(args)
-- 				local bufnr = args.buf
-- 				local client = vim.lsp.get_client_by_id(args.data.client_id)
--
-- 				-- Buffer-local mappings
-- 				local mappings = {
-- 					["<leader>l"] = { name = "+lsp" },
-- 					["K"] = { vim.lsp.buf.hover, "Hover", buffer = bufnr },
-- 					["gd"] = { "<cmd>Telescope lsp_definitions<CR>", "Definition", buffer = bufnr },
-- 					-- Add other buffer-specific mappings here
-- 				}
--
-- 				-- Language-specific additions
-- 				if client.name == "pylsp" or client.name == "pyright" then
-- 					mappings["<leader>pi"] = {
-- 						function()
-- 							vim.cmd("!pip install " .. vim.fn.expand("<cword>"))
-- 						end,
-- 						"Pip Install",
-- 						buffer = bufnr,
-- 					}
-- 				end
--
-- 				--wk.add(mappings, { buffer = bufnr })
-- 			end,
-- 		})
-- 		--wk.add(opts.mappings)
-- 	end,
