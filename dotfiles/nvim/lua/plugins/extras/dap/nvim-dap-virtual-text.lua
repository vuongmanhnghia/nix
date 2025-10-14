---Show virtual text for DAP (Debug Adapter Protocol)
---Requires nvim-treesitter for expression evaluation

---@type LazySpec
return {
  "theHamsta/nvim-dap-virtual-text",
  enabled = true,
  config = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap",
  },
  specs = {
    {
      "mfussenegger/nvim-dap",
      dependencies = "theHamsta/nvim-dap-virtual-text",
    },
  },
}
