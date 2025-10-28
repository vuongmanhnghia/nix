{ config, pkgs, ... }:

{
  # Display manager
  services.xserver = {
    enable = true;
    displayManager = {
      # Tắt các display manager khác
      gdm.enable = false; # GDM không tương thích tốt với Hyprland
      sddm.enable = true; # SDDM là một display manager nhẹ và tùy biến cao, phù hợp với Hyprland
    };
  };

  # # Greeter
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     # Chọn greeter bạn muốn. gtkgreet là một lựa chọn đồ họa tốt.
  #     default_session = {
  #       command = "${pkgs.cage}/bin/cage -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -l";
  #       user = "greeter";
  #     };
  #   };
  # };

  # environment.systemPackages = with pkgs; [
  #   greetd.gtkgreet
  #   cage
  # ];

  programs.hyprland.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
}