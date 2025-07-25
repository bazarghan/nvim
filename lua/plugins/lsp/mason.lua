return {
  -- Mason: The main tool manager
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = { ui = { border = "rounded" } },
  },

  -- Mason-tool-installer: Ensures your tools are always installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Python
        "pyright",
        "ruff",
        "debugpy",
        -- Go
        "gopls",
        "goimports",
        "delve",
        -- C/C++
        "clangd",
        "clang-format",
        -- Lua/Web
        "stylua",
        "prettier",
      },
    },
  },
}
