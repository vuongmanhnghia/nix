{ config, pkgs, ... }:

{
  # Display manager
  services.xserver = {
    enable = true;
  };


  services.displayManager = {
    gdm = {
      enable = false; # GDM không tương thích tốt với Hyprland
    };
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  # Hyprland is configured in hyprland.nix
  services.desktopManager = {
    plasma6 = {
      enable = false;
    };
    gnome = {
      enable = false;
    };
  };
}