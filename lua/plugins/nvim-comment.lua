return {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  config = function()
    require("Comment").setup({
      toggler = { line = "gc", block = "gb" }, -- Keymaps
      opleader = { line = "gc", block = "gb" },
      -- Handle C++ comments (// with optional space)
      pre_hook = function(ctx)
        if vim.bo.filetype == "cpp" then
          vim.bo.commentstring = "// %s"
        end
      end,
    })
  end,
}
