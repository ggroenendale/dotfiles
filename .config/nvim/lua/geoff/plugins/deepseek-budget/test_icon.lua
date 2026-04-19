-- Test script for Deepseek icon display
-- This script tests that the Deepseek budget displays with icon instead of "Deepseek:" text

local function test_icon_display()
    print("Testing Deepseek icon display...")

    -- Test 1: Check if plugin loads
    local ok, deepseek_budget = pcall(require, "deepseek-budget")
    if ok then
        print("✓ Deepseek budget plugin loaded successfully")
    else
        print("✗ Failed to load Deepseek budget plugin: " .. tostring(deepseek_budget))
        return
    end

    -- Test 2: Check configuration
    local status = deepseek_budget.get_status()
    if status and status.config then
        print("✓ Plugin configuration loaded")

        -- Check display format
        local display_format = status.config.display_format
        print("  - Display format: '" .. display_format .. "'")

        -- Check if display format doesn't contain "Deepseek:"
        if not string.find(display_format, "Deepseek:") then
            print("✓ Display format does not contain 'Deepseek:' text")
        else
            print("✗ Display format still contains 'Deepseek:' text")
        end

        -- Check icon configuration
        local show_icon = status.config.show_icon
        local icon = status.config.icon
        print("  - Show icon: " .. tostring(show_icon))
        print("  - Icon: '" .. icon .. "'")

        if show_icon then
            print("✓ Icon display is enabled")
        else
            print("✗ Icon display is disabled")
        end
    else
        print("✗ Failed to get plugin status")
    end

    -- Test 3: Check get_display() output
    local display = deepseek_budget.get_display()
    if display then
        print("✓ get_display() returns: " .. tostring(display))

        -- Check if output contains icon
        if type(display) == "table" then
            local display_str = display[1] or display.formatted or ""
            print("  - Display string: '" .. display_str .. "'")

            -- Check if it starts with the icon
            local icon = status.config.icon
            if string.sub(display_str, 1, #icon) == icon then
                print("✓ Display starts with icon: '" .. icon .. "'")
            else
                print("✗ Display does not start with icon")
            end

            -- Check if it doesn't contain "Deepseek:"
            if not string.find(display_str, "Deepseek:") then
                print("✓ Display does not contain 'Deepseek:' text")
            else
                print("✗ Display still contains 'Deepseek:' text")
            end
        end
    else
        print("✗ get_display() returned nil")
    end

    -- Test 4: Check get_statusline_string() output
    local statusline_str = deepseek_budget.get_statusline_string()
    if statusline_str then
        print("✓ get_statusline_string() returns: '" .. statusline_str .. "'")

        -- Check if it doesn't contain "Deepseek:"
        if not string.find(statusline_str, "Deepseek:") then
            print("✓ Status line string does not contain 'Deepseek:' text")
        else
            print("✗ Status line string still contains 'Deepseek:' text")
        end
    else
        print("✗ get_statusline_string() returned nil")
    end

    print("\nTest completed!")
    print("\nExpected display format:")
    print("  Before:  Deepseek: $23.32")
    print("  After:   $23.32")
    print("\nThe 'Deepseek:' text has been replaced by just the icon.")
end

-- Run the test
test_icon_display()

