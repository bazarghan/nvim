return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
        go = { "goimports" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
  },
}
