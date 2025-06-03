return {
  "williamboman/mason-lspconfig.nvim",

  dependencies = {
    "williamboman/mason.nvim",
  },

  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "angularls",
        "ast_grep",
        "clangd",
        "harper_ls",
        "css_variables",
        "cssls",
        "cssmodules_ls",
        "tailwindcss",
        "unocss",
        "jinja_lsp",
        "emmet_language_server",
        "emmet_ls",
        "golangci_lint_ls",
        "gopls",
        "templ",
        "html",
        "lwc_ls",
        "stimulus_ls",
        "twiggy_language_server",
        "biome",
        "denols",
        "eslint",
        "glint",
        "quick_lint_js",
        "ts_ls",
        "vtsls",
        "jsonls",
        "spectral",
        "lua_ls",
        "basedpyright", -- Keeping this for Python LSP
        "ruff", -- Keeping this for Python linting
        "somesass_ls",
        "ts_ls",
        "vtsls",
        "tsp_server",
        "vimls",
        "lemminx",
      },
    })

    -- Configure basedpyright to disable strict type checking
    require("lspconfig").basedpyright.setup({
      settings = {
        basedpyright = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
            typeCheckingMode = "off", -- Disables type errors
          },
        },
      },
    })

    -- Optional: Configure ruff if you want specific linting rules
    require("lspconfig").ruff.setup({
      settings = {
        args = { "--ignore", "ANN" }, -- Ignore type annotation linting rules
      },
    })
  end,
}
