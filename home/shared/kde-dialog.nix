# KDialog configuration
# This file adds KDialog support to your NixOS configuration

{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # KDialog is part of KDE packages
    kdePackages.kdialog
  ];

  # Ensure KDE file dialog integration works properly
  home.sessionVariables = {
    # Use KDE file dialogs for applications that support XDG portals
    GTK_USE_PORTAL = "1";
  };
} 