---@type LazySpec
return {
  "stevearc/conform.nvim",
  optional = true,
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      go = {
        "goimports", -- Organizes imports and formats code
        "gofumpt",   -- Stricter gofmt
      },
    },
  },
}
