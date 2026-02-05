{ config, pkgs, quickshell, hostVars, end-4-dots, ... }:

{

  imports = [
    ./modules/dependencies.nix
    ./modules/services.nix
  ];

  xdg.configFile."quickshell".source = "${end-4-dots}/dots/.config/quickshell";

  # === ENVIRONMENT VARIABLES ===
  home.sessionVariables = {
    # Qt6 Configuration
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_SCALE_FACTOR = "1";
    QT_QUICK_CONTROLS_STYLE = "Basic";
    QT_QUICK_FLICKABLE_WHEEL_DECELERATION = "10000";
    
    # QuickShell specific
    QS_CONFIG = "ii";
    QS_NO_RELOAD_POPUP = "1";
    
    # Python path for scripts - use python3.12 for NixOS 24.11
    PYTHONPATH = "${pkgs.python3Packages.pywayland}/lib/python3.12/site-packages:${pkgs.python3Packages.setproctitle}/lib/python3.12/site-packages:${pkgs.python3Packages.pillow}/lib/python3.12/site-packages:${pkgs.python3Packages.numpy}/lib/python3.12/site-packages:${pkgs.python3Packages.requests}/lib/python3.12/site-packages";
    
    # Virtual environment path
    ILLOGICAL_IMPULSE_VIRTUAL_ENV = "${config.home.homeDirectory}/.local/state/quickshell/.venv";
  };

  # === HOME ACTIVATION SCRIPT ===
  home.activation = {
    setupQuickShellEnvironment = config.lib.dag.entryAfter ["writeBoundary"] ''
      # Create necessary directories
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.local/state/quickshell
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.config/hypr/custom/scripts
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/Pictures/Wallpapers
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/Pictures/Screenshots
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.config/matugen/templates/kde
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.local/state/quickshell/user/generated
      
      # Create Python virtual environment if it doesn't exist
      if [ ! -d "${config.home.homeDirectory}/.local/state/quickshell/.venv" ]; then
        $DRY_RUN_CMD ${pkgs.python3}/bin/python -m venv ${config.home.homeDirectory}/.local/state/quickshell/.venv
        $DRY_RUN_CMD ${config.home.homeDirectory}/.local/state/quickshell/.venv/bin/pip install Pillow numpy requests materialyoucolor pywayland setproctitle
      fi
            
      # Create empty restore script for video wallpapers
      $DRY_RUN_CMD touch ${config.home.homeDirectory}/.config/hypr/custom/scripts/__restore_video_wallpaper.sh
      $DRY_RUN_CMD chmod +x ${config.home.homeDirectory}/.config/hypr/custom/scripts/__restore_video_wallpaper.sh
      
      # Create basic KDE wrapper script
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.config/matugen/templates/kde
      cat > ${config.home.homeDirectory}/.config/matugen/templates/kde/kde-material-you-colors-wrapper.sh << 'EOF'
#!/bin/bash
# Basic KDE Material You colors wrapper
echo "KDE theming not fully implemented yet"
EOF
      $DRY_RUN_CMD chmod +x ${config.home.homeDirectory}/.config/matugen/templates/kde/kde-material-you-colors-wrapper.sh

      # Create AI service start script in a writable location
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.local/state/quickshell/scripts/ai
      if [ ! -f "${config.home.homeDirectory}/.local/state/quickshell/scripts/ai/start_ai_service.sh" ]; then
        $DRY_RUN_CMD cp -f ${config.home.homeDirectory}/Workspaces/config/nixos/dotfiles/quickshell/ii/scripts/ai/start_ai_service.sh ${config.home.homeDirectory}/.local/state/quickshell/scripts/ai/
        $DRY_RUN_CMD chmod +x ${config.home.homeDirectory}/.local/state/quickshell/scripts/ai/start_ai_service.sh
      fi

      # Create default wallpaper if it doesn't exist
      if [ ! -f "${config.home.homeDirectory}/Pictures/Wallpapers/default.png" ]; then
        $DRY_RUN_CMD cp -f ${config.home.homeDirectory}/Workspaces/config/nixos/dotfiles/quickshell/ii/assets/images/default_wallpaper.png ${config.home.homeDirectory}/Pictures/Wallpapers/default.png
      fi
    '';
  };

  # === PROGRAMS CONFIGURATION ===
  programs = {
    # Enable command-not-found for better error messages
    command-not-found.enable = true;
  };
} 