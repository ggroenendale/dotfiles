return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Only for LSP Servers
		mason_lspconfig.setup({
			automatic_installation = true,
			-- list of servers for mason to install
			ensure_installed = {
				"dockerls",
				"docker_compose_language_service",
				"nginx_language_server",
				"sqlls",
				"lemminx",
				"html",
				--"html-lsp",
				--"jinja_lsp", -- jinja
				--"ast_grep",
				"pylsp",
				"ruff",
				"cssls",
				"somesass_ls",
				"css_variables",
				"cssmodules_ls",
				"unocss", -- css
				"eslint",
				"jsonls",
				"lua_ls", -- lua
				"graphql",
				--"pyright", -- Static type checker for Python.
				--"basedpyright", -- Fork of the Pyright static type checker for Python, with extra Pylance features.
			},
		})

		-- For tools like formatters, linters, and debuggers
		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"black", --python formatter
				--"pylint", -- python linter
				"eslint_d", --js linter
				"debugpy", -- Python Debugger
				"htmlbeautifier", -- HTML Formatter
				"htmlhint", -- HTML Linter
				"biome", -- For javascript and json linting
				"pydocstyle", -- Python docstring linter
				"jupytext", -- Jupyter notebook tools
			},
			run_on_start = true,
		})
	end,
}
