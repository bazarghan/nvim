return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp", "folke/neodev.nvim" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(client, bufnr)
        local keymap = vim.keymap.set -- Create an alias

        -- CORRECTED: Use the 'keymap' alias directly
        keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration", buffer = bufnr })
        keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Show LSP Definitions", buffer = bufnr })
        keymap("n", "gk", vim.lsp.buf.hover, { desc = "Show Hover Documentation", buffer = bufnr })
        keymap(
          "n",
          "gi",
          "<cmd>Telescope lsp_implementations<CR>",
          { desc = "Show LSP Implementations", buffer = bufnr }
        )
        keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart Rename", buffer = bufnr })
        keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Show Code Actions", buffer = bufnr })
      end

      -- Setup servers
      local servers = { "pyright", "ruff", "gopls", "clangd", "lua_ls" }
      for _, server_name in ipairs(servers) do
        lspconfig[server_name].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      -- Configure Pyright separately to set a stricter mode
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              typeCheckingMode = "off",
            },
          },
        },
      })

      require("neodev").setup({})
    end,
  },
}
