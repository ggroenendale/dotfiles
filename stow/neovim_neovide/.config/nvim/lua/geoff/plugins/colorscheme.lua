return {
	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		local bg = "#011628"
		local bg_dark = "#011423"
		local bg_highlight = "#143652"
		local bg_search = "#0A64AC"
		local bg_visual = "#275378"

		local fg = "#CBE0F0"
		local fg_dark = "#B4D0E9"
		local fg_gutter = "#627E97"

		local border = "#547998"

		-- extra semantic colors (add more control)
		local comment = "#5C7E9E"
		local accent = "#7AA2F7"
		local error = "#FF5F6D"
		local warning = "#E0AF68"
		local success = "#9ECE6A"

		require("tokyonight").setup({
			style = "night",
			transparent = vim.g.transparent_enabled,

			-- Base Palette
			on_colors = function(colors)
				colors.bg = bg
				colors.bg_dark = bg_dark
				colors.bg_float = bg_dark
				colors.bg_highlight = bg_highlight
				colors.bg_popup = bg_dark
				colors.bg_search = bg_search
				colors.bg_sidebar = bg_dark
				colors.bg_statusline = bg_dark
				colors.bg_visual = bg_visual
				colors.border = border
				colors.fg = fg
				colors.fg_dark = fg_dark
				colors.fg_float = fg
				colors.fg_gutter = fg_gutter
				colors.fg_sidebar = fg_dark
			end,

			-- Highlight control
			on_highlights = function(hl, colors)
				-- =========================
				-- CORE EDITOR
				-- =========================
				hl.Normal = { fg = fg, bg = bg }
				hl.NormalFloat = { bg = bg_dark }
				hl.FloatBorder = { fg = border, bg = bg_dark }

				hl.CursorLine = { bg = bg_highlight }
				hl.Visual = { bg = bg_visual }

				hl.LineNr = { fg = fg_gutter }
				hl.CursorLineNr = { fg = accent, bold = true }

				-- =========================
				-- SYNTAX
				-- =========================
				hl.Comment = { fg = comment, italic = true }
				hl.Keyword = { fg = accent, italic = true }
				hl.Function = { fg = "#82AAFF" }
				hl.String = { fg = "#C3E88D" }
				hl.Number = { fg = "#F78C6C" }

				-- =========================
				-- DIAGNOSTICS
				-- =========================
				hl.DiagnosticError = { fg = error }
				hl.DiagnosticWarn = { fg = warning }
				hl.DiagnosticInfo = { fg = accent }
				hl.DiagnosticHint = { fg = success }

				-- =========================
				-- SEARCH
				-- =========================
				hl.Search = { bg = bg_search, fg = "#ffffff" }
				hl.IncSearch = { bg = accent, fg = "#000000" }

				-- =========================
				-- MARKVIEW
				-- =========================
				hl.MarkviewCode = {
					bg = "#021a30",
				}

				hl.MarkviewCodeInfo = {
					fg = fg_dark,
					bg = "#012030",
					italic = true,
				}

				-- optional finer control
				hl.MarkviewBlockQuote = {
					fg = comment,
					bg = bg_dark,
					italic = true,
				}

				-- =========================
				-- UI POLISH
				-- =========================
				hl.WinSeparator = { fg = border }
				hl.Pmenu = { bg = bg_dark }
				hl.PmenuSel = { bg = bg_highlight }

				-- =========================
				-- TRANSPARENCY FIXES
				-- =========================
				if vim.g.transparent_enabled then
					hl.Normal.bg = "NONE"
					hl.NormalFloat.bg = "NONE"
				end
			end,
		})

		vim.cmd("colorscheme tokyonight")
	end,
}
