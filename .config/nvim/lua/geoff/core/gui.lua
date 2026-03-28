----------------------------------------------------------------------
-- GUI Configuration Module
--
-- This module handles GUI-specific settings for Neovim, including:
--   • Mouse and input behavior
--   • Context menus
--   • GUI-specific optimizations
--
-- The configuration is organized into submodules for better maintainability.
----------------------------------------------------------------------

local M = {}

-- Table to track which GUI modules are loaded
M.loaded_modules = {}

----------------------------------------------------------------------
-- Public API
----------------------------------------------------------------------

--- Setup all GUI configurations
-- This function initializes all GUI-related settings by loading
-- the appropriate submodules based on the current environment.
function M.setup()
	-- Enable basic GUI features
	M._enable_basic_gui_features()

	-- Load context menu configuration
	M._load_context_menu()

	-- Apply GUI-specific optimizations
	M._apply_gui_optimizations()

	--vim.notify("GUI configuration loaded", vim.log.levels.INFO)
end

--- Setup specific GUI module
-- @param module_name string: Name of the module to load (e.g., "context_menu")
function M.setup_module(module_name)
	if module_name == "context_menu" then
		M._load_context_menu()
	elseif module_name == "mouse" then
		M._enable_basic_gui_features()
	else
		vim.notify("Unknown GUI module: " .. module_name, vim.log.levels.WARN)
	end
end

----------------------------------------------------------------------
-- Private Functions
----------------------------------------------------------------------

--- Enable basic GUI features like mouse support
function M._enable_basic_gui_features()
	-- Enable mouse in all modes
	vim.o.mouse = "a"

	-- Set mousemodel to popup for right-click context menus
	vim.o.mousemodel = "popup"

	-- Hide mouse pointer while typing
	vim.o.mousehide = true

	M.loaded_modules.mouse = true
end

--- Load and configure context menus
function M._load_context_menu()
	-- Safely require the context menu module
	local ok, context_menu = pcall(require, "geoff.core.gui-context-menu")
	if ok then
		context_menu.setup()
		M.loaded_modules.context_menu = true
	else
		vim.notify("Failed to load context menu module: " .. context_menu, vim.log.levels.ERROR)
	end
end

--- Apply GUI-specific optimizations
function M._apply_gui_optimizations()
	-- Only apply these optimizations when running in a GUI
	if vim.g.neovide or vim.fn.has("gui_running") == 1 then
		-- Smooth scrolling for GUI
		vim.o.smoothscroll = true

		-- Enable cursorline in GUI for better visual feedback
		vim.o.cursorline = true

		-- Use GUI colors
		vim.o.termguicolors = true

		M.loaded_modules.optimizations = true
	end
end

----------------------------------------------------------------------
-- Utility Functions
----------------------------------------------------------------------

--- Check if running in GUI mode
-- @return boolean: True if running in GUI, false otherwise
function M.is_gui()
	return vim.g.neovide or vim.fn.has("gui_running") == 1
end

--- Get list of loaded GUI modules
-- @return table: Table of loaded module names
function M.get_loaded_modules()
	local modules = {}
	for name, loaded in pairs(M.loaded_modules) do
		if loaded then
			table.insert(modules, name)
		end
	end
	return modules
end

return M
