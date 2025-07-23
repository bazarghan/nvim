-- File: nvim/lua/plugins/mason-tool-installer.lua
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    require("mason-tool-installer").setup({
      ensure_installed = {
        "prettier",
        "stylua",
        "ruff", -- For Python formatting
      },
    })
  end,
}
