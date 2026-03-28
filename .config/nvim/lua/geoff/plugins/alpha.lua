--print("Loading alpha")
return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")

		local col = function(strlist, opts)
			-- strlist is a Table of Tables, representing columns of text
			-- opts is a text display option

			-- column spacing
			local padding = 12
			-- fill lines up to the maximum length with 'fillchar'
			local fillchar = " "
			-- columns padding char (for testing)
			local padchar = " "

			-- Helper function to get visual display width of a string
			local display_width = function(s)
				return vim.fn.strdisplaywidth(s)
			end

			-- Define maximum display width in a table
			local max_display_width = function(str)
				local max = 0
				for i in pairs(str) do
					local width = display_width(str[i])
					if width > max then
						max = width
					end
				end
				return max
			end

			-- Add as much right-padding to align the text block based on display width
			local pad_to_display_width = function(str, target_width)
				local result = {}
				for i in pairs(str) do
					local current = str[i]
					local current_width = display_width(current)

					if current_width < target_width then
						-- Need to add padding to reach target display width
						local padding_needed = target_width - current_width
						local padded = current .. string.rep(fillchar, padding_needed)
						table.insert(result, padded)
					else
						table.insert(result, current)
					end
				end
				return result
			end

			-- This is a table for output strings
			local values = {}

			-- Find the maximum number of rows across all columns
			local max_rows = 0
			for col_idx = 1, #strlist do
				if #strlist[col_idx] > max_rows then
					max_rows = #strlist[col_idx]
				end
			end

			-- Process all the rows
			for row = 1, max_rows do
				local row_str = ""

				-- Process all columns except the last (no extra padding after last column)
				for col_idx = 1, #strlist - 1 do
					local column = strlist[col_idx]
					local col_max_width = max_display_width(column)
					local padded_column = pad_to_display_width(column, col_max_width)

					if column[row] == nil then
						-- Empty cell in this column
						row_str = row_str .. string.rep(fillchar, col_max_width) .. string.rep(padchar, padding)
					else
						row_str = row_str .. padded_column[row] .. string.rep(padchar, padding)
					end
				end

				-- Process the last column (no extra padding after it)
				local last_col = strlist[#strlist]
				local last_col_max_width = max_display_width(last_col)
				local padded_last_col = pad_to_display_width(last_col, last_col_max_width)

				if last_col[row] == nil then
					row_str = row_str .. string.rep(fillchar, last_col_max_width)
				else
					row_str = row_str .. padded_last_col[row]
				end

				-- Insert result into output table
				table.insert(values, { type = "text", val = row_str, opts = opts })
			end

			--print("Are there alpha values?")
			--print(values)

			return values
		end

		-- FIXED: The column function now uses vim.fn.strdisplaywidth() to calculate
		-- visual display width instead of string length, which properly handles
		-- NerdFont icons with different visual widths.
		-- General Neovim Commands
		local general_commands = {
			"     General Neovim Commands     ",
			"   ---------------------------   ",
			"󱁐 e     New File                ",
			"󱁐 nh  󰍉  Clear Search Highlights ",
			"󱁐 +   󰎫  Increment Number        ",
			"󱁐 -   󰎪  Decrement Number        ",
			"q       Quit Neovim             ",
			" ",
			" ",
		}

		-- Editor Command
		local editor_commands = {
			"        Editor Commands       ",
			"      -------------------     ",
			"󰘶 K  󰋖  Open Documentation    ",
			"gd   󰌋  Go to Definition      ",
			"gD   󰙅  Go to Type Definition ",
			"gi   󰚩  Go to Implementation  ",
			"jk   󰌑  Exit Insert Mode      ",
			" ",
			" ",
		}

		-- Telescope Commands (File Search)
		local telescope_commands = {
			"     Telescope Commands         ",
			"   ----------------------       ",
			"󱁐 ff  󰱼  Find Files               ",
			"󱁐 fr  󰥨  Find Recent Files        ",
			"󱁐 fs    Live Grep (Find String)  ",
			"󱁐 fc  󰍉  Find String Under Cursor ",
			"󱁐 ft  󰚩  Find Todos",
			" ",
			" ",
		}

		-- File Tree Commands
		local filetree_commands = {
			"       File Tree Commands       ",
			"     ----------------------     ",
			"󱁐 ee    Toggle File Explorer   ",
			"󱁐 ef  󰝰  Find File in Explorer  ",
			"󱁐 ec  󰁨  Collapse File Explorer ",
			"󱁐 er  󰑓  Refresh File Explorer  ",
			" ",
			" ",
			" ",
		}

		-- LazyGit Commands
		local git_commands = {
			"       Git Commands     ",
			"     ----------------   ",
			"󱁐 gl  󰊢  Open LazyGit   ",
			" ",
			" ",
			" ",
			" ",
			" ",
			" ",
		}

		-- Dadbod Database Commands
		local dadbod_commands = {
			"     Dadbod DB Commands   ",
			"   ---------------------- ",
			"󱁐 db  󰆼  Open Database UI ",
			" ",
			" ",
			" ",
			" ",
			" ",
			" ",
		}

		-- Session Management Commands
		local session_commands = {
			"    Session Management Commands    ",
			"  -------------------------------  ",
			"󱁐 wr  󰁯  Restore Session in CWD    ",
			"󱁐 ws  󰆓  Save Session              ",
			"                                   ",
			"       Wezterm Commands            ",
			"     --------------------          ",
			"󰘶CTRL p   Open Wezterm Cmd Palette ",
			"󰘶CTRL t   New Wezterm Tab          ",
			"󰘶CTRL w   Close Wezterm Tab        ",
			" ",
			" ",
		}

		-- Window Management Commands
		local window_commands = {
			"     Window Management Commands    ",
			"   ------------------------------  ",
			"󱁐 sv  󰖷  Split Window Vertically   ",
			"󱁐 sh  󰖴  Split Window Horizontally ",
			"󱁐 se  󰁨  Make Splits Equal Size    ",
			"󱁐 sx  󰅖  Close Current Split       ",
			"󱁐 to  󰓩  Open New Tab              ",
			"󱁐 tx  󰅙  Close Current Tab         ",
			"󱁐 tn  󰅒  Go to Next Tab            ",
			"󱁐 tp  󰅐  Go to Previous Tab        ",
			"󱁐 tf  󰏪  Open Buffer in New Tab    ",
		}

		-- Avante Commands
		local avante_commands = {
			"     Avante AI Commands          ",
			"   ----------------------        ",
			"󱁐 aa  󰚩  Ask Avante              ",
			"󱁐 ae  󰉋  Edit based on selected  ",
			"󱁐 ar  󰑓  Refresh sidebar         ",
			"󱁐 af  󰍉  Focus on Avante sidebar ",
			" ",
			" ",
			" ",
			" ",
			" ",
		}

		local wez_commands = {
			"       Wezterm Commands            ",
			"     --------------------          ",
			"󰘶CTRL p   Open Wezterm Cmd Palette ",
			"󰘶CTRL t   New Wezterm Tab          ",
			"󰘶CTRL w   Close Wezterm Tab        ",
			" ",
			" ",
		}

		local head = {
			type = "text",
			val = {
				"                                                     ",
				"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
				"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
				"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
				"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
				"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
				"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
				"                                                     ",
			},
			opts = {
				position = "center",
				hl = "Type",
			},
		}

		local block1 = {
			type = "group",
			val = col({ general_commands, editor_commands, telescope_commands }, {
				position = "center",
				hl = { { "Comment", 0, -1 } },
			}),
			opts = {
				spacing = 0,
			},
		}

		local block2 = {
			type = "group",
			val = col({ filetree_commands, git_commands, dadbod_commands }, {
				position = "center",
				hl = { { "Comment", 0, -1 } },
			}),
			opts = {
				spacing = 0,
			},
		}

		local block3 = {
			type = "group",
			val = col({ session_commands, window_commands, avante_commands }, {
				position = "center",
				hl = { { "Comment", 0, -1 } },
			}),
			opts = {
				spacing = 0,
			},
		}

		local opts = {
			layout = {
				{ type = "padding", val = 2 },
				head,
				{ type = "padding", val = 2 },
				block1,
				{ type = "padding", val = 2 },
				block2,
				{ type = "padding", val = 2 },
				block3,
				{ type = "padding", val = 2 },
			},
			startup = {
				should_skip_alpha = function()
					return false
				end,
			},
		}

		--print("Is there another arg in vim argc")
		--print(vim.fn.argc() > 0)

		-- Override should_skip_alpha to allow directories
		-- This didn't work, couldnt figure out how to override should skip
		-- so instead we created a different start function that checks for
		-- neovide as the app
		--local old_should_skip_alpha = alpha.should_skip_alpha
		--alpha.should_skip_alpha = function()
		--	-- Check if we have arguments
		--	if vim.fn.argc() > 0 then
		--		-- Get the first argument
		--		local first_arg = vim.fn.argv(0)
		--		-- If it's a directory, don't skip alpha
		--		print("This is the directory?")
		--		print(first_arg)
		--		if vim.fn.isdirectory(first_arg) == 1 then
		--			return false
		--		end
		--		-- Otherwise use the original logic
		--		return old_should_skip_alpha()
		--	end
		--	-- No arguments, use original logic
		--	return old_should_skip_alpha()
		--end

		-- Send config to alpha
		alpha.setup(opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

		--print("The alpha config does load")
	end,
}
