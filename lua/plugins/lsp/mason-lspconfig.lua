return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    -- Import necessary modules.
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- This function runs for each language server that attaches to a buffer.
    -- It's the perfect place to set up LSP-related keymaps.
    local on_attach = function(client, bufnr)
      -- NOTE: Your `init.lua` disables all diagnostic signs and text.
      -- The keymaps below for navigation will work, but you won't see underlines
      -- or signs in the gutter unless you change those settings.

      -- Enable completion triggered by <C-x><C-o>
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

      -- Helper function for creating keymaps
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
      end

      -- your existing keymaps (they are great!)
      map("gk", vim.lsp.buf.hover, "hover documentation")
      map("gd", require("telescope.builtin").lsp_definitions, "go to definition")
      map("gr", require("telescope.builtin").lsp_references, "go to references")

      -- Add some more useful keymaps
      map("gD", vim.lsp.buf.declaration, "Go to Declaration")
      map("gi", require("telescope.builtin").lsp_implementations, "Go to Implementation")
      map("<leader>rn", vim.lsp.buf.rename, "Rename")
      map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

      -- Diagnostic navigation
      map("[d", vim.diagnostic.goto_prev, "Go to Previous Diagnostic")
      map("]d", vim.diagnostic.goto_next, "Go to Next Diagnostic")
      map("<leader>e", vim.diagnostic.open_float, "Show Line Diagnostics")
    end

    -- This tells the servers what features our client (Neovim) supports.
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- The list of servers to automatically install and configure.
    local servers = {
      "basedpyright",
      "vtsls",
      "tailwindcss",
      "html",
      "cssls",
      "eslint",
      "jsonls",
      "lua_ls",
      "clangd",
      "gopls",
      "lemminx", -- XML
      "vimls",
    }

    -- Tell `mason-lspconfig` to install the servers from the list above.
    mason_lspconfig.setup({
      ensure_installed = servers,
    })

    -- Loop through the servers and set them up with the shared configs.
    for _, server_name in ipairs(servers) do
      local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      -- Add custom settings for specific servers here
      if server_name == "basedpyright" then
        opts.settings = {
          python = {
            analysis = {
              -- Your `venv-selector` plugin will handle the pythonPath.
              -- Set to "off" for basic linting without strict type checking.
              -- Change to "basic" or "strict" if you want full type checking.
              typeCheckingMode = "off",
            },
          },
        }
      end

      if server_name == "lua_ls" then
        opts.settings = {
          Lua = {
            -- Make the server aware of the Neovim runtime files
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        }
      end

      -- Finally, set up the server with lspconfig.
      lspconfig[server_name].setup(opts)
    end
  end,
}
