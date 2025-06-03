_G.vim = vim

vim.diagnostic.config({
  virtual_text = false,
  underline = false,
  signs = false,
})

require("configs.keymaps")
require("configs.options")
require("configs.lazy")
