return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		dependencies = {
			{
				"bezhermoso/tree-sitter-ghostty",
				build = "make nvim_install",
			},
		},
		config = function()
			local ts = require("nvim-treesitter")

			ts.install({ "stable", "unstable" }, { summary = true })

			local installed = {}
			for _, lang in ipairs(ts.get_installed("parsers")) do
				installed[lang] = true
			end

			local function have(ft)
				local lang = vim.treesitter.language.get_lang(ft)
				if lang == nil or installed[lang] == nil then
					return false
				end
				return true
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("nvim_treesitter", { clear = true }),
				callback = function(ev)
					if not have(ev.match) then
						return
					end

					vim.treesitter.start()
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})

			-- see: https://github.com/crystal-lang-tools/tree-sitter-crystal
			-- remove when support is upstreamed
			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",
				callback = function()
					require("nvim-treesitter.parsers").crystal = {
						install_info = {
							url = "https://github.com/crystal-lang-tools/tree-sitter-crystal",
							generate = false,
							generate_from_json = false,
							queries = "queries/nvim",
						},
					}
				end,
			})

			vim.treesitter.language.register("crystal", { "cr" })
		end,
	},

	{ -- Rainbow brackets
		url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
	},

	{ "wakatime/vim-wakatime", lazy = false },

	{
		"tris203/precognition.nvim",
		event = "VeryLazy",
		opts = { startVisible = false },
    -- stylua: ignore
    keys = {
      { "<leader>up", function() require("precognition").peek() end, desc = "show motions" },
    },
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			labels = "asdfghjklöäqwertyuiopüzxcvbnm",
			modes = {
				search = {
					enabled = true,
				},
			},
		},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "flash treesitter" },
      { "r",     mode = { "o" },           function() require("flash").remote() end,            desc = "remote flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "treesitter search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "toggle flash search" },
    },
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {},
	},

	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
    -- stylua: ignore
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "trouble diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "trouble buffer diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>",                  desc = "trouble symbols" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>",                      desc = "trouble lsp" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                  desc = "trouble location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                   desc = "trouble quickfix list" },
    },
	},

	{
		"MagicDuck/grug-far.nvim",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "search and replace",
			},
		},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		---@module "which-key"
		---@type wk.Opts
		opts = {
			preset = "helix",
			show_help = false, -- enable again after https://github.com/folke/which-key.nvim/issues/967 gets fixed
			spec = {
				{ "<leader>a", group = "ai", icon = { icon = " ", color = "orange" } },
				{ "<leader>c", group = "code" },
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>p", group = "plugins", icon = { icon = " ", color = "cyan" } },
				{ "<leader>s", group = "search" },
				{ "<leader>u", group = "ui" },
				{ "<leader>x", group = "diagnostics", icon = { icon = "󱖫 ", color = "green" } },
				{ "g", group = "goto" },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
				{ "gs", group = "surround" },
				{ "z", group = "fold" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		--   -- refer to `:h file-pattern` for more examples
		--   "BufReadPre path/to/my-vault/*.md",
		--   "BufNewFile path/to/my-vault/*.md",
		-- },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
		},
		opts = {
			workspaces = {
				{
					name = "University",
					path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/University",
				},
			},

			ui = { enable = false },
		},
	},
}
