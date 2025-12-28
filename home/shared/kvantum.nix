
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
  ];

  # Kvantum configuration
  home.file = {
    ".config/Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=MaterialAdw
    '';
  };
} 