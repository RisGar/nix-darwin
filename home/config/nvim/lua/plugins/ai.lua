return {}
	or {
		{
			"yetone/avante.nvim",
			build = "make",
			event = "VeryLazy",
			version = false, -- Never set this value to "*"! Never!
			---@module 'avante'
			---@type avante.Config
			opts = {
				provider = "copilot",
				mode = "agentic",
				providers = {
					deepseek = {
						__inherited_from = "openai",
						api_key_name = "DEEPSEEK_API_KEY",
						endpoint = "https://api.deepseek.com",
						model = "deepseek-reasoner",
					},
				},
				behaviour = {
					auto_suggestions = false, -- don't activate with copilot !!
				},
				web_search_engine = {
					provider = "tavily",
				},
				input = {
					provider = "snacks",
				},
				-- -- system_prompt as function ensures LLM always has latest MCP server state
				-- -- This is evaluated for every message, even in existing chats
				-- system_prompt = function()
				--   local hub = require("mcphub").get_hub_instance()
				--   return hub and hub:get_active_servers_prompt() or ""
				-- end,
				-- -- Using function prevents requiring mcphub before it's loaded
				-- custom_tools = function()
				--   return {
				--     require("mcphub.extensions.avante").mcp_tool(),
				--   }
				-- end,
				-- -- Disable duplicate tools with mcp
				-- disabled_tools = {
				--   "list_files", -- Built-in file operations
				--   "search_files",
				--   "read_file",
				--   "create_file",
				--   "rename_file",
				--   "delete_file",
				--   "create_dir",
				--   "rename_dir",
				--   "delete_dir",
				--   "bash", -- Built-in terminal access
				-- },
			},
			dependencies = {
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
				--- The below dependencies are optional,
				"nvim-tree/nvim-web-devicons",
				"zbirenbaum/copilot.lua",
				"MeanderingProgrammer/render-markdown.nvim",
				"folke/snacks.nvim",
				{
					-- support for image pasting
					"HakonHarnes/img-clip.nvim",
					event = "VeryLazy",
					opts = {
						-- recommended settings
						default = {
							embed_image_as_base64 = false,
							prompt_for_file_name = false,
							drag_and_drop = {
								insert_mode = true,
							},
						},
					},
				},
			},
		},

		-- {
		--   "ravitemer/mcphub.nvim",
		--   dependencies = {
		--     "nvim-lua/plenary.nvim",
		--   },
		--   build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
		--   opts = {
		--     extensions = {
		--       avante = {
		--         make_slash_commands = true, -- make /slash commands from MCP server prompts
		--       },
		--     },
		--   },
		-- },
	}
