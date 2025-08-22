# matugen/default.nix - File chính
{ config, pkgs, lib, ... }:

{
  # Install matugen package
  home.packages = with pkgs; [
    matugen
  ];

  # Ensure required directories exist
  home.activation = {
    ensureQuickshellDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Create quickshell directories
      $DRY_RUN_CMD mkdir -p "$HOME/.local/state/quickshell/user/generated/wallpaper"
      $DRY_RUN_CMD mkdir -p "$HOME/.config/scripts"
      
      # Ensure generated directory exists
      $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/Workspaces/Config/nixos/generated"
    '';
  };

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
      post_hook = "kill -SIGUSR1 $(pidof swww) 2>/dev/null || true"

      [templates.kitty]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/kitty.conf'
      output_path = '~/Workspaces/Config/nixos/generated/kitty.conf'
      post_hook = "kill -SIGUSR1 $(pidof kitty)"

      [templates.cava]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/cava.config'
      output_path = '~/Workspaces/Config/nixos/generated/cava.config'
      # post_hook = "pkill -SIGUSR2 cava"
      
      # Quickshell colors - generate directly to quickshell state directory
      [templates.quickshell_colors]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/colors.json'
      output_path = '~/.local/state/quickshell/user/generated/colors.json'
      post_hook = "{ timeout 2 quickshell -i ~/.config/quickshell/ii --socket=/tmp/quickshell/ii-socket --ipc reloadTheme 2>/dev/null && echo 'Quickshell notified via IPC'; } || { sleep 0.1 && touch ~/.local/state/quickshell/user/generated/colors.json && echo 'Quickshell reload triggered via file'; }"

      # Additional quickshell files
      [templates.quickshell_kde]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/kde/color.txt'
      output_path = '~/.local/state/quickshell/user/generated/color.txt'

      [templates.quickshell_wallpaper]
      input_path = '~/Workspaces/Config/nixos/home/shared/matugen/templates/wallpaper.txt'
      output_path = '~/.local/state/quickshell/user/generated/wallpaper/path.txt'
    '';

    # Backup symlinks to generated files (fallback)
    ".local/state/quickshell/user/generated/colors-backup.json".source = "/home/nagih/Workspaces/Config/nixos/generated/colors.json";
    ".local/state/quickshell/user/generated/color-backup.txt".source = "/home/nagih/Workspaces/Config/nixos/generated/kde.txt";
    ".local/state/quickshell/user/generated/wallpaper/path-backup.txt".source = "/home/nagih/Workspaces/Config/nixos/generated/wallpaper.txt";

    # Configuration file symlinks
    ".config/hypr/hyprland/colors.conf".source = "/home/nagih/Workspaces/Config/nixos/generated/hyprland.conf";
    ".config/hypr/hyprlock/colors.conf".source = "/home/nagih/Workspaces/Config/nixos/generated/hyprlock.conf";
    ".config/fuzzel/fuzzel_theme.ini".source = "/home/nagih/Workspaces/Config/nixos/generated/fuzzel_theme.ini";
    ".config/gtk-3.0/gtk.css".source = "/home/nagih/Workspaces/Config/nixos/generated/gtk-3.0.css";
    # ".config/gtk-4.0/gtk.css".source = "/home/nagih/Workspaces/Config/nixos/generated/gtk-4.0.css";
    ".config/cava/config".source = "/home/nagih/Workspaces/Config/nixos/generated/cava.config";
  };
}