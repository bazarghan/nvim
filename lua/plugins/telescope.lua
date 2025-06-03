return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")

    telescope.setup({
      defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
          n = {
            ["dd"] = actions.delete_buffer,
          },
          i = {
            -- map actions.which_key to <C-h> (default: <C-/>)
            -- actions.which_key shows the mappings for your picker,
            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
            ["<C-k>"] = actions.move_selection_previous, -- Move to prev result
            ["<C-j>"] = actions.move_selection_next, -- Move to next result
            ["<A-q>"] = actions.close,
          },
        },
      },
      pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
      },
      extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
      },
    })

    telescope.load_extension("fzf")

    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
    vim.keymap.set("n", "<leader>m", "<cmd>Telescope marks<CR>", { noremap = true, silent = true })

    -- Display CWD dianostics
    vim.keymap.set("n", "<Leader>d", function()
      require("telescope.builtin").diagnostics()
    end)

    -- Display dianostics in current file
    vim.keymap.set("n", "<Leader>fd", function()
      require("telescope.builtin").diagnostics({ bufnr = 0 })
    end)
  end,
}
