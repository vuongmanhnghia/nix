{ config, pkgs, ... }:

{
  # Display manager
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = false; # GDM không tương thích tốt với Hyprland
    };
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.hyprland.enable = true;
  services.xserver.desktopManager.gnome.enable = false;
}