return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		local col = function(strlist, opts)
			-- strlist is a Table of Tables, representing columns of text
			-- opts is a text display option

			-- column spacing
			local padding = 12
			-- fill lines up to the maximum length with 'fillchar'
			local fillchar = " "
			-- columns padding char (for testing)
			local padchar = " "

			--define maximum string length in a table
			local maxlen = function(str)
				local max = 0
				for i in pairs(str) do
					if #str[i] > max then
						max = #str[i]
					end
				end
				return max
			end

			-- add as much right-padding to align the text block
			local pad = function(str, max)
				local strlist = {}
				for i in pairs(str) do
					if #str[i] < max then
						local newstr = str[i] .. string.rep(fillchar, max - #str[i])
						table.insert(strlist, newstr)
					else
						table.insert(strlist, str[i])
					end
				end
				return strlist
			end

			--this is a table for test strings
			local values = {}
			-- process all the lines
			for i = 1, maxlen(strlist) do
				local str = ""
				-- process all the columns but last, becase we dont want extra padding
				-- after last column
				for column = 1, #strlist - 1 do
					local maxstr = maxlen(strlist[column])
					local padded = pad(strlist[column], maxstr)
					if strlist[column][i] == nil then
						str = str .. string.rep(fillchar, maxstr) .. string.rep(padchar, padding)
					else
						str = str .. padded[i] .. string.rep(padchar, padding)
					end
				end

				-- lets process the last column, no extra padding
				do
					local maxstr = maxlen(strlist[#strlist])
					local padded = pad(strlist[#strlist], maxstr)
					if strlist[#strlist][i] == nil then
						str = str .. string.rep(fillchar, maxlen(strlist[#strlist]))
					else
						str = str .. padded[i]
					end
				end

				--insert result into output table
				table.insert(values, { type = "text", val = str, opts = opts })
			end

			return values
		end

		-- TODO: For some reason the text here doesn't line up to the column and I don't know why... Maybe if I change the character it draws with I can see
		-- It seems to be an issue with the nerdfont symbols. I noticed that the lines that require an extra space have a shorter unicode character.
		-- In other words this character '󰁯 ' and this character '󰱼' are longer characters of the form 000f006f and 000f0c7c as opposed to f17b for 
		-- Note for future use we can use the command 'ga' when hovering on a character in normal mode to get its unicode character code
		local nvim_commands = {
			"       Neovim Controls",
			"     --------------------",
			" 󱁐 e      New File",
			" 󱁐 ee     Toggle File Explorer",
			"󱁐 ff   󰱼  Find File",
			"  󱁐 fs     Find Word",
			"  󱁐 wr   󰁯  Restore Session in CWD",
			"󰘶 #        Search Backwards, use :nohl to clear highlights",
			"      q      Quit Neovim",
		}

		local wez_commands = {
			"       Wezterm Commands        ",
			"     --------------------      ",
			"󰘶CTRL p    Open Wezterm Command Palette",
			"󰘶CTRL t    New Wezterm Tab",
			"󰘶CTRL w    Close Wezterm Tab",
			" ",
			" ",
		}

		local editor_commands = {
			"             Editor Commands         ",
			"           -------------------       ",
			"󰘶 K  Open Documentation on Cursor Hover",
		}

		local git_commands = {
			"         Git Commands       ",
			"       ----------------       ",
			"󱁐 gl   Open Lazy Git   ",
			"󰘶 P    Push Commits to Remote",
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
			val = col({ nvim_commands, editor_commands, wez_commands }, {
				position = "center",
				hl = { { "Comment", 0, -1 } },
			}),
			opts = {
				spacing = 0,
			},
		}

		local block2 = {
			type = "group",
			val = col({ git_commands }, {
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
			},
		}

		-- Send config to alpha
		alpha.setup(opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
