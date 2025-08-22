# 🎨 KDE THEMING CONFIGURATION
# KDE applications theming and color scheme
{ config, pkgs, ... }:

{
  # Copy KDE theme configurations
  xdg.configFile."kdeglobals".source = /home/nagih/Workspaces/Config/dots-hyprland/.config/kdeglobals;
  xdg.configFile."konsolerc".source = /home/nagih/Workspaces/Config/dots-hyprland/.config/konsolerc;
  
  # KDE material you colors
  xdg.configFile."kde-material-you-colors" = {
    source = /home/nagih/Workspaces/Config/dots-hyprland/.config/kde-material-you-colors;
    recursive = true;
  };
} 