---@type LazySpec
return {
  "stevearc/conform.nvim",
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      dockerfile = {
        -- NOTE: hadolint linter support pending in conform.nvim
        -- Track: https://github.com/stevearc/conform.nvim/issues
      },
    },
  },
  optional = true,
}
