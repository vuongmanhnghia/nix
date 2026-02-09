{
  config,
  lib,
  pkgs,
  nagih7-dots,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.tree-sitter-nix
        p.tree-sitter-vim
        p.tree-sitter-vimdoc
        p.tree-sitter-bash
        p.tree-sitter-regex
        p.tree-sitter-lua
        p.tree-sitter-markdown
        p.tree-sitter-markdown-inline
        p.tree-sitter-c
        p.tree-sitter-python
        p.tree-sitter-json
        p.tree-sitter-yaml
        p.tree-sitter-html
        p.tree-sitter-css
        p.tree-sitter-javascript
        p.tree-sitter-typescript
        p.tree-sitter-tsx
        p.tree-sitter-toml
        p.tree-sitter-gitcommit
        p.tree-sitter-gitignore
      ]))
    ];

    extraPackages = with pkgs; [
      lua-language-server
      stylua
      nil
      nodePackages.prettier
      nodePackages.vscode-langservers-extracted
      nixpkgs-fmt
      typescript-language-server
      python3Packages.python-lsp-server
      black
      isort
      rust-analyzer
      rustfmt

      tree-sitter

      lazygit # Fix lỗi Snacks.lazygit
      sqlite # Fix lỗi Snacks.picker history
      trash-cli # Fix lỗi trash command (thay cho gio/kioclient)

      imagemagick # Đã có, nhưng cứ đảm bảo
      ghostscript # Fix lỗi 'gs' (render PDF)
      mermaid-cli # Fix lỗi 'mmdc' (vẽ biểu đồ)
      tectonic # Fix lỗi render Latex (nhẹ hơn cài full texlive)

      gcc
      gnumake
    ];
  };

  xdg.configFile."nvim" = {
    source = "${nagih7-dots}/nvim";
    recursive = true;
  };

  programs.zsh.shellAliases = {
    v = "nvim";
    vi = "nvim";
    vim = "nvim";
  };

  home.packages = with pkgs; [
    ranger
    tree-sitter
    lua51Packages.lua
    luarocks
    glow
  ];
}
