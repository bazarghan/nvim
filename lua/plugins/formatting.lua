return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({

      formatters = {
        ruff = {
          command = "ruff",
          args = { "format", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },
      },

      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        lua = { "stylua" },
        python = { "ruff" },
      },

      lsp_fallback = false,
      format_on_save = {
        async = false,
        timeout_ms = 1000,
      },
    })
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
