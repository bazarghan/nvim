return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- A graphical UI for the debugger
      {
        "rcarriga/nvim-dap-ui",
        -- ADDED a new dependency required by nvim-dap-ui
        dependencies = { "nvim-neotest/nvim-nio" },
        config = true,
      },
      -- Helper plugin for Python debugging
      {
        "mfussenegger/nvim-dap-python",
        config = function()
          require("dap-python").setup()
        end,
      },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      -- Automatically open/close the UI when a debug session starts/ends
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      -- Keymaps for debugging
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
      vim.keymap.set("n", "<F8>", dap.step_over, { desc = "DAP: Step Over" })
      vim.keymap.set("n", "<F7>", dap.step_into, { desc = "DAP: Step Into" })
      vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "DAP: Step Out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
      vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "DAP: Toggle UI" })
    end,
  },
}
