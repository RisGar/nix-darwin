return {
	{ "nvim-lua/plenary.nvim" },

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@module "snacks"
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			image = {
				enabled = true,
				math = {
					enabled = false,
				},
			},
			indent = { enabled = true },
			input = { enabled = true },
			picker = {
				enabled = true,
				-- flash.nvim support in picker
				win = {
					input = {
						keys = {
							["<C-s>"] = { "flash", mode = { "n", "i" } },
							["s"] = { "flash" },
						},
					},
				},
				actions = {
					flash = function(picker)
						require("flash").jump({
							pattern = "^",
							label = { after = { 0, 0 } },
							search = {
								mode = "search",
								exclude = {
									function(win)
										return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
									end,
								},
							},
							action = function(match)
								local idx = picker.list:row2idx(match.pos[1])
								picker.list:_move(idx, true, true)
							end,
						})
					end,
				},
			},
			rename = { enabled = true },
			scope = { enabled = true },
			toggle = { enabled = true },
			words = { enabled = true },
		},
		config = function(_, opts)
			require("snacks").setup(opts)

			Snacks.toggle.inlay_hints():map("<leader>uh")
			Snacks.toggle.diagnostics():map("<leader>ud")

			-- rename support for oil.nvim
			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data.actions.type == "move" then
						Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
					end
				end,
			})
		end,
    -- stylua: ignore
    keys = {
      --- quick pickers
      { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "smart find files" },
      { "<leader>.",       function() Snacks.picker.buffers() end,                                 desc = "buffers" },
      { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "grep" },
      { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "cmd history" },
      -- { "<leader>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },

      --- find
      { "<leader>ff",      function() Snacks.picker.files({ ignored = true, hidden = true }) end,  desc = "find files" },
      { "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "git find" },
      { "<leader>f.",      function() Snacks.picker.recent() end,                                  desc = "recents" },
      { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "buffers" },
      { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "find in config" },
      { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "projects" },

      -- git
      { "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
      { "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
      { "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
      -- TODO:
      { "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
      { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      { "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
      { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },

      -- grep
      { "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "grep" },
      { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "buffer lines" },
      { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "grep open buffers" },

      -- search
      { "<leader>su",      function() Snacks.picker.undo() end,                                    desc = "undo history" },
      { "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "help pages" },
      { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "keymaps" },
      { "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "cmd history" },
      { '<leader>s/',      function() Snacks.picker.search_history() end,                          desc = "search history" },
      { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
      { "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "man pages" },
      { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "lsp Symbols" },
      { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "lsp workspace symbols" },
      { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },

      -- lsp gotos
      { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "goto definition" },
      { "gr",              function() Snacks.picker.lsp_references() end,                          desc = "references",           nowait = true },
      { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "goto implementation" },
      { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "goto type definition" },

      -- words
      { "]]",              function() Snacks.words.jump(vim.v.count1) end,                         desc = "Next Reference",       mode = { "n", "t" } },
      { "[[",              function() Snacks.words.jump(-vim.v.count1) end,                        desc = "Prev Reference",       mode = { "n", "t" } },
    },
	},

	{ "ThePrimeagen/vim-be-good" },

	{
		"https://codeberg.org/esensar/nvim-dev-container",
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
}
