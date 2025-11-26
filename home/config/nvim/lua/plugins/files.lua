return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			delete_to_trash = true,
			view_options = {
				show_hidden = true,
			},
		},
		cmd = "Oil",
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>e", "<cmd>Oil<cr>", desc = "file explorer" },
		},
		lazy = false,
	},
}
