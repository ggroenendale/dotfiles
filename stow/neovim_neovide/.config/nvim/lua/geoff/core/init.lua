-- Plugin list generator command
vim.api.nvim_create_user_command("ListPlugins", function(opts)
	local ok, list = pcall(require, "geoff.plugins.list-plugins")
	if not ok then
		vim.notify("list-plugins module not found", vim.log.levels.ERROR)
		return
	end

	local args = vim.split(opts.args or "", "%s+")
	local cmd = args[1] or "buffer"
	local filepath = args[2]

	if cmd == "md" or cmd == "save" then
		list.save_to_file(filepath)
	elseif cmd == "text" then
		local content = list.generate_text()
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))
		vim.api.nvim_set_current_buf(buf)
		vim.api.nvim_buf_set_option(buf, "modified", false)
	else
		list.open_buffer()
	end
end, {
	nargs = "*",
	desc = "List plugins. Usage: :ListPlugins | :ListPlugins md [path] | :ListPlugins text",
})

require("geoff.core.options")
require("geoff.core.keymaps")

-- Load GUI configuration if running in GUI mode
if vim.g.neovide or vim.fn.has("gui_running") == 1 then
    require("geoff.core.gui").setup()
end
