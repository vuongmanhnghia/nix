local is_windows = require("utils.os").is_windows

---@type LazySpec
return {
  {
    import = "plugins.extras.languages.ansible",
    enabled = true,
  },
  {
    import = "plugins.extras.languages.docker",
    enabled = true,
  },
  {
    import = "plugins.extras.languages.env",
    enabled = true,
  },
  {
    import = "plugins.extras.languages.git",
    enabled = true,
  },
  {
    import = "plugins.extras.languages.go",
    enabled = true,
  },
  {
    import = "plugins.extras.languages.hcl",
    enabled = true,
  },
  {
    import = "plugins.extras.languages.helm",
    enabled = true,
  },
  {
    import = "plugins.extras.languages.jenkins",
    enabled = true,
  },
  {
    import = "plugins.extras.languages.kubernetes",
    enabled = true,
  },
  {
    import = "plugins.extras.languages.python",
    enabled = true,
  },
  {
    import = "plugins.extras.languages.terraform",
    enabled = true,
  },
  {
    import = "plugins.extras.languages.toml",
    enabled = true,
  },
  {
    import = "plugins.extras.languages.yaml",
    enabled = true,
  },
}
