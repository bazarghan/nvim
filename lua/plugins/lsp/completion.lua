return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- LSP completion source
      "hrsh7th/cmp-nvim-lsp",
      -- Other useful completion sources
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",

      -- Snippet engine
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
      },
      -- Snippet completion source
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        -- Enable snippet support
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- Key Cntrls for completion
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- Move up
          ["<C-j>"] = cmp.mapping.select_next_item(), -- Move down
          ["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept completion
        }),
        -- The sources cmp will draw from
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
