{ config, pkgs, ... }:

{
  # === APPLICATION CONFIGURATION MODULES ===
  imports = [
    ./development      # Development tools
    ./gaming.nix       # Gaming platform 
    ./multimedia.nix   # Multimedia applications
    ./entries.nix      # Desktop entries
    ./custom.nix       # Custom applications
    ./fcitx5.nix       # Vietnamese input
  ];
} 