----------------------------------------------------------------------
-- GUI Context Menu Configuration
--
-- This module defines right-click context menus (PopUp menus) for Neovim.
-- The menus provide quick access to common editing operations including
-- the requested "comment highlighted lines" functionality.
--
-- Requirements:
--   • Mouse support enabled (vim.o.mouse = "a")
--   • Mousemodel set to popup (vim.o.mousemodel = "popup")
--   • Comment.nvim plugin properly configured
----------------------------------------------------------------------

local M = {}

----------------------------------------------------------------------
-- Public API
----------------------------------------------------------------------

--- Setup context menus
-- This function defines all right-click context menu items
function M.setup()
	-- Clear any existing PopUp menus to avoid duplicates
	--M._clear_existing_menus()

	-- Define the main PopUp menu structure
	--M._define_popup_menus()

	--vim.notify("Context menus configured", vim.log.levels.INFO)
end

----------------------------------------------------------------------
-- Private Functions
----------------------------------------------------------------------

--- Clear existing PopUp menus
-- This prevents duplicate menu items when reloading configuration
function M._clear_existing_menus()
	vim.cmd([[
        silent! unmenu PopUp
    ]])
end

--- Define all PopUp menu items
function M._define_popup_menus()
	-- Define menu items using vim.cmd for compatibility
	vim.cmd([[
        " ======================================================================
        " Comment Operations
        " ======================================================================
        
        " Comment selected lines (visual mode)
        menu PopUp.Comment\ Selection :CommentToggle<CR>
        
        " Comment current line (normal mode)
        menu PopUp.Comment\ Line gcc
        
        " Uncomment selected lines
        menu PopUp.Uncomment\ Selection :CommentToggle<CR>
        
        " Separator
        menu PopUp.-sep1- :
        
        " ======================================================================
        " Clipboard Operations
        " ======================================================================
        
        " Cut selection to system clipboard
        menu PopUp.Cut "+x
        
        " Copy selection to system clipboard
        menu PopUp.Copy "+y
        
        " Paste from system clipboard
        menu PopUp.Paste "+p
        
        " Separator
        menu PopUp.-sep2- :
        
        " ======================================================================
        " File Operations
        " ======================================================================
        
        " File submenu
        menu PopUp.File.Open :edit<CR>
        menu PopUp.File.Save :write<CR>
        menu PopUp.File.Save\ All :wa<CR>
        menu PopUp.File.Close :bd<CR>
        
        " Separator
        menu PopUp.-sep3- :
        
        " ======================================================================
        " Editing Operations
        " ======================================================================
        
        " Delete selected text
        menu PopUp.Delete x
        
        " Duplicate selection
        menu PopUp.Duplicate yp
        
        " Change case of selection
        menu PopUp.Change\ Case ~
        
        " Indent operations
        menu PopUp.Indent.Right >>
        menu PopUp.Indent.Left <<
        menu PopUp.Indent.Auto =
        
        " Separator
        menu PopUp.-sep4- :
        
        " ======================================================================
        " LSP Operations (when LSP is active)
        " ======================================================================
        
        " Rename symbol under cursor
        menu PopUp.LSP.Rename :lua vim.lsp.buf.rename()<CR>
        
        " Show code actions
        menu PopUp.LSP.Code\ Action :lua vim.lsp.buf.code_action()<CR>
        
        " Go to definition
        menu PopUp.LSP.Go\ to\ Definition :lua vim.lsp.buf.definition()<CR>
        
        " Show references
        menu PopUp.LSP.Show\ References :lua vim.lsp.buf.references()<CR>
        
        " Show hover information
        menu PopUp.LSP.Hover :lua vim.lsp.buf.hover()<CR>
        
        " Separator
        menu PopUp.-sep5- :
        
        " ======================================================================
        " Search & Navigation
        " ======================================================================
        
        " Find in file
        menu PopUp.Search.Find\ in\ File /
        
        " Find and replace
        menu PopUp.Search.Replace :%s//gc<Left><Left><Left>
        
        " Find next occurrence
        menu PopUp.Search.Next n
        
        " Find previous occurrence
        menu PopUp.Search.Previous N
    ]])
end

----------------------------------------------------------------------
-- Utility Functions
----------------------------------------------------------------------

--- Check if Comment.nvim is available
-- @return boolean: True if Comment.nvim is loaded, false otherwise
function M.is_comment_available()
	local ok, _ = pcall(require, "Comment")
	return ok
end

--- Check if LSP is active for current buffer
-- @return boolean: True if LSP is active, false otherwise
function M.is_lsp_active()
	return vim.lsp.buf_get_clients(0) ~= nil and #vim.lsp.buf_get_clients(0) > 0
end

--- Get list of available context menu categories
-- @return table: List of menu categories
function M.get_menu_categories()
	return {
		"Comment Operations",
		"Clipboard Operations",
		"File Operations",
		"Editing Operations",
		"LSP Operations",
		"Search & Navigation",
	}
end

--- Reload context menus
-- Useful for development or when plugins change
function M.reload()
	M.setup()
	--vim.notify("Context menus reloaded", vim.log.levels.INFO)
end

return M
