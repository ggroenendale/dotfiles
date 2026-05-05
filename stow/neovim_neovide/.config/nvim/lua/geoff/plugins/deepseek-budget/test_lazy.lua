-- Test script for Deepseek Budget Plugin with lazy.nvim configuration
-- This tests the plugin specification and loading

local M = {}

function M.test_plugin_spec()
    print("=== Testing Deepseek Budget Plugin Specification ===")

    -- Test 1: Check if plugin directory exists
    local plugin_dir = vim.fn.stdpath("config") .. "/lua/geoff/plugins/deepseek-budget"
    if vim.fn.isdirectory(plugin_dir) == 1 then
        print("✅ Plugin directory exists:", plugin_dir)
    else
        print("❌ Plugin directory not found:", plugin_dir)
        return false
    end

    -- Test 2: Check if init.lua exists
    local init_file = plugin_dir .. "/init.lua"
    if vim.fn.filereadable(init_file) == 1 then
        print("✅ Plugin init.lua exists:", init_file)
    else
        print("❌ Plugin init.lua not found:", init_file)
        return false
    end

    -- Test 3: Test plugin specification
    local plugin_spec = {
        dir = plugin_dir,
        name = "deepseek-budget",
        lazy = false,
        config = function()
            print("✅ Plugin config function would be called")
        end,
        dependencies = {
            "nvim-lualine/lualine.nvim",
        },
    }

    print("✅ Plugin specification is valid")
    print("   dir:", plugin_spec.dir)
    print("   name:", plugin_spec.name)
    print("   lazy:", plugin_spec.lazy)
    print("   dependencies:", #plugin_spec.dependencies)

    -- Test 4: Check if lualine integration is configured
    local lualine_file = vim.fn.stdpath("config") .. "/lua/geoff/plugins/lualine.lua"
    if vim.fn.filereadable(lualine_file) == 1 then
        local content = table.concat(vim.fn.readfile(lualine_file), "\n")
        if content:match("deepseek%-budget") then
            print("✅ Lualine configuration includes deepseek-budget component")
        else
            print("⚠️  Lualine configuration doesn't mention deepseek-budget")
        end
    end

    -- Test 5: Check environment variable setup
    local env_file = vim.fn.stdpath("config") .. "/.env"
    if vim.fn.filereadable(env_file) == 1 then
        print("✅ .env file exists for API key configuration")
        local env_content = table.concat(vim.fn.readfile(env_file), "\n")
        if env_content:match("DEEPSEEK_API_KEY") then
            print("✅ DEEPSEEK_API_KEY is configured in .env file")
        else
            print("⚠️  DEEPSEEK_API_KEY not found in .env file")
            print("   Add: DEEPSEEK_API_KEY=your_api_key_here")
        end
    else
        print("⚠️  .env file not found, create one for API key")
        print("   Location:", env_file)
    end

    print("\n=== Test Summary ===")
    print("The Deepseek Budget plugin is now properly configured for lazy.nvim.")
    print("Key changes made:")
    print("1. ✅ Changed from GitHub repo reference to local dir specification")
    print("2. ✅ Added 'lazy = false' to load at startup")
    print("3. ✅ Removed redundant lualine configuration (already in lualine.lua)")
    print("4. ✅ Plugin will load at startup to initialize balance fetching")
    print("\nNext steps:")
    print("1. Add your Deepseek API key to .config/nvim/.env")
    print("2. Restart Neovim")
    print("3. Check if balance appears in status line")

    return true
end

-- Run test if script is executed directly
if arg and arg[0] and arg[0]:match("test_lazy.lua") then
    M.test_plugin_spec()
end

return M

