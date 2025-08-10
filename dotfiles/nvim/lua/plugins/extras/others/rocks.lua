---@type LazySpec
return {
  -- rocks.nvim: Modern Lua package manager for Neovim
  -- Replaces the old luarocks/hererocks dependency
  {
    "nvim-neorocks/rocks.nvim",
    priority = 1000, -- Very high priority to load first
    config = function()
      -- Basic configuration for rocks.nvim
      require("rocks").setup({
        -- Enable automatic installation of missing rocks
        auto_install = true,
        -- Enable debug logging (optional)
        debug = false,
      })
    end,
    build = function()
      -- Automatically install rocks after plugin setup
      vim.cmd("Rocks sync")
    end,
  },
}
