----------------------------------------------------------------------
-- Deepseek Budget Plugin for Neovim
--
-- This plugin displays Deepseek API budget/balance information
-- in the Neovim status line (lualine) or as a custom status bar.
--
-- Features:
--   • Fetches balance from Deepseek API
--   • Configurable refresh intervals
--   • Customizable display format
--   • Error handling and caching
--   • Integration with lualine.nvim
----------------------------------------------------------------------

local M = {}

-- Default configuration
local default_config = {
	-- API configuration
	api_key = nil, -- Deepseek API key (required)
	api_url = "https://api.deepseek.com", -- Deepseek API base URL
	balance_endpoint = "/user/balance", -- Balance endpoint

	-- Display configuration
	refresh_interval = 300, -- Refresh interval in seconds (5 minutes)
	display_format = "$%.2f", -- Display format (use %s for balance) - Just show balance without "Deepseek:" text
	show_icon = true, -- Show icon in status line
	icon = "", -- Icon to display (Nerd Font Atom icon - confirmed to work with Mononoki Nerd Font Mono)

	-- UI configuration
	position = "lualine_x", -- Where to display: "lualine_x", "lualine_y", "lualine_z"

	-- Cache configuration
	cache_enabled = true, -- Enable caching of balance
	cache_duration = 60, -- Cache duration in seconds

	-- Error handling
	show_errors = true, -- Show error messages
	error_format = "Deepseek: Error", -- Format for error display
	fallback_text = "Deepseek: --", -- Text to show when API fails

	-- Colors
	normal_color = "#3EFFDC", -- Normal color (green)
	warning_color = "#FFDA7B", -- Warning color (yellow, when balance < warning_threshold)
	critical_color = "#FF4A4A", -- Critical color (red, when balance < critical_threshold)
	warning_threshold = 10.0, -- Warning threshold in dollars
	critical_threshold = 5.0, -- Critical threshold in dollars
}

-- Plugin state
local state = {
	config = {},
	balance = nil,
	last_fetch = 0,
	timer = nil,
	cache = {},
	is_initialized = false,
}

----------------------------------------------------------------------
-- Private Functions
----------------------------------------------------------------------

--- Fetch balance from Deepseek API
-- @return number|nil: Balance in dollars, or nil on error
local function fetch_balance()
	local config = state.config

	-- Check if API key is configured
	if not config.api_key or config.api_key == "" then
		vim.notify("Deepseek Budget: API key not configured", vim.log.levels.WARN)
		return nil
	end

	-- Check cache first
	if config.cache_enabled and state.cache.balance and state.cache.expires_at then
		if os.time() < state.cache.expires_at then
			return state.cache.balance
		end
	end

	-- Make HTTP request using curl (fallback if vim.system not available)
	local url = config.api_url .. config.balance_endpoint

	-- Try using vim.system first (Neovim 0.10+)
	local balance = nil
	local success = false

	if vim.system then
		local command = {
			"curl",
			"-s",
			"-X",
			"GET",
			"-H",
			"Authorization: Bearer " .. config.api_key,
			"-H",
			"Content-Type: application/json",
			url,
		}

		local result = vim.system(command):wait()

		if result.code == 0 then
			-- Parse response
			local ok, data = pcall(vim.json.decode, result.stdout)
			if ok and data then
				-- Extract balance from Deepseek API response
				-- Response format: {"is_available":true,"balance_infos":[{"currency":"USD","total_balance":"6.12",...}]}
				if data.balance_infos and #data.balance_infos > 0 then
					local balance_info = data.balance_infos[1]
					if balance_info.total_balance then
						balance = tonumber(balance_info.total_balance)
					end
				-- Fallback for other possible response structures
				elseif data.balance then
					balance = tonumber(data.balance)
				elseif data.amount then
					balance = tonumber(data.amount)
				elseif data.credit then
					balance = tonumber(data.credit)
				end
				success = true
			end
		end
	else
		-- Fallback to using io.popen for older Neovim versions
		local command = string.format(
			"curl -s -X GET -H 'Authorization: Bearer %s' -H 'Content-Type: application/json' '%s'",
			config.api_key,
			url
		)

		local handle = io.popen(command)
		if handle then
			local result = handle:read("*a")
			handle:close()

			local ok, data = pcall(vim.json.decode, result)
			if ok and data then
				if data.balance then
					balance = tonumber(data.balance)
				elseif data.amount then
					balance = tonumber(data.amount)
				elseif data.credit then
					balance = tonumber(data.credit)
				end
				success = true
			end
		end
	end

	if not success and config.show_errors then
		vim.notify("Deepseek Budget: Failed to fetch balance", vim.log.levels.ERROR)
	end

	-- Update cache
	if balance and config.cache_enabled then
		state.cache.balance = balance
		state.cache.expires_at = os.time() + config.cache_duration
	end

	return balance
end

--- Format balance for display
-- @param balance number|nil: Balance in dollars
-- @return string|table: Formatted balance string or lualine component table
local function format_balance(balance)
	local config = state.config

	if balance == nil then
		return config.fallback_text
	end

	-- Determine color based on balance
	local color = config.normal_color
	if balance < config.critical_threshold then
		color = config.critical_color
	elseif balance < config.warning_threshold then
		color = config.warning_color
	end

	-- Format the balance
	local formatted = string.format(config.display_format, balance)

	-- Add icon if enabled
	if config.show_icon then
		formatted = config.icon .. " " .. formatted
	end

	-- Return as lualine component table
	return {
		formatted,
		color = { fg = color },
	}
end

--- Get current balance (with caching)
-- @return string: Formatted balance string for display
local function get_balance_display()
	local config = state.config

	-- Check if we need to refresh
	local now = os.time()
	if state.balance == nil or (now - state.last_fetch) >= config.refresh_interval then
		state.balance = fetch_balance()
		state.last_fetch = now
	end

	return format_balance(state.balance)
end

--- Setup refresh timer
local function setup_timer()
	local config = state.config

	-- Clear existing timer
	if state.timer then
		state.timer:close()
		state.timer = nil
	end

	-- Create new timer
	state.timer = vim.loop.new_timer()
	state.timer:start(
		config.refresh_interval * 1000, -- Initial delay
		config.refresh_interval * 1000, -- Repeat interval
		vim.schedule_wrap(function()
			state.balance = fetch_balance()
			-- Don't force lualine refresh, let it refresh naturally
			-- The balance will be updated and shown on next lualine refresh
		end)
	)
end

----------------------------------------------------------------------
-- Public API
----------------------------------------------------------------------

--- Setup the plugin
-- @param user_config table: User configuration (optional)
function M.setup(user_config)
	-- Merge user config with defaults
	state.config = vim.tbl_deep_extend("force", default_config, user_config or {})

	-- Validate API key
	if not state.config.api_key then
		-- Try to get from environment variable
		state.config.api_key = os.getenv("DEEPSEEK_API_KEY")

		if not state.config.api_key then
			vim.notify(
				"Deepseek Budget: API key not found. Set via config or DEEPSEEK_API_KEY env var",
				vim.log.levels.WARN
			)
		end
	end

	-- Initialize state
	state.is_initialized = true

	-- Setup refresh timer
	setup_timer()

	-- Initial fetch
	state.balance = fetch_balance()

	--vim.notify("Deepseek Budget plugin initialized", vim.log.levels.INFO)
end

--- Get current balance
-- @param force_refresh boolean: Force refresh from API (optional)
-- @return number|nil: Current balance in dollars
function M.get_balance(force_refresh)
	if force_refresh then
		state.balance = fetch_balance()
		state.last_fetch = os.time()
	end

	return state.balance
end

--- Manually refresh balance
function M.refresh()
	state.balance = fetch_balance()
	state.last_fetch = os.time()

	-- Update lualine if it's loaded
	if package.loaded["lualine"] then
		require("lualine").refresh()
	end

	vim.notify("Deepseek balance refreshed", vim.log.levels.INFO)
end

--- Get display string for status line
-- @return string|table: Formatted balance display (string or table with formatted field)
function M.get_display()
	return get_balance_display()
end

--- Get status line string (for use with laststatus=3)
-- @return string: Formatted status line string
function M.get_statusline_string()
	local balance_display = get_balance_display()
	-- For status line, we need a plain string
	if type(balance_display) == "table" then
		return balance_display[1] or balance_display.formatted or ""
	end
	return balance_display
end

--- Create custom status line (for Neovide with laststatus=3)
-- @return function: Status line function
function M.create_statusline()
	return function()
		local balance_display = get_balance_display()
		-- For custom status line, we need to handle both string and table formats
		if type(balance_display) == "table" then
			return balance_display[1]
		end
		return balance_display
	end
end

--- Update configuration
-- @param new_config table: New configuration values
function M.update_config(new_config)
	state.config = vim.tbl_deep_extend("force", state.config, new_config or {})

	-- Restart timer with new interval
	if state.timer then
		setup_timer()
	end

	vim.notify("Deepseek Budget configuration updated", vim.log.levels.INFO)
end

--- Get plugin status
-- @return table: Plugin status information
function M.get_status()
	return {
		initialized = state.is_initialized,
		balance = state.balance,
		last_fetch = state.last_fetch,
		config = state.config,
	}
end

return M
