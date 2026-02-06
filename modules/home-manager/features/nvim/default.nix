{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    extraPackages = with pkgs; [
      # LSP
      lua-language-server
      stylua
      nil

      # Formatters
      nodePackages.prettier
      nodePackages.vscode-langservers-extracted

      # Nix
      nixpkgs-fmt      

      # TypeScript
      typescript-language-server

      # Python
      python3Packages.python-lsp-server
      black
      isort

      # Rust
      rust-analyzer
      rustfmt
    ];
  };

  xdg.configFile."nvim".source = ./config;

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

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    extraConfig = ''
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(\\.[0-9]+)?).*/\\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\\' select-pane -l
    '';
  };
}
