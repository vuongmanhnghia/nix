{ config, pkgs, hostVars, ... }:

{
  programs.tmux = {
    enable = true;
    
    # === SHELL AND TERMINAL CONFIGURATION ===
    shell = "${pkgs.zsh}/bin/zsh";
    
    # === BASIC SETTINGS ===
    baseIndex = 1;
    escapeTime = 0;

    extraConfig = ''
      ${builtins.readFile ./config/.tmux.conf}

      unbind r
      bind r source-file "${config.home.homeDirectory}/Workspaces/config/nixos/modules/home-manager/features/tmux/config/.tmux.conf" \; display "Config Reloaded!"
      bind R source-file "${config.home.homeDirectory}/Workspaces/config/nixos/modules/home-manager/features/tmux/config/.tmux.conf" \; display "Config Reloaded!"
    '';

    # === PLUGINS ===
    plugins = with pkgs.tmuxPlugins; [
      resurrect     # Session save/restore functionality
      continuum     # Optional: continuum for automatic saving
      sensible      # Optional: better mouse support
      catppuccin    # Optional: catppuccin theme
      cpu           # Optional: CPU usage monitoring
      weather       # Optional: weather monitoring
    ];
  };
}