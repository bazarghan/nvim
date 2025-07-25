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
    local action_state = require("telescope.actions.state")

    ---
    -- NEW VERSION of the custom action
    ---
    local function copy_full_diagnostics(prompt_bufnr)
      -- This new version gets the "picker" first, which is more robust.
      local picker = action_state.get_current_picker(prompt_bufnr)
      local multi_selection = picker:get_multi_selection()
      local text_to_copy

      if #multi_selection > 0 then
        local lines = {}
        for _, selection in ipairs(multi_selection) do
          local line = string.format("%s:%d:%d: %s", selection.filename, selection.lnum, selection.col, selection.text)
          table.insert(lines, line)
        end
        text_to_copy = table.concat(lines, "\n")
      else
        -- Fallback for single selection
        local selection = action_state.get_selected_entry()
        if selection then
          text_to_copy =
            string.format("%s:%d:%d: %s", selection.filename, selection.lnum, selection.col, selection.text)
        end
      end

      if text_to_copy then
        vim.fn.setreg("+", text_to_copy)
        vim.notify("Copied diagnostics to clipboard", vim.log.levels.INFO, { title = "Telescope" })
      end
    end

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<A-q>"] = actions.close,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<C-c>"] = copy_full_diagnostics,
          },
          n = {
            ["dd"] = actions.delete_buffer,
            ["<A-q>"] = actions.close,
            ["s"] = actions.toggle_selection + actions.move_selection_next,
            ["S"] = actions.toggle_selection + actions.move_selection_previous,
            ["yy"] = copy_full_diagnostics,
          },
        },
      },
      pickers = {
        diagnostics = {
          previewer = true,
        },
      },
      extensions = {
        fzf = {},
      },
    })

    telescope.load_extension("fzf")

    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
    vim.keymap.set("n", "<leader>m", "<cmd>Telescope marks<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<Leader>d", function()
      require("telescope.builtin").diagnostics()
    end, { desc = "Workspace Diagnostics" })
    vim.keymap.set("n", "<Leader>fd", function()
      require("telescope.builtin").diagnostics({ bufnr = 0 })
    end, { desc = "Buffer Diagnostics" })
  end,
}
