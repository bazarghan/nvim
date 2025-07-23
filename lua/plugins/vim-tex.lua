return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    -- General VimTeX settings
    vim.g.vimtex_enabled = 1
    vim.g.vimtex_quickfix_mode = 2

    -- Compiler configuration (This stays the same)
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      out_dir = "build",
      synctex = 1,
    }

    -- === VIEWER CONFIGURATION: THE ONLY CHANGE NEEDED ===
    -- Use Skim.app. It's native to macOS and works perfectly.
    -- All the complex zathura options are no longer needed.
    vim.g.vimtex_view_method = "skim"

    -- Keybindings (This stays the same)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "tex",
      callback = function()
        local map = vim.keymap.set
        local leader = vim.g.mapleader or "\\"

        map("n", leader .. "ll", "<cmd>VimtexCompile<CR>", { desc = "VimTeX - Compile" })
        map("n", leader .. "lv", "<cmd>VimtexView<CR>", { desc = "VimTeX - View PDF" })
        map("n", leader .. "lf", "<cmd>VimtexForwardSearch<CR>", { desc = "VimTeX - Forward Search" })
        map("n", leader .. "lc", "<cmd>VimtexCompileSS<CR>", { desc = "VimTeX - Compile Single Shot" })
        map("n", leader .. "lk", "<cmd>VimtexKill<CR>", { desc = "VimTeX - Kill Compiler" })
        map("n", leader .. "lx", "<cmd>VimtexClean<CR>", { desc = "VimTeX - Clean Aux Files" })
        map("n", leader .. "le", "<cmd>VimtexErrors<CR>", { desc = "VimTeX - Show Errors" })
      end,
    })
  end,
}
