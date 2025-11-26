return {
	{ "mfussenegger/nvim-jdtls" },

	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		opts = {},
	},

	{
		"b0o/SchemaStore.nvim",
		version = false,
		config = function()
			-- Configure json
			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})
		end,
	},

	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
	},

	---- Markdown ----

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons", "saghen/blink.cmp" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			preset = "obsidian",
			completions = { blink = { enabled = true } },
			code = {
				sign = false,
			},
			heading = {
				position = "inline",
			},
			html = {
				comment = {
					conceal = false,
				},
			},
			latex = {
				enabled = false,
			},
		},
		ft = {
			"markdown",
			"Avante",
		},
	},

	{
		"p00f/clangd_extensions.nvim",
		lazy = true,
		opts = {
			ast = {
				role_icons = {
					type = "",
					declaration = "",
					expression = "",
					specifier = "",
					statement = "",
					["template argument"] = "",
				},

				kind_icons = {
					Compound = "",
					Recovery = "",
					TranslationUnit = "",
					PackExpansion = "",
					TemplateTypeParm = "",
					TemplateTemplateParm = "",
					TemplateParamObject = "",
				},
			},
			memory_usage = {
				border = "rounded",
			},
			symbol_info = {
				border = "rounded",
			},
		},
	},

	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		config = function()
			vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
			vim.g.vimtex_view_method = "zathura"
		end,
		keys = {
			{ "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
		},
	},

	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
}
