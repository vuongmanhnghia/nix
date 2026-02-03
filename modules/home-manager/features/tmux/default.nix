{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    
    # === SHELL AND TERMINAL CONFIGURATION ===
    shell = "${pkgs.zsh}/bin/zsh";
    # terminal = "tmux-256color";
    
    # === BASIC SETTINGS ===
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    mouse = true;
    extraConfig = builtins.readFile ./config/.tmux.conf;
    # === PLUGINS ===
    plugins = with pkgs.tmuxPlugins; [
      # Session save/restore functionality
      resurrect
      # Optional: continuum for automatic saving
      continuum
      # Optional: better mouse support
      sensible
      cpu
      weather
    ];
  };
}