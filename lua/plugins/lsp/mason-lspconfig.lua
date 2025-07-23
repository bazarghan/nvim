-- File: nvim/lua/plugins/lsp/mason-lspconfig.lua
return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local mason_lspconfig = require("mason-lspconfig")

    local on_attach = function(client, bufnr)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
      end
      map("gd", require("telescope.builtin").lsp_definitions, "Go to Definition")
      map("gr", require("telescope.builtin").lsp_references, "Go to References")
      map("gI", require("telescope.builtin").lsp_implementations, "Go to Implementation")
      map("<leader>D", vim.lsp.buf.type_definition, "Type Definition")
      map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
      map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
      map("<leader>rn", vim.lsp.buf.rename, "Rename")
      map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
      map("K", vim.lsp.buf.hover, "Hover Documentation")
      if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    mason_lspconfig.setup({
      ensure_installed = {
        "vtsls",
        "tailwindcss",
        "html",
        "cssls",
        "eslint",
        "jsonls",
        "lua_ls",
        "clangd",
        "pyright",
        "gopls",
        "lemminx",
        "vimls",
      },
      handlers = {
        function(server_name)
          lspconfig[server_name].setup({ on_attach = on_attach, capabilities = capabilities })
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = { Lua = { diagnostics = { globals = { "vim" } } } },
          })
        end,
        -- THIS IS THE NEW/MODIFIED PART --
        ["pyright"] = function()
          lspconfig.pyright.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  -- It turns off all type-checking rules.
                  typeCheckingMode = "off",
                },
              },
            },
          })
        end,
      },
    })
  end,
}
