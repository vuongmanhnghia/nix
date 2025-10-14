---@type LazySpec
return {
  "nmac427/guess-indent.nvim",
  cmd = "GuessIndent",
  -- NOTE: Currently doesn't auto-run when opening with `nvim filename` directly
  -- Works fine when using :e filename or when already inside nvim
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  keys = {
    {
      "<leader>ui",
      "<cmd>GuessIndent<CR>",
      desc = "Utils | Fix Indent",
      silent = true,
    },
  },
  opts = {
    auto_cmd = false,
  },
}
