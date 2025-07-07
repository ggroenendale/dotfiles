return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"ray-x/lsp_signature.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		local util = require("lspconfig.util")

		local lsp_signature = require("lsp_signature")
		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		--vim.api.nvim_create_autocmd("LspAttach", {
		--	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		--	callback = function(ev)
		--		-- Buffer local mappings.
		--		-- See `:help vim.lsp.*` for documentation on any of the below functions
		--		local opts = { buffer = ev.buf, silent = true }
		--
		--		-- set keybinds
		--		opts.desc = "Show LSP references"
		--		keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

		--		opts.desc = "Go to declaration"
		--		keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

		--		opts.desc = "Show LSP definitions"
		--		keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

		--		opts.desc = "Show LSP implementations"
		--		keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

		--		opts.desc = "Show LSP type definitions"
		--		keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

		--		opts.desc = "See available code actions"
		--		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

		--		opts.desc = "Smart rename"
		--		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

		--		opts.desc = "Show buffer diagnostics"
		--		keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

		--		opts.desc = "Show line diagnostics"
		--		keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

		--		opts.desc = "Go to previous diagnostic"
		--		keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

		--		opts.desc = "Go to next diagnostic"
		--		keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

		--		opts.desc = "Show documentation for what is under cursor"
		--		keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

		--		opts.desc = "Restart LSP"
		--		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
		--	end,
		--})
		local on_attach = function(client, bufnr)
			--vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
			--if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(true) end
			lsp_signature.on_attach({}, bufnr)
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.diagnostic.config()
			--vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Customize the documentation hover window
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded", -- other options: "single", "double", "shadow", "none"
			max_width = 80,
		})

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			--          client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
		-- =====================================================================
		-- C, CPP, generic Language Server
		-- =====================================================================
		vim.lsp.ast_grep = {
			settings = {
				filetypes = { "c", "cpp", "rust", "go", "java" }, -- Remove Python
			},
		}

		-- =====================================================================
		-- Markdown Language Server
		-- =====================================================================
		vim.lsp.markdown_oxide = {
			setup = {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- Default LSP keymaps and capabilities
					--vim.lsp.buf.inlay_hints(bufnr, true) -- Enable inlay hints if needed

					-- Markdown specific editor settings
					vim.opt_local.wrap = true
					vim.opt_local.linebreak = true
					vim.opt_local.breakindent = true

					-- Enhanced navigation for wrapped lines
					vim.keymap.set("n", "j", "gj", { buffer = bufnr, desc = "Move down (visual lines)" })
					vim.keymap.set("n", "k", "gk", { buffer = bufnr, desc = "Move up (visual lines)" })
				end,
				filetypes = { "markdown" },
			},
		}
		-- ======================================================================
		-- Lua Language Server
		-- ======================================================================
		vim.lsp.lua_ls = {
			-- configure lua server (with special settings)
			capabilities = capabilities,
			on_attach = on_attach,
			on_init = function()
				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						path ~= vim.fn.stdpath("config")
						and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
					then
						return
					end
				end
				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						version = "LuaJIT",
					},
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							"${3rd}/luv/library",
						},
					},
				})
			end,
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
		}

		-- =====================================================================
		-- Graphql Language Server
		-- =====================================================================
		vim.lsp.graphql = {
			capabilities = capabilities,
			on_attach = on_attach(),
			settings = {
				filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
			},
		}

		-- =====================================================================
		-- Python Language Server
		-- =====================================================================
		vim.lsp.pylsp = {
			capabilities = capabilities,
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
					configurationSources = {},
					plugins = {
						jedi = {
							enabled = true,
							environment = vim.fn.getcwd() .. "/.venv/bin/python",
						}, -- where OS env vars kick in
						jedi_definition = { enabled = true },
						jedi_hover = { enabled = true },
						pycodestyle = {
							enabled = true,
							ignore = { "E501", "E231", "W391", "W191" },
							maxLineLength = 200,
						},
						pylint = {
							enabled = false,
						},
						pylsp_mypy = { enabled = false },
						rope_completion = { enabled = false },
						yapf = { enabled = false },
						autopep8 = { enabled = false },
						flake8 = { enabled = false },
						pyflakes = { enabled = false },
					},
				},
			},
			-- cmd = { vim.fn.getcwd() .. "/.venv/bin/python", "-m", "pylsp" },
			on_init = function(client)
				-- Get the current working directory
				local venv_path = vim.fn.getcwd() .. "/.venv"
				--print(vim.inspect(venv_path))
				-- Check if the .venv folder exists
				if vim.fn.isdirectory(venv_path) == 1 then
					--print("Im thinking this is a directory")
					vim.notify(".venv path is:" .. venv_path)
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
				else
					vim.notify("pylsp could not find .venv")
				end
			end,
		}
	end,
}
