-- Test script for Deepseek Budget Plugin
-- Usage: Run with `nvim -l test.lua`

local M = {}

function M.run_test()
    print("=== Deepseek Budget Plugin Test ===")

    -- Try to load the plugin
    local ok, deepseek_budget = pcall(require, "deepseek-budget")
    if not ok then
        print("❌ Failed to load deepseek-budget module")
        print("Error:", deepseek_budget)
        return false
    end

    print("✅ Plugin module loaded successfully")

    -- Check if API key is available
    local api_key = os.getenv("DEEPSEEK_API_KEY")
    if not api_key or api_key == "" then
        print("⚠️  DEEPSEEK_API_KEY environment variable not set")
        print("   Set it in .config/nvim/.env or via config")
    else
        print("✅ DEEPSEEK_API_KEY found (first 10 chars): " .. string.sub(api_key, 1, 10) .. "...")
    end

    -- Test plugin setup
    print("\nTesting plugin setup...")
    deepseek_budget.setup({
        api_key = api_key,
        refresh_interval = 10, -- Short interval for testing
        show_errors = true,
        cache_enabled = false, -- Disable cache for testing
    })

    -- Get plugin status
    local status = deepseek_budget.get_status()
    print("✅ Plugin initialized:", status.initialized)
    print("   Last fetch:", os.date("%H:%M:%S", status.last_fetch))

    -- Test balance fetching
    print("\nTesting balance fetch...")
    local balance = deepseek_budget.get_balance(true) -- Force refresh
    if balance then
        print("✅ Balance fetched: $" .. string.format("%.2f", balance))
    else
        print("⚠️  Could not fetch balance (API may be unavailable or key invalid)")
    end

    -- Test display function
    print("\nTesting display function...")
    local display = deepseek_budget.get_display()
    if type(display) == "table" then
        print("✅ Display (table format):", display[1])
    else
        print("✅ Display (string format):", display)
    end

    -- Test lualine component
    print("\nTesting lualine component...")
    local component = deepseek_budget.lualine_component()
    if type(component) == "function" then
        local result = component()
        print("✅ Lualine component works, returns:", result)
    else
        print("❌ Lualine component is not a function")
    end

    print("\n=== Test Complete ===")
    return true
end

-- Run test if script is executed directly
if arg and arg[0] and arg[0]:match("test.lua") then
    M.run_test()
end

return M

