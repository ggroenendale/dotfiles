return {
	"xiyaowong/transparent.nvim",
	config = function()
		require("transparent").setup({
			enable = true,
			extra_groups = {
				"NormalFloat",
				"NvimTreeNormal",
				"TelescopeNormal",
			},
			exclude_groups = {},
		})
	end,
}
