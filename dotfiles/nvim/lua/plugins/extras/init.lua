local ide_mode = require("utils.os").ide_mode
local is_executable = require("utils.executable").is_executable

---@type LazySpec
return {
  -- Blink
  {
    name = "Blink",
    import = "plugins.extras.blink",
    enabled = true,
  },
  
  -- Coding (Conform, Linting)
  {
    name = "Coding",
    import = "plugins.extras.coding",
    enabled = true,
  },
  
  -- LSP (Trouble, etc.)
  {
    name = "LSP",
    import = "plugins.extras.lsp",
    enabled = true,
  },
  
  -- Git
  {
    name = "Git",
    import = "plugins.extras.git",
    enabled = true,
  },
  
  -- Motion
  {
    name = "Motion",
    import = "plugins.extras.motion",
    enabled = true,
  },
  
  -- Others
  {
    name = "Others",
    import = "plugins.extras.others",
    enabled = true,
  },
  
  -- Telescope
  {
    name = "Telescope",
    import = "plugins.extras.telescope",
    enabled = true,
  },
  
  -- UI
  {
    name = "UI",
    import = "plugins.extras.ui",
    enabled = true,
  },
}
