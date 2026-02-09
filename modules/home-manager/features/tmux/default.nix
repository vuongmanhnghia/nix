{
  config,
  pkgs,
  hostVars,
  nagih7-dots,
  ...
}:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";

    # === PLUGINS ===
    plugins = with pkgs.tmuxPlugins; [
      resurrect # Session save/restore functionality
      continuum # Optional: continuum for automatic saving
      sensible # Optional: better mouse support
      catppuccin # Optional: catppuccin theme
      cpu # Optional: CPU usage monitoring
      weather # Optional: weather monitoring
    ];

    extraConfig = ''
      source-file ${nagih7-dots}/tmux/.tmux.conf

      # Override
      unbind r
      unbind R
      bind r source-file ${nagih7-dots}/tmux/.tmux.conf \; display-message "Tmux config reloaded!"
      bind R source-file ${nagih7-dots}/tmux/.tmux.conf \; display-message "Tmux config reloaded!"
      set -g status off
    '';
  };
}
