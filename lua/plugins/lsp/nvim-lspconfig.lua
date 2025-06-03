return {
  enabled = true,
  "neovim/nvim-lspconfig",

  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },

  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- Use cmp_nvim_lsp for capabilities, including snippet support
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Function to disable semantic highlighting
    local function disable_semantic_highlighting(client)
      client.server_capabilities.semanticTokensProvider = nil
    end

    -- Shared on_attach function for consistency
    local on_attach = function(client, bufnr)
      disable_semantic_highlighting(client)
    end

    -- Load mason-registry
    local ok, mason_registry = pcall(require, "mason-registry")
    if not ok then
      vim.notify("mason-registry could not be loaded")
      return
    end
  end,
}
