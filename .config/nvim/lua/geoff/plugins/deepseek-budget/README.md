# Deepseek Budget Plugin for Neovim

A custom Neovim plugin that displays your Deepseek API budget/balance information in the status line.

## Features

- **Real-time balance display**: Shows your current Deepseek API balance
- **Color-coded warnings**: Changes color when balance is low
- **Automatic refresh**: Updates balance every 5 minutes (configurable)
- **Caching**: Caches balance to reduce API calls
- **Lualine integration**: Seamlessly integrates with lualine.nvim
- **Neovide support**: Optional custom status line for Neovide
- **Global Neovide status bar**: Creates a dedicated status bar at the bottom of the Neovide window

## Installation

The plugin is already integrated into your Neovim configuration. It will be automatically loaded when you start Neovim.

## Configuration

### API Key Setup

1. **Environment Variable (Recommended)**:
   Add your Deepseek API key to `.config/nvim/.env`:
   ```
   DEEPSEEK_API_KEY=your_api_key_here
   ```

2. **Direct Configuration**:
   You can also set the API key directly in the plugin configuration in `deepseek-budget.lua`:
   ```lua
   api_key = "your_api_key_here",
   ```

### Plugin Configuration

The default configuration is set in `deepseek-budget.lua`. You can customize:

```lua
{
    -- API configuration
    api_key = os.getenv("DEEPSEEK_API_KEY"),
    refresh_interval = 300, -- 5 minutes in seconds
    display_format = "Deepseek: $%.2f",
    show_icon = true,
    icon = "", -- Nerd Font icon

    -- UI configuration
    position = "lualine_x", -- Where to display in lualine
    create_custom_statusline = false, -- Custom status line for Neovide

    -- Global Neovide status bar
    enable_neovide_global_bar = true, -- Enable global status bar
    global_bar_height = 1, -- Height in lines
    global_bar_position = "bottom", -- "bottom" or "top"

    -- Color thresholds
    warning_threshold = 10.0,  -- Yellow when balance < $10
    critical_threshold = 5.0,  -- Red when balance < $5
}
```

## Usage

### Status Line Display

The plugin automatically adds a component to your lualine status line (right side). It will show:
- **Normal**: ` Deepseek: $25.00` (green)
- **Warning**: ` Deepseek: $8.50` (yellow)
- **Critical**: ` Deepseek: $3.20` (red)
- **Error**: `Deepseek: --` (when API fails)

## Simplified Solution with Lualine Global Status Line

The plugin now uses a simplified approach that works perfectly with Neovide's global status line configuration:

### How it works

1. **Global status line**: When running in Neovide, `laststatus=3` is automatically set, making lualine a single global status line at the bottom of the window
2. **Lualine integration**: The Deepseek balance appears in the lualine status line (right side)
3. **No separate windows**: No additional windows or floating bars are created
4. **Automatic updates**: Balance refreshes every 5 minutes (configurable)

### Benefits

- ✅ **Clean integration**: Deepseek balance appears in the existing lualine status line
- ✅ **No duplication**: No separate windows or floating bars
- ✅ **Global visibility**: Balance is always visible at the bottom of the Neovide window
- ✅ **Color-coded**: Green/Yellow/Red based on balance thresholds
- ✅ **Automatic updates**: Refreshes automatically without manual intervention

### Configuration

The plugin works with default settings. No special configuration is needed for Neovide:

```lua
require("deepseek-budget").setup({
    -- Standard configuration options...
    refresh_interval = 300,           -- Refresh every 5 minutes
    display_format = "Deepseek: $%.2f", -- Display format
    show_icon = true,                 -- Show icon
    -- ... other options
})
```

### Testing

You can test the simplified solution with:

```lua
:lua require("deepseek-budget.test_simplified")()
```

### Commands

You can manually refresh the balance with the following command:

```vim
:lua require("deepseek-budget").refresh()
```

### API Information

The plugin uses the Deepseek API endpoint:
- **URL**: `https://api.deepseek.com/user/balance`
- **Method**: GET
- **Authentication**: Bearer token

## Troubleshooting

### Common Issues

1. **"API key not configured" warning**:
   - Check that `DEEPSEEK_API_KEY` is set in `.config/nvim/.env`
   - Verify the .env file is being loaded (check dotenv plugin)

2. **"Failed to fetch balance" error**:
   - Check your internet connection
   - Verify your API key is valid
   - Check if the Deepseek API endpoint is accessible

3. **Balance not showing in status line**:
   - Ensure lualine.nvim is installed and working
   - Check if the plugin is loaded: `:Lazy status`

4. **Global status bar not appearing in Neovide**:
   - Ensure you're running in Neovide (`vim.g.neovide` should be true)
   - Check that `enable_neovide_global_bar` is set to true
   - Restart Neovide after configuration changes

### Debugging

You can check the plugin status with:

```lua
:lua print(vim.inspect(require("deepseek-budget").get_status()))
```

## Customization

### Changing Display Format

Edit the `display_format` in the configuration. Available placeholders:
- `%s` - Balance as string
- `%.2f` - Balance as float with 2 decimal places

Example: `"DS: $%.1f"` would display as `DS: $25.0`

### Changing Refresh Interval

Set `refresh_interval` to the desired number of seconds:
- `60` = 1 minute
- `300` = 5 minutes (default)
- `1800` = 30 minutes

### Global Status Bar Configuration

Customize the global Neovide status bar:
- `enable_neovide_global_bar`: Enable/disable the global bar
- `global_bar_height`: Height in lines (default: 1)
- `global_bar_position`: "bottom" (default) or "top"

## Integration with Other Plugins

### Lualine

The plugin automatically adds itself to the `lualine_x` section. You can move it to a different section by modifying the `position` configuration.

### Dotenv

The plugin works seamlessly with the dotenv plugin to load your API key from the `.env` file.

## Development

### File Structure

```
.config/nvim/lua/geoff/plugins/
├── deepseek-budget.lua          # Plugin specification
└── deepseek-budget/
    ├── init.lua                 # Main plugin module
    └── README.md                # This documentation
```

### Testing

To test the plugin manually:

1. Set your API key in `.config/nvim/.env`
2. Restart Neovim
3. Check if the balance appears in the status line
4. Use `:lua require("deepseek-budget").refresh()` to force an update
5. In Neovide, check if the global status bar appears at the bottom

## License

This plugin is part of your personal dotfiles repository.

