return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		local util = require("lspconfig.util")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			--["svelte"] = function()
			--  -- configure svelte server
			--  lspconfig["svelte"].setup({
			--    capabilities = capabilities,
			--    on_attach = function(client, bufnr)
			--      vim.api.nvim_create_autocmd("BufWritePost", {
			--        pattern = { "*.js", "*.ts" },
			--        callback = function(ctx)
			--          -- Here use ctx.match instead of ctx.file
			--          client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
			--        end,
			--      })
			--    end,
			--  })
			--end,
			["graphql"] = function()
				-- configure graphql language server
				lspconfig["graphql"].setup({
					capabilities = capabilities,
					filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
				})
			end,
			--["emmet_ls"] = function()
			--  -- configure emmet language server
			--  lspconfig["emmet_ls"].setup({
			--    capabilities = capabilities,
			--    filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
			--  })
			--end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
			--[[ ["basedpyright"] = function()
				lspconfig["basedpyright"].setup({
					--on_init = function(client)
					--	local venv_path = vim.fn.getcwd() .. "/.venv"
					--	if vim.fn.isdirectory(venv_path) == 1 then
					--		-- Set the Python path in the LSP settings
					--		client.config.settings.python3.pythonPath = venv_path .. "/bin/python"
					--	end
					--end,
					capabilities = capabilities,
					settings = {
						basedpyright = {
							analysis = {
								typeCheckingMode = "strict",
							},
						},
					},
				})
			end, ]]
			["pylsp"] = function()
				lspconfig["pylsp"].setup({
					root_dir = function(fname)
						local root_files = {
							"pyproject.toml",
							"setup.py",
							"setup.cfg",
							"requirements.txt",
							"Pipfile",
						}
						local startpath = vim.fn.getcwd() .. "/.venv"

						return util.root_pattern(unpack(root_files))(fname)
							or vim.fs.dirname(vim.fs.find(".venv", { path = startpath, upward = true })[1])
							or vim.fn.expand("%:p:h")
					end,
					settings = {
						pylsp = {
							plugins = {
								jedi = {
									environment = vim.fn.getcwd() .. "/.venv",
								}, -- where OS env vars kick in
								pycodestyle = {
									enabled = true,
									ignore = { "E501", "E231" },
									maxLineLength = 200,
								},
							},
						},
					},
					cmd = { vim.fn.getcwd() .. "/.venv/bin/python", "-m", "pylsp" },
					on_init = function(client)
						-- Get the current working directory
						local venv_path = vim.fn.getcwd() .. "/.venv"

						--print(vim.inspect(venv_path))

						-- Check if the .venv folder exists
						if vim.fn.isdirectory(venv_path) == 1 then
							--print("Im thinking this is a directory")
							vim.fn.setenv("VIRTUAL_ENV", venv_path)
							vim.g.python3_host_prog = venv_path .. "/bin/python"
							-- Set the pythonPath to use the virtual environment
							--client.config.settings.pylsp = client.config.settings.pylsp or {}
							--client.config.settings.pylsp.plugins = client.config.settings.pylsp.plugins or {}
							--client.config.settings.pylsp.plugins.pylsp_mypy = client.config.settings.pylsp.plugins.pylsp_mypy	or {}
							--client.config.settings.pylsp.configurationSources = { "flake8" } -- Example: Use flake8 for linting
							--client.config.settings.pylsp.plugins.pylsp_mypy.pythonExecutable = venv_path .. "/bin/python"
							--client.config.settings.pylsp.plugins.pylsp_black = { enabled = true } -- Enable Black formatter
							--client.config.settings.pylsp.plugins.pylsp_flake8 = { enabled = true } -- Enable flake8 linter
							--client.config.settings.pylsp.plugins.pylsp_pyflakes = { enabled = false } -- Disable pyflakes (redundant with flake8)
							--client.config.settings.pylsp.plugins.pylsp_pycodestyle = { enabled = false } -- Disable pycodestyle (redundant with flake8)
						end
					end,
				})
			end,
			["ast_grep"] = function()
				lspconfig["ast_grep"].setup({
					filetypes = { "c", "cpp", "rust", "go", "java" }, -- Remove Python
				})
			end,
		})
	end,
}
