return {
  "tpope/vim-obsession",
  config = function()
    vim.keymap.set("n", "<leader>sl", ":source Session.vim<CR>")
    vim.keymap.set("n", "<leader>ss", ":Obsession<CR>")
    vim.keymap.set("n", "<leader>se", ":Obsession!<CR>")
  end,
}
