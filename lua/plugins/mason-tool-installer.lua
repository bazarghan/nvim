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
        "isort", -- Python formatter
        "black", -- Python formatter
      },
    })
  end,
}
