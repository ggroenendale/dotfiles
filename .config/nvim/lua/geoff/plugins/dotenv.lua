return {
	"SergioRibera/cmp-dotenv",
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	event = "VimEnter",
	config = function()
		-- Function to load environment variables from .env file
		local function load_env_variables()
			local env_path = vim.fn.stdpath("config") .. "/.env"

			-- Check if .env file exists
			if vim.fn.filereadable(env_path) ~= 1 then
				vim.notify("No .env file found at " .. env_path, vim.log.levels.WARN)
				return false
			end

			-- Read the .env file
			local lines = {}
			for line in io.lines(env_path) do
				table.insert(lines, line)
			end

			-- Parse and set environment variables
			local loaded_count = 0
			for _, line in ipairs(lines) do
				-- Skip comments and empty lines
				if line and #line > 0 and not line:match("^%s*#") then
					local key, value = line:match("^([^=]+)=(.+)$")
					if key and value then
						key = key:gsub("%s+$", "") -- Trim trailing whitespace
						value = value:gsub("^%s+", ""):gsub("%s+$", "") -- Trim whitespace

						-- Remove quotes if present
						value = value:gsub('^"(.*)"$', "%1")
						value = value:gsub("^'(.*)'$", "%1")

						-- Set environment variable using multiple methods
						-- Method 1: vim.fn.setenv (for Neovim internal use)
						vim.fn.setenv(key, value)

						-- Method 2: os.setenv if available (for child processes)
						if os.setenv then
							os.setenv(key, value)
						end

						-- Method 3: Set in os.environ table
						os.environ = os.environ or {}
						os.environ[key] = value

						loaded_count = loaded_count + 1

						-- Debug: Check for TAVILY_API_KEY
						if key == "TAVILY_API_KEY" then
							vim.notify("TAVILY_API_KEY loaded: " .. string.sub(value, 1, 10) .. "...")

							-- Debug: Check if it's actually set
							local check_key = os.getenv("TAVILY_API_KEY")
							if check_key then
								print("Verified TAVILY_API_KEY in os.getenv: " .. string.sub(check_key, 1, 10) .. "...")
							else
								vim.notify("WARNING: TAVILY_API_KEY not found in os.getenv()", vim.log.levels.WARN)
							end
						end
					end
				end
			end

			if loaded_count > 0 then
				--vim.notify("Loaded " .. loaded_count .. " environment variables from " .. env_path)
				return true
			else
				vim.notify("No valid environment variables found in " .. env_path, vim.log.levels.WARN)
				return false
			end
		end

		-- Load environment variables on startup
		load_env_variables()

		-- Also try cmp-dotenv for autocompletion
		local success, dotenv = pcall(require, "cmp-dotenv.dotenv")
		if success then
			local env_path = vim.fn.stdpath("config") .. "/.env"
			if vim.fn.filereadable(env_path) == 1 then
				pcall(function()
					dotenv.load(true, { path = vim.fn.stdpath("config") })
				end)
			end
		end

		-- Set up autocompletion for .env files
		require("cmp").setup({
			sources = {
				{ name = "dotenv" },
			},
		})
	end,
}
