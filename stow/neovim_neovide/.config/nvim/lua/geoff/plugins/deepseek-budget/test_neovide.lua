-- Test script for Neovide global status line configuration
-- This script tests the Deepseek budget plugin with global status line

local function test_neovide_config()
    print("Testing Neovide global status line configuration...")

    -- Check if running in Neovide
    if vim.g.neovide then
        print("✓ Running in Neovide")
    else
        print("✗ Not running in Neovide (simulating for test)")
        vim.g.neovide = true
    end

    -- Check laststatus setting
    local laststatus = vim.opt.laststatus:get()
    print("laststatus value: " .. laststatus)
    if laststatus == 3 then
        print("✓ Global status line enabled (laststatus=3)")
    else
        print("✗ Global status line not enabled")
    end

    -- Check statusline configuration
    local statusline = vim.opt.statusline:get()
    if statusline and statusline ~= "" then
        print("✓ Custom status line configured")
    else
        print("✗ No custom status line configured")
    end

    -- Test Deepseek budget plugin
    local ok, deepseek_budget = pcall(require, "deepseek-budget")
    if ok then
        print("✓ Deepseek budget plugin loaded")

        -- Test get_display function
        local display = deepseek_budget.get_display()
        if display then
            print("✓ get_display() returns: " .. tostring(display))
        else
            print("✗ get_display() returned nil")
        end

        -- Test get_statusline_string function
        local statusline_str = deepseek_budget.get_statusline_string()
        if statusline_str then
            print("✓ get_statusline_string() returns: " .. tostring(statusline_str))
        else
            print("✗ get_statusline_string() returned nil")
        end
    else
        print("✗ Failed to load Deepseek budget plugin: " .. tostring(deepseek_budget))
    end

    print("\nTest completed!")
end

-- Run the test
test_neovide_config()

