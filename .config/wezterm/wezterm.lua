-- Pull in the wezterm API
local wezterm = require("wezterm")
local constants = require("constants")
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
--config.color_scheme = "AdventureTime"

-- Setup Nerd Font
config.font = wezterm.font("Mononoki Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 12

-- Optionally, enable ligatures (if the font supports it)
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

-- Get rid of title bar
config.window_decorations = "RESIZE"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Always start wezterm with maximized window.
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	local gui_win = window:gui_window()

	-- Use maximize to take up the available space between taskbar and top bar.
	gui_win:maximize()
end)

-- config.window_background_image = constants.bg_image
-- config.window_background_opacity = 0.5
config.background = constants.background

-- and finally, return the configuration to wezterm
return config
