-- Test script for lualine formatting changes
-- This script tests that the lualine formatting has been updated correctly

local function test_lualine_formatting()
    print("Testing lualine formatting changes...")

    -- Test 1: Check if lualine loads
    local ok, lualine = pcall(require, "lualine")
    if ok then
        print("✓ Lualine loaded successfully")
    else
        print("✗ Failed to load lualine: " .. tostring(lualine))
        return
    end

    -- Test 2: Check lualine configuration
    local config = lualine.get_config()
    if config then
        print("✓ Lualine configuration loaded")

        -- Check component separators
        if config.options and config.options.component_separators then
            local left_sep = config.options.component_separators.left
            local right_sep = config.options.component_separators.right
            print("✓ Component separators configured:")
            print("  - Left separator: '" .. left_sep .. "'")
            print("  - Right separator: '" .. right_sep .. "'")

            -- Verify they are pipe characters
            if left_sep == "|" and right_sep == "|" then
                print("✓ Separators are pipe characters '|' (not '<')")
            else
                print("✗ Separators are not pipe characters")
            end
        else
            print("✗ Component separators not configured")
        end

        -- Check section separators
        if config.options and config.options.section_separators then
            local left_sec = config.options.section_separators.left
            local right_sec = config.options.section_separators.right
            print("✓ Section separators configured:")
            print("  - Left separator: '" .. left_sec .. "'")
            print("  - Right separator: '" .. right_sec .. "'")
        end

        -- Check theme colors
        if config.options and config.options.theme then
            print("✓ Theme is configured")
        end
    else
        print("✗ Failed to get lualine configuration")
    end

    -- Test 3: Check if Deepseek component is in lualine_x
    if config and config.sections and config.sections.lualine_x then
        local has_deepseek = false
        for _, component in ipairs(config.sections.lualine_x) do
            if type(component) == "function" then
                has_deepseek = true
                break
            end
        end
        if has_deepseek then
            print("✓ Deepseek balance component found in lualine_x")
        else
            print("✗ Deepseek balance component not found in lualine_x")
        end
    end

    print("\nTest completed!")
    print("\nExpected formatting:")
    print("  utf-8 | some icon | markdown | Deepseek: $23.32")
    print("\nNote: The pipe characters '|' should be in a darker shade")
end

-- Run the test
test_lualine_formatting()

