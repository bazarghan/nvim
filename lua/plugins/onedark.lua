return {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("onedark").setup({
      style = "dark", -- styles: dark, darker, cool, deep, warm, warmer, light
    })
    require("onedark").load()
  end,
}
