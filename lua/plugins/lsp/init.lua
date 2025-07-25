return {
  -- Each file in this directory returns a table of plugins
  require("plugins.lsp.mason"),
  require("plugins.lsp.lspconfig"),
  require("plugins.lsp.formatting"),
  require("plugins.lsp.python"),
  require("plugins.lsp.completion"),
  require("plugins.lsp.debugging"),
}
