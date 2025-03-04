local M = {}

M.bg_blurred_darker = os.getenv("HOME") .. "/.config/wezterm/assets/futuregreencity.jpg"
M.bg_blurred = os.getenv("HOME") .. "/.config/wezterm/assets/futuregreencity.jpg"
M.bg_image = M.bg_blurred_darker

M.background = {
	-- Backmost layer
	{
		source = {
			File = M.bg_blurred,
		},
		width = "100%",
		repeat_x = "NoRepeat",
		hsb = { brightness = 0.01 },
	},
}

return M
