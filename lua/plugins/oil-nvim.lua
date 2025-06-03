return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons

  config = function()
    require("oil").setup({
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },

      -- Configuration for the floating window in oil.open_float
      float = {
        -- Padding around the floating window
        padding = 0,
        -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_width = 0.5,
        max_height = 0.5,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
        get_win_title = nil,
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = "auto",
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
          return conf
        end,
      },

      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        -- ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-h>"] = false,
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<leader>p"] = "actions.preview",
        ["<leader>j"] = { "actions.close", mode = "n" },
        ["<A-r>"] = "actions.refresh",
        ["<leader>k"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        ["<C-l>"] = false,
      },

      view_options = {
        show_hidden = true,
      },
    })

    local map = vim.keymap.set

    -- Keybinding to open Oil in a floating window
    map("n", "<leader>j", ":lua require('oil').open_float()<CR>")

    -- Open Oil in right
    -- vim.keymap.set("n", "<leader>;", function()
    --   vim.cmd("vsplit")
    --   vim.cmd("Oil")
    -- end)

    -- Open Oil in left
    -- vim.keymap.set("n", "<leader>a", function()
    --   vim.cmd("set nosplitright")
    --   vim.cmd("vsplit")
    --   vim.cmd("Oil")
    --   vim.cmd("set splitright")
    -- end, { noremap = true, silent = true })
  end,
}
