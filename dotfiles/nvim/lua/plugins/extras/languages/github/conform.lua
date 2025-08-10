---@type LazySpec
return {
  "stevearc/conform.nvim",
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      ["yaml.github"] = {
        "prettier",
        "injected",
      },
    },
  },
  optional = true,
}
