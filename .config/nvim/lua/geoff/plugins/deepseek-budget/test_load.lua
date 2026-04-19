-- Test: Simulate lazy.nvim loading the deepseek-budget plugin
print("=== Testing deepseek-budget plugin loading ===")

-- Get the plugin directory path
local plugin_dir = vim.fn.stdpath("config") .. "/lua/geoff/plugins/deepseek-budget"
print("Plugin directory:", plugin_dir)

-- Check if the directory exists
if vim.fn.isdirectory(plugin_dir) == 1 then
    print("✅ Plugin directory exists")
else
    print("❌ Plugin directory not found")
    return
end

-- Check if deepseek-budget.lua exists
local plugin_file = plugin_dir .. "/deepseek-budget.lua"
if vim.fn.filereadable(plugin_file) == 1 then
    print("✅ Plugin file exists:", plugin_file)
else
    print("❌ Plugin file not found:", plugin_file)
    return
end

-- Try to add the plugin directory to package.path
local original_path = package.path
package.path = package.path .. ";" .. plugin_dir .. "/?.lua"
print("Added plugin directory to package.path")

-- Try to require the plugin
print("Attempting to require 'deepseek-budget'...")
local ok, plugin = pcall(require, "deepseek-budget")
if ok then
    print("✅ Plugin loaded successfully")
    print("Plugin type:", type(plugin))

    -- Check if plugin has setup function
    if type(plugin.setup) == "function" then
        print("✅ Plugin has setup function")

        -- Test setup with minimal configuration
        local test_config = {
            api_key = "test_key",
            refresh_interval = 10,
            show_errors = false,
        }

        local setup_ok, setup_result = pcall(plugin.setup, test_config)
        if setup_ok then
            print("✅ Plugin setup successful")
        else
            print("❌ Plugin setup failed:", setup_result)
        end
    else
        print("❌ Plugin doesn't have setup function")
    end
else
    print("❌ Failed to load plugin:", plugin)
    print("Current package.path:", package.path)
end

-- Restore original package.path
package.path = original_path
print("\n=== Test complete ===")

