# 🎨 KVANTUM QT THEMING
# Advanced Qt application theming
{ config, pkgs, lib, ... }:

{
  # Install Kvantum
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
  ];

  # Kvantum configuration
  xdg.configFile."Kvantum" = {
    source = /home/nagih/Workspaces/Config/dots-hyprland/.config/Kvantum;
    recursive = true;
  };

  # Set Qt theme to use Kvantum (with higher priority)
  home.sessionVariables = {
    QT_STYLE_OVERRIDE = lib.mkForce "kvantum";
  };
} 