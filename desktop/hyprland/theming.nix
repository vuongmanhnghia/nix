{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # === ICON THEMES ===
    papirus-icon-theme
    
    # === FONTS ===
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    
    # === GTK THEMES ===
    catppuccin-gtk
    
    # === CURSOR THEMES ===
    catppuccin-cursors.mochaDark
    apple-cursor
    
    # === THEMING UTILITIES ===
    matugen           # Material You color generation from wallpapers
    nwg-look          # GTK theme configuration
    
    # === QT THEMING ===
    kdePackages.qt6ct # Qt6 configuration tool
    
    # === ADDITIONAL THEMING PACKAGES ===
    python3Packages.kde-material-you-colors  # Material You colors for KDE
    vips              # Image processing (for matugen)
  ];
}
