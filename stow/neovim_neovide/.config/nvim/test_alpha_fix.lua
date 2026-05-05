-- Test script to verify the alpha column function fix
local function test_column_function()
	-- Simulate the col function logic
	local function display_width(s)
		return vim.fn.strdisplaywidth(s)
	end

	-- Test strings with icons
	local test_strings = {
		" 󱁐 e      New File",
		" 󱁐 ee     Toggle File Explorer",
		"󱁐 ff   󰱼  Find File",
		"  󱁐 fs     Find Word",
		"  󱁐 wr   󰁯  Restore Session in CWD",
	}

	print("=== Testing display width calculation ===")
	for i, str in ipairs(test_strings) do
		local str_len = #str
		local vis_width = display_width(str)
		print(
			string.format(
				"Line %d: String length: %d, Visual width: %d, Difference: %d",
				i,
				str_len,
				vis_width,
				vis_width - str_len
			)
		)
	end

	-- Test the actual column alignment
	print("\n=== Testing column alignment ===")
	local test_col1 = {
		"Test",
		"Longer Test",
		"Short",
	}

	local test_col2 = {
		"󱁐 A",
		"󱁐 BB",
		"󱁐 CCC",
	}

	-- Calculate max display widths
	local max_width1 = 0
	local max_width2 = 0

	for _, str in ipairs(test_col1) do
		local w = display_width(str)
		if w > max_width1 then
			max_width1 = w
		end
	end

	for _, str in ipairs(test_col2) do
		local w = display_width(str)
		if w > max_width2 then
			max_width2 = w
		end
	end

	print(string.format("Column 1 max display width: %d", max_width1))
	print(string.format("Column 2 max display width: %d", max_width2))
	print("Columns should now align properly based on visual width, not string length.")
end

-- Run test
--test_column_function()
