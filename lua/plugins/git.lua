return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "BufReadPost",
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "▎" },
      topdelete = { text = "▔" },
      changedelete = { text = "▎" },
    },
    sign_priority = 6,
    update_debounce = 100,
    numhl = false,
    linehl = false,
    current_line_blame = false,
    watch_gitdir = {
      follow_files = true,
    },
    -- Replace 'keymaps' with 'on_attach' function:
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      -- Navigation
      vim.keymap.set("n", "]h", function()
        if vim.wo.diff then
          return "]h"
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, { buffer = buffer, expr = true })

      vim.keymap.set("n", "[h", function()
        if vim.wo.diff then
          return "[h"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, { buffer = buffer, expr = true })

      -- Actions
      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = buffer })
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = buffer })
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = buffer })
      vim.keymap.set("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, { buffer = buffer })
    end,
  },
}
