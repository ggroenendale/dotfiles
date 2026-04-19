----------------------------------------------------------------------
-- Neovim Startup Configuration
--
-- This file handles startup behavior for:
--   • alpha-nvim dashboard
--   • nvim-tree file explorer
--   • Neovide GUI-specific settings
--
-- The goal is to achieve the following layout when Neovide launches:
--
--     | NvimTree | Alpha Dashboard |
--
-- And when a file is opened from NvimTree:
--
--     | NvimTree | File Buffer |
--
-- The alpha dashboard should automatically close once a real file
-- buffer is opened.
--
-- A key challenge is avoiding race conditions inside alpha-nvim
-- redraw logic when its window is closed too early.
----------------------------------------------------------------------

-- Load core configuration and plugin manager
require("geoff.core")
require("geoff.lazy")

-- Load Neovide-specific configuration
if vim.g.neovide then
    require("geoff.core.neovide").setup()
end

----------------------------------------------------------------------
-- Neovide GUI configuration
--
-- These settings only apply when Neovim is running inside Neovide.
-- vim.g.neovide is set automatically by Neovide at startup.
----------------------------------------------------------------------

if vim.g.neovide then
	-- Global window opacity
	vim.g.neovide_opacity = 0.85

	-- Opacity of normal editor buffers
	vim.g.neovide_normal_opacity = 0.85
end

----------------------------------------------------------------------
-- GUI Configuration
--
-- Load GUI-specific settings including right-click context menus
-- This is loaded after core configuration but before any autocmds
----------------------------------------------------------------------

-- Note: GUI configuration is loaded via geoff.core.init.lua
-- when running in GUI mode (Neovide or other GUI)

----------------------------------------------------------------------
-- Font configuration
--
-- Neovide uses the 'guifont' option to control font rendering.
-- Note: This may be overridden by Neovide's config.toml
----------------------------------------------------------------------

local normal_font = "Mononoki Nerd Font Mono"

----------------------------------------------------------------------
-- BufEnter Autocommand
--
-- Purpose:
-- Automatically close the alpha dashboard once a real file buffer
-- is opened.
--
-- Why this exists:
-- alpha-nvim redraws its window during resize events. If we close
-- the alpha window immediately during BufEnter, alpha may attempt
-- to redraw a window that no longer exists, causing errors like:
--
--   Invalid window id
--
-- Solution:
--   • Ignore alpha buffers and special buffers
--   • Schedule the close operation for the next event loop tick
--   • Verify window validity before closing
--
-- This prevents race conditions with alpha's internal redraw logic.
----------------------------------------------------------------------

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		-- Ignore alpha dashboard buffers
		if vim.bo.filetype == "alpha" then
			return
		end

		-- Ignore special buffers such as terminals, prompts, etc.
		if vim.bo.buftype ~= "" then
			return
		end

		-- Defer execution to avoid alpha redraw race conditions
		vim.schedule(function()
			-- Iterate through all open windows
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				-- Ensure window still exists
				if vim.api.nvim_win_is_valid(win) then
					local buf = vim.api.nvim_win_get_buf(win)

					-- If the window contains the alpha dashboard
					if vim.bo[buf].filetype == "alpha" then
						-- Safely close it
						-- pcall prevents crashes if the window closes
						-- between validation and this call
						pcall(vim.api.nvim_win_close, win, true)
					end
				end
			end
		end)
	end,
})

----------------------------------------------------------------------
-- VimEnter Autocommand
--
-- Purpose:
-- Configure the initial window layout when Neovide launches.
--
-- Problem being solved:
-- When Neovide starts with nvim-tree open, alpha may not appear
-- automatically. This logic ensures the dashboard is created.
--
-- Startup layout:
--
--     | NvimTree | Alpha |
--
-- Steps performed:
--   1. Apply GUI font
--   2. Detect if the first buffer is the NvimTree buffer
--   3. If so:
--        • Create a new vertical window
--        • Start alpha dashboard
--        • Resize NvimTree to a fixed width
----------------------------------------------------------------------

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- Apply GUI font (Neovide only)
		vim.o.guifont = normal_font

		-- Get information about the initial buffer
		local buf = vim.api.nvim_get_current_buf()

		-- "" means a normal editable buffer
		local buf_type = vim.api.nvim_buf_get_option(buf, "buftype")

		-- Example values: "NvimTree", "alpha", "TelescopePrompt"
		local file_type = vim.api.nvim_buf_get_option(buf, "filetype")

		-- Debug output (can be removed later)
		print("Buffer:", buf, "Buftype:", buf_type, "Filetype:", file_type)

		-- Only run this logic if:
		--   • running inside Neovide
		--   • buffer exists
		--   • current buffer is NvimTree
		if vim.g.neovide and buf > 0 and file_type == "NvimTree" then
			-- Create a new vertical split
			vim.cmd("vnew")

			-- Start alpha dashboard in the new window
			require("alpha").start()

			-- Resize the NvimTree sidebar
			vim.cmd.NvimTreeResize(30)
		end
	end,
})
