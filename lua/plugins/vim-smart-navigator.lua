return {
  "mrjones2014/smart-splits.nvim",
  lazy = false, -- must be false for WezTerm support
  config = function()
    require("smart-splits").setup({
      -- when you hit the edge of a Neovim split, wrap around to the next pane
      at_edge = "wrap",
      -- (other options if you like)
    })

    -- Move cursor between splits
    vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move to left split" })
    vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move to below split" })
    vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move to above split" })
    vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move to right split" })

    -- Resize splits
    vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left, { desc = "Resize split left" })
    vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down, { desc = "Resize split down" })
    vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up, { desc = "Resize split up" })
    vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right, { desc = "Resize split right" })
  end,
}
