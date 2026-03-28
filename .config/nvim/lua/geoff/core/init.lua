require("geoff.core.options")
require("geoff.core.keymaps")

-- Load GUI configuration if running in GUI mode
if vim.g.neovide or vim.fn.has("gui_running") == 1 then
    require("geoff.core.gui").setup()
end
