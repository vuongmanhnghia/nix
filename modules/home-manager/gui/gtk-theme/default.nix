{ config, pkgs, ... }:

{
  # === GTK THEME CONFIGURATION ===
  gtk = {
    enable = true;
    
    # === CATPPUCCIN GTK THEME ===
    theme = {
      name = "Catppuccin-Mocha-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "compact";
        variant = "mocha";
      };
    };
    
    # === PAPIRUS ICON THEME ===
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    
    # === MACOS CURSOR THEME ===
    cursorTheme = {
      name = "macOS";
      package = pkgs.apple-cursor;
      size = 24;
    };
    
    # === FONT CONFIGURATION ===
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    
    # === GTK SETTINGS ===
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-theme-name = "Catppuccin-Mocha-Compact-Blue-Dark";
      gtk-icon-theme-name = "Papirus-Dark";
      gtk-cursor-theme-name = "macOS";
      gtk-font-name = "JetBrainsMono Nerd Font 11";
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-theme-name = "Catppuccin-Mocha-Compact-Blue-Dark";
      gtk-icon-theme-name = "Papirus-Dark";
      gtk-cursor-theme-name = "macOS";
      gtk-font-name = "JetBrainsMono Nerd Font 11";
    };
  };

  # === CUSTOM ICONS ===
  xdg.dataFile."icons/custom".source = ./icons;
  
  # === QT THEME CONFIGURATION ===
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
} 