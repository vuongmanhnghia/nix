# matugen/config.nix - Config chính cho matugen
{ config, pkgs, lib, ... }:

{
  # Create matugen config directory and files
  home.file = {
    # Main configuration file
    ".config/matugen/config.toml".text = ''
      [config]
      version_check = false

      [templates.m3colors]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/colors.json'
      output_path = '~/Workspaces/Config/nixos/generated/colors.json'

      [templates.hyprland]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/hyprland/colors.conf'
      output_path = '~/Workspaces/Config/nixos/generated/hyprland.conf'

      [templates.hyprlock]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/hyprland/hyprlock-colors.conf'
      output_path = '~/Workspaces/Config/nixos/generated/hyprlock.conf'

      [templates.fuzzel]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/fuzzel/fuzzel_theme.ini'
      output_path = '~/Workspaces/Config/nixos/generated/fuzzel_theme.ini'

      [templates.gtk3]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/gtk/gtk-colors.css'
      output_path = '~/Workspaces/Config/nixos/generated/gtk-3.0.css'

      [templates.gtk4]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/gtk/gtk-colors.css'
      output_path = '~/Workspaces/Config/nixos/generated/gtk-4.0.css'

      [templates.kde_colors]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/kde/color.txt'
      output_path = '~/Workspaces/Config/nixos/generated/kde.txt'

      [templates.wallpaper]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/wallpaper.txt'
      output_path = '~/Workspaces/Config/nixos/generated/wallpaper.txt'

      [config.wallpaper]
      command = "swww"
      arguments = ["img", "--transition-type", "any", "--transition-fps", "180"]
      set = true

      [templates.waybar]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/colors.css'
      output_path = '~/Workspaces/Config/nixos/generated/waybar.css'
      post_hook = 'pkill -SIGUSR2 waybar'

      [templates.swaync]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/colors.css'
      output_path = '~/Workspaces/Config/nixos/generated/swaync.css'
      post_hook = 'pkill -SIGUSR2 swaync'

      [templates.kitty]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/kitty.conf'
      output_path = '~/Workspaces/Config/nixos/generated/kitty.conf'
      post_hook = "kill -SIGUSR1 $(pidof kitty)"

      [templates.rofi]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/rofi.rasi'
      output_path = '~/Workspaces/Config/nixos/generated/rofi.rasi'

      [templates.cava]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/cava.config'
      output_path = '~/Workspaces/Config/nixos/generated/cava.config'
      post_hook = "pkill -SIGUSR2 cava"
    '';

    # Các template được đọc từ file riêng
    # ".config/matugen/templates/colors.css".source = ../templates/colors.css;
    ".local/state/quickshell/user/generated/colors.json".source = "/home/nagih/Workspaces/Config/nixos/generated/colors.json";
    ".local/state/quickshell/user/generated/color.txt".source = "/home/nagih/Workspaces/Config/nixos/generated/kde.txt";
    ".local/state/quickshell/user/generated/wallpaper/path.txt".source = "/home/nagih/Workspaces/Config/nixos/generated/wallpaper.txt";

    ".config/hypr/hyprland/colors.conf".source = "/home/nagih/Workspaces/Config/nixos/generated/hyprland.conf";
    ".config/hypr/hyprlock/colors.conf".source = "/home/nagih/Workspaces/Config/nixos/generated/hyprlock.conf";
    ".config/fuzzel/fuzzel_theme.ini".source = "/home/nagih/Workspaces/Config/nixos/generated/fuzzel_theme.ini";
    ".config/gtk-3.0/gtk.css".source = "/home/nagih/Workspaces/Config/nixos/generated/gtk-3.0.css";
    ".config/cava/config".source = "/home/nagih/Workspaces/Config/nixos/generated/cava.config";
    # ".config/gtk-4.0/gtk.css".source = "/home/$USER/Workspaces/Config/nixos/generated/gtk-4.0.css";
  };
}