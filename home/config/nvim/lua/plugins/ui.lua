return {
  { -- One Dark Pro theme from Atom
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    opts = {
      options = {
        transparency = true,
        cursorline = true,
        lualine_transparency = true,
      },
      highlights = {
        SnacksIndentScope = { fg = "${fg}" },
        Cursor = { bg = "#5188FA", fg = "${white}" },
      },
      styles = {
        comments = "italic",
        keywords = "bold",
      },
    },
    config = function(_, opts)
      require("onedarkpro").setup(opts)
      vim.cmd.colorscheme("onedark")
      -- vim.cmd.hi("Comment gui=none")`norg`, `scss`, `tsx`
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        component_separators = "",
        section_separators = "",
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {},
  },


	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = function()
			local tsc = require("treesitter-context")
			Snacks.toggle({
				name = "treesitter context",
				get = tsc.enabled,
				set = function(state)
					if state then
						tsc.enable()
					else
						tsc.disable()
					end
				end,
			}):map("<leader>ut")
			return { mode = "cursor", max_lines = 3 }
		end,
	},
}
