# matugen/default.nix - Improved version
{ config, pkgs, lib, ... }:

let
  configPath = "${config.home.homeDirectory}/Workspaces/Config/nixos";
  generatedPath = "${configPath}/generated";
  templatePath = "${configPath}/home/shared/matugen/templates";
in
{
  # Install matugen package
  home.packages = with pkgs; [
    matugen
  ];

  # Ensure required directories exist
  home.activation = {
    ensureMatugenDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Create quickshell directories
      run mkdir -p "$HOME/.local/state/quickshell/user/generated/wallpaper"
      run mkdir -p "$HOME/.config/scripts"
      
      # Ensure generated directory exists
      run mkdir -p "${generatedPath}"
      
      # Set proper permissions
      run chmod 755 "$HOME/.local/state/quickshell/user/generated"
    '';
  };

  # Main matugen configuration
  xdg.configFile."matugen/config.toml".text = ''
    [config]
    version_check = false
    # Add reload_config for better reloading
    reload_config = true

    [templates.m3colors]
    input_path = '${templatePath}/colors.json'
    output_path = '${generatedPath}/colors.json'

    [templates.hyprland]
    input_path = '${templatePath}/hyprland/colors.conf'
    output_path = '${generatedPath}/hyprland.conf'

    [templates.hyprlock]
    input_path = '${templatePath}/hyprland/hyprlock-colors.conf'
    output_path = '${generatedPath}/hyprlock.conf'

    [templates.fuzzel]
    input_path = '${templatePath}/fuzzel/fuzzel_theme.ini'
    output_path = '${generatedPath}/fuzzel_theme.ini'

    [templates.gtk3]
    input_path = '${templatePath}/gtk/gtk-colors.css'
    output_path = '${generatedPath}/gtk-3.0.css'

    [templates.gtk4]
    input_path = '${templatePath}/gtk/gtk-colors.css'
    output_path = '${generatedPath}/gtk-4.0.css'

    [templates.kde_colors]
    input_path = '${templatePath}/kde/color.txt'
    output_path = '${generatedPath}/kde.txt'

    [templates.wallpaper]
    input_path = '${templatePath}/wallpaper.txt'
    output_path = '${generatedPath}/wallpaper.txt'
    post_hook = """
      { 
        if pgrep -x swww > /dev/null; then 
          kill -SIGUSR1 $(pidof swww) && echo "SWWW reloaded"
        else 
          echo "SWWW not running"
        fi
      } 2>/dev/null
    """

    [templates.kitty]
    input_path = '${templatePath}/kitty.conf'
    output_path = '${generatedPath}/kitty.conf'
    post_hook = """
      {
        if pgrep -x kitty > /dev/null; then
          kill -SIGUSR1 $(pidof kitty) && echo "Kitty reloaded"
        else
          echo "Kitty not running"
        fi
      } 2>/dev/null
    """

    [templates.cava]
    input_path = '${templatePath}/cava.config'
    output_path = '${generatedPath}/cava.config'
    # Uncomment if needed: post_hook = "pkill -SIGUSR2 cava 2>/dev/null || true"
    
    # Quickshell colors - generate directly to quickshell state directory
    [templates.quickshell_colors]
    input_path = '${templatePath}/colors.json'
    output_path = '~/.local/state/quickshell/user/generated/colors.json'
    post_hook = """
      {
        # Try IPC first, fallback to file touch
        timeout 2 quickshell -i ~/.config/quickshell/ii \
          --socket=/tmp/quickshell/ii-socket \
          --ipc reloadTheme 2>/dev/null && echo 'Quickshell: IPC reload success' 
      } || {
        sleep 0.1 
        touch ~/.local/state/quickshell/user/generated/colors.json
        echo 'Quickshell: File touch reload'
      }
    """

    # Additional quickshell files
    [templates.quickshell_kde]
    input_path = '${templatePath}/kde/color.txt'
    output_path = '~/.local/state/quickshell/user/generated/color.txt'

    [templates.quickshell_wallpaper]
    input_path = '${templatePath}/wallpaper.txt'
    output_path = '~/.local/state/quickshell/user/generated/wallpaper/path.txt'
  '';

  # Configuration file symlinks using XDG and proper out-of-store symlinks
  xdg.configFile = {
    "hypr/hyprland/colors.conf".source = 
      config.lib.file.mkOutOfStoreSymlink "${generatedPath}/hyprland.conf";
    
    "hypr/hyprlock/colors.conf".source = 
      config.lib.file.mkOutOfStoreSymlink "${generatedPath}/hyprlock.conf";
    
    "fuzzel/fuzzel_theme.ini".source = 
      config.lib.file.mkOutOfStoreSymlink "${generatedPath}/fuzzel_theme.ini";
    
    "gtk-3.0/gtk.css".source = 
      config.lib.file.mkOutOfStoreSymlink "${generatedPath}/gtk-3.0.css";
    
    # Uncomment if needed
    # "gtk-4.0/gtk.css".source = 
    #   config.lib.file.mkOutOfStoreSymlink "${generatedPath}/gtk-4.0.css";
    
    "cava/config".source = 
      config.lib.file.mkOutOfStoreSymlink "${generatedPath}/cava.config";
  };

  # Optional: Create a convenient script to regenerate colors
  home.file.".config/scripts/matugen-reload".text = ''
    #!/bin/bash
    set -e
    
    if [ -z "$1" ]; then
      echo "Usage: $0 <image_path>"
      exit 1
    fi
    
    echo "Generating colors from: $1"
    matugen image "$1"
    
    echo "Colors generated and applications notified!"
  '';
  
  home.file.".config/scripts/matugen-reload".executable = true;

  # Environment variables for easier template access
  home.sessionVariables = {
    MATUGEN_CONFIG_PATH = configPath;
    MATUGEN_TEMPLATES_PATH = templatePath;
    MATUGEN_GENERATED_PATH = generatedPath;
  };
}