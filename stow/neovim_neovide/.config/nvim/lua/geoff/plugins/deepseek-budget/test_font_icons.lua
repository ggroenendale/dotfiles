-- Font and icon test for Neovide
-- This script tests different icon options to see what displays correctly

local function test_font_icons()
	print("Testing font and icon display in Neovide...")
	print("Current Neovide font: Mononoki Nerd Font Mono")
	print("")

	-- Test different icon options
	local test_icons = {
		-- Nerd Font icons (should work with Mononoki Nerd Font)
		{ name = "Nerd Font - Brain", icon = "" },
		{ name = "Nerd Font - Robot", icon = "󱜙" },
		{ name = "Nerd Font - Lightning", icon = "" },
		{ name = "Nerd Font - Atom", icon = "" },
		{ name = "Nerd Font - Cog", icon = "󰒓" },

		-- Emojis (should work universally)
		{ name = "Emoji - Robot", icon = "󱜚" },
		{ name = "Emoji - Brain", icon = "󰧑" },
		{ name = "Emoji - Lightning", icon = "󰠠" },
		{ name = "Emoji - Crystal Ball", icon = "󰬯" },
		{ name = "Emoji - Rocket", icon = "󱓟" },

		-- Text alternatives
		{ name = "Text - DS", icon = "DS:" },
		{ name = "Text - AI", icon = "AI:" },
		{ name = "Text - Deepseek", icon = "Deepseek:" },
	}

	print("Testing icons:")
	print("--------------")

	for _, test in ipairs(test_icons) do
		print(string.format("%-25s: %s $23.32", test.name, test.icon))
	end

	print("")
	print("Instructions:")
	print("1. Look at the output above")
	print("2. Check which icons display correctly")
	print("3. Note any that show as empty boxes or wrong characters")
	print("")
	print("If Nerd Font icons don't work, try:")
	print("1. Restart Neovide to reload fonts")
	print("2. Verify Mononoki Nerd Font is installed system-wide")
	print("3. Try emojis (they usually work better)")
	print("")

	-- Also test current Deepseek configuration
	local ok, deepseek_budget = pcall(require, "deepseek-budget")
	if ok then
		local status = deepseek_budget.get_status()
		if status and status.config then
			print("Current Deepseek configuration:")
			print("  Icon: '" .. status.config.icon .. "'")
			print("  Display format: '" .. status.config.display_format .. "'")
			print("  Show icon: " .. tostring(status.config.show_icon))
		end
	end
end

-- Run the test
test_font_icons()
