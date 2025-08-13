{ config, pkgs, ... }:

{
  # === APPLICATION CONFIGURATION MODULES ===
  imports = [
    ./development      # Development tools (Docker, Git, programming languages, IDEs)
    ./gaming.nix       # Gaming platform (Steam, GameMode, controllers, Wine)
    ./multimedia.nix   # Multimedia applications (VLC, GIMP, LibreOffice, Vietnamese input)
    ./entries.nix      # Desktop entries
    ./custom.nix       # Custom applications
  ];
  
  # === SHELL CONFIGURATION ===
  programs.zsh.enable = true;  # Enable zsh shell with proper PATH configuration
} 