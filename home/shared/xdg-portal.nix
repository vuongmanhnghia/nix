# 🚪 XDG DESKTOP PORTAL CONFIGURATION
# Screen sharing, file dialogs, and other desktop integration
{ config, pkgs, ... }:

{
  # XDG desktop portal configuration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
    ];
    # Configure portal priorities
    configPackages = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    # Configure portal defaults
    xdgOpenUsePortal = true;
  };
  
  # Create the portal configuration file manually
  xdg.configFile."xdg-desktop-portal/hyprland-portals.conf".text = ''
    [preferred]
    default=hyprland;gtk
    org.freedesktop.impl.portal.FileChooser=kde
  '';
} 