return {
  -- {
  --   "saghen/blink.compat",
  --   version = "2.*",
  --   lazy = true,
  --   opts = {},
  -- },

  {
    "saghen/blink.cmp",
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
      { "L3MON4D3/LuaSnip",          version = "v2.*" },
      { "xzbdmw/colorful-menu.nvim", opts = {} },
    },
    version = "1.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = "super-tab",
        ["gK"] = { "show_signature", "hide_signature", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        accept = { auto_brackets = { enabled = true } }, -- TODO: does not work?
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        trigger = { show_in_snippet = false },
        menu = {
          draw = {
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },

      snippets = { preset = "luasnip" },

      sources = {
        default = {
          "lsp",
          "buffer",
          "snippets",
          "path",
        },

        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
          AvanteInput = { "avante" },
          lua = { inherit_defaults = true, "lazydev" },
          markdown = { inherit_defaults = true, "markdown" },
        },

        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {},
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          dadbod = {
            name = "Dadbod",
            module = "vim_dadbod_completion.blink",
          },
          markdown = {
            name = "RenderMarkdown",
            module = "render-markdown.integ.blink",
          },
        },
      },

      signature = { enabled = true },

      fuzzy = { implementation = "prefer_rust_with_warning" },

      cmdline = {
        keymap = { preset = "inherit" },
        completion = { menu = { auto_show = true } },
      },
    },
    opts_extend = { "sources.default" },
  },

  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {},
  },

  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
      })
    end,
  },
}
