return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      direction = "float",
      open_mapping = [[<c-\>]], -- A common mapping for toggling
      -- You can add many more options here
    })
  end,
}
