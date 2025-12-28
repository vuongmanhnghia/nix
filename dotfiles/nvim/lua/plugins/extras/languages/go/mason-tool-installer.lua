---@type LazySpec
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  optional = true,
  ---@module 'mason-tool-installer'
  ---@type MasonToolInstallerOpts
  opts = {
    ensure_installed = {
      -- LSP
      "gopls",
      -- Formatters
      "goimports",
      "gofumpt",
      -- Linters
      "golangci-lint",
    },
  },
}
