----------------------------------------------------------------------
-- Neovide-specific Configuration
--
-- This module handles Neovide-specific settings including:
--   • Global status line configuration (laststatus=3)
--   • Custom status line with Deepseek balance
--   • GUI-specific optimizations for Neovide
----------------------------------------------------------------------

local M = {}

--- Setup Neovide-specific configuration
function M.setup()
    -- Only apply Neovide-specific settings
    if not vim.g.neovide then
        return
    end

    -- Set global status line
    vim.opt.laststatus = 3

    -- Configure custom status line
    M._setup_statusline()

    -- Apply Neovide-specific optimizations
    M._apply_neovide_optimizations()

    vim.notify("Neovide configuration loaded", vim.log.levels.INFO)
end

--- Setup custom status line with Deepseek balance
function M._setup_statusline()
    -- Create a custom status line function
    vim.opt.statusline = [[%!v:lua.require('geoff.core.neovide').statusline()]]
end

--- Custom status line function
-- This function is called by Neovim to render the status line
function M.statusline()
    local parts = {}

    -- Left side: Mode and file information
    table.insert(parts, "%{mode()}")
    table.insert(parts, " ")
    table.insert(parts, "%f")  -- File name
    table.insert(parts, " ")
    table.insert(parts, "%m")  -- Modified flag

    -- Middle: Git branch (if available)
    local git_branch = vim.b.gitsigns_head or ""
    if git_branch ~= "" then
        table.insert(parts, " ")
        table.insert(parts, " " .. git_branch)
    end

    -- Right side: Deepseek balance and other info
    table.insert(parts, "%=")  -- Right-align from here

    -- Try to get Deepseek balance
    local ok, deepseek_budget = pcall(require, "deepseek-budget")
    if ok then
        local balance_display = deepseek_budget.get_display()
        if type(balance_display) == "table" then
            table.insert(parts, balance_display[1] or balance_display.formatted or "")
        elseif type(balance_display) == "string" then
            table.insert(parts, balance_display)
        end
        table.insert(parts, " | ")
    end

    -- File type and encoding
    table.insert(parts, "%y")  -- File type
    table.insert(parts, " ")
    table.insert(parts, "%{&fileencoding?&fileencoding:&encoding}")
    table.insert(parts, " ")
    table.insert(parts, "[%l/%L]")  -- Line number

    return table.concat(parts, "")
end

--- Apply Neovide-specific optimizations
function M._apply_neovide_optimizations()
    -- Smooth scrolling
    vim.opt.smoothscroll = true

    -- Better cursor rendering
    vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

    -- Enable floating window transparency
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0

    -- Hide mouse when typing
    vim.opt.mousehide = true
end

--- Check if running in Neovide
-- @return boolean: True if running in Neovide
function M.is_neovide()
    return vim.g.neovide
end

return M
