# 🚪 XDG DESKTOP PORTAL CONFIGURATION
# Screen sharing, file dialogs, and other desktop integration
{ config, pkgs, ... }:

{
  # XDG Desktop Portal configuration
  xdg.configFile."xdg-desktop-portal/hyprland-portals.conf".text = ''
    [preferred]
    default = hyprland;gtk
    org.freedesktop.impl.portal.FileChooser = kde
  '';
} 