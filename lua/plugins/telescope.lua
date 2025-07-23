-- File: nvim/lua/plugins/telescope.lua

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

    -- Custom actions for copying data
    local function copy_diagnostic_message(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      if selection and selection.text then
        vim.fn.setreg("+", selection.text)
        vim.notify("Copied diagnostic message to clipboard", vim.log.levels.INFO, { title = "Telescope" })
      end
    end

    local function copy_filename(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      if selection and selection.filename then
        vim.fn.setreg("+", selection.filename)
        vim.notify("Copied filename to clipboard", vim.log.levels.INFO, { title = "Telescope" })
      end
    end

    local function copy_multi_diagnostic_messages(prompt_bufnr)
      local multi_selection = action_state.get_multi_selection()
      if #multi_selection == 0 then
        copy_diagnostic_message(prompt_bufnr)
        return
      end
      local messages = {}
      for _, selection in ipairs(multi_selection) do
        table.insert(messages, selection.text)
      end
      local full_text = table.concat(messages, "\n")
      vim.fn.setreg("+", full_text)
      vim.notify(
        "Copied " .. #multi_selection .. " diagnostic messages to clipboard",
        vim.log.levels.INFO,
        { title = "Telescope" }
      )
    end

    local function copy_multi_filenames(prompt_bufnr)
      local multi_selection = action_state.get_multi_selection()
      if #multi_selection == 0 then
        copy_filename(prompt_bufnr)
        return
      end
      local filenames = {}
      local seen = {}
      for _, selection in ipairs(multi_selection) do
        if not seen[selection.filename] then
          table.insert(filenames, selection.filename)
          seen[selection.filename] = true
        end
      end
      local full_text = table.concat(filenames, "\n")
      vim.fn.setreg("+", full_text)
      vim.notify(
        "Copied " .. #filenames .. " unique filenames to clipboard",
        vim.log.levels.INFO,
        { title = "Telescope" }
      )
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
            ["<C-e>"] = copy_multi_diagnostic_messages,
            ["<C-p>"] = copy_multi_filenames,
          },
          n = {
            ["dd"] = actions.delete_buffer,
            ["<A-q>"] = actions.close,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<C-y>"] = copy_diagnostic_message,
            ["yy"] = copy_diagnostic_message, -- YANK THE DIAGNOSTIC MESSAGE
            ["<C-f>"] = copy_filename,
            ["<C-e>"] = copy_multi_diagnostic_messages,
            ["<C-p>"] = copy_multi_filenames,
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

    -- Your existing Telescope keymaps remain the same
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
