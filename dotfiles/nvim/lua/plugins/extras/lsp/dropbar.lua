---@type LazySpec
return {
  "Bekaboo/dropbar.nvim",
  event = "VeryLazy",
  ---@module 'dropbar'
  ---@type dropbar_configs_t
  opts = {
    -- NOTE: Consider adding source filters for Java/Kotlin if performance issues occur
    sources = {
      path = {
        -- max_depth = 16,
      },
    },
    bar = {
      truncate = true,
    },
  },
  -- optional, but required for fuzzy finder support
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    optional = true,
  },
}
