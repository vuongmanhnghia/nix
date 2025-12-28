---@type LazySpec
return {
  name = "Telescope",
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  config = function()
    -- UPSTREAM: Waiting for https://github.com/nvim-telescope/telescope.nvim/issues/3436
    -- to be resolved before enabling this feature
    require("telescope").setup(require("nvchad.configs.telescope"))
  end,
  opts = {
    defaults = {
      layout_config = {
        prompt_position = "top", ---@type "top" | "bottom"
      },
      sorting_strategy = "ascending", ---@type "ascending" | "descending"
      path_display = {
        "smart", ---@type "hidden" | "tail" | "absolute" | "smart" | "shorten" | "truncate" | "filename_first"
      },
      file_ignore_patterns = {
        "%.egg-info/",
        "^%.dart_tool/",
        "^%.git/",
        "^%.idea/",
        "^%.next/",
        "^%.venv/",
        "^%.vs/",
        "^.husky/_/",
        "^node_modules/",
        "__pycache__/",
        "bin/",
        "build/",
        "cache/",
        "debug/",
        "dist/",
        "obj/",
      },
    },
  },
}
