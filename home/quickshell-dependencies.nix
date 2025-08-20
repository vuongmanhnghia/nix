{ config, pkgs, quickshell, ... }:

{
  # === QUICKSHELL DEPENDENCIES CONFIGURATION ===
  
  home.packages = with pkgs; [
    # === CORE QUICKSHELL ===
    quickshell.packages.${pkgs.system}.default  # QuickShell UI system
    
    # === QT6 FRAMEWORK ===
    qt6.full                    # Complete Qt6 suite
    qt6.qtwayland              # Wayland support for Qt6
    qt6.qtdeclarative          # QML runtime and compiler
    qt6.qtsvg                  # SVG support
    qt6.qtimageformats         # Additional image format support
    qt6.qtmultimedia           # Multimedia support for media controls
    qt6.qtnetworkauth          # Network authentication (for AI services)
    qt6.qttools                # Qt development tools (includes qmllint)
    
    # === AUDIO SYSTEM ===
    pipewire                   # Modern audio server
    wireplumber               # PipeWire session manager
    pavucontrol               # PulseAudio volume control
    easyeffects               # Audio effects processing
    
    # === SYSTEM MONITORING ===
    upower                    # Battery and power management
    acpi                      # ACPI utilities for battery info
    lm_sensors               # Hardware sensors
    
    # === NETWORK MANAGEMENT ===
    networkmanager           # Network connection management
    networkmanagerapplet     # NetworkManager system tray
    
    # === BLUETOOTH ===
    bluez                    # Bluetooth protocol stack
    bluez-tools             # Bluetooth utilities
    
    # === CLIPBOARD MANAGEMENT ===
    cliphist                 # Wayland clipboard history
    wl-clipboard            # Wayland clipboard utilities
    
    # === INPUT AUTOMATION ===
    ydotool                  # Input automation for Wayland
    
    # === BRIGHTNESS CONTROL ===
    brightnessctl           # Backlight control utility
    ddcutil                 # Monitor brightness control via DDC
    
    # === NOTIFICATIONS ===
    libnotify               # Desktop notifications
    dunst                   # Notification daemon
    
    # === HYPRLAND INTEGRATION ===
    hyprland                # Wayland compositor
    hyprpicker              # Color picker
    hyprshot                # Screenshot utility
    hypridle                # Idle management
    hyprlock                # Screen locker
    
    # === PYTHON DEPENDENCIES ===
    python3                 # Python runtime
    python3Packages.pywayland  # Python Wayland bindings
    python3Packages.setproctitle  # Process title setting
    python3Packages.pillow  # PIL for image processing
    python3Packages.numpy   # NumPy for image processing
    python3Packages.requests  # HTTP requests
    
    # === MEDIA CONTROL ===
    playerctl               # Media player control
    
    # === AI SERVICES (OPTIONAL) ===
    ollama                  # Local AI models
    curl                    # HTTP client for API calls
    jq                      # JSON processor
    
    # === WALLPAPER & THEMING ===
    matugen                 # Material Design color generation
    bc                      # Calculator for math operations
    xdg-user-dirs          # XDG user directories
    imagemagick            # Image manipulation and identification
    cava                   # Audio visualizer
    
    # === UTILITIES ===
    procps                  # Process utilities (pidof, etc.)
    util-linux             # System utilities
    coreutils              # Core GNU utilities
    findutils              # File finding utilities
    gnugrep                # GNU grep
    gnused                 # GNU sed
    gawk                   # GNU awk
    bash                   # Bash shell
    
    # === FONTS & THEMING ===
    material-symbols       # Material Design icons
    noto-fonts            # Google Noto fonts
    noto-fonts-emoji      # Emoji support
  ];

  # === ENVIRONMENT VARIABLES ===
  home.sessionVariables = {
    # Qt6 Configuration
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_SCALE_FACTOR = "1";
    QT_QUICK_CONTROLS_STYLE = "Basic";
    QT_QUICK_FLICKABLE_WHEEL_DECELERATION = "10000";
    
    # QuickShell specific
    QS_NO_RELOAD_POPUP = "1";
    
    # Python path for scripts
    PYTHONPATH = "${pkgs.python3Packages.pywayland}/lib/python3.11/site-packages:${pkgs.python3Packages.setproctitle}/lib/python3.11/site-packages:${pkgs.python3Packages.pillow}/lib/python3.11/site-packages:${pkgs.python3Packages.numpy}/lib/python3.11/site-packages:${pkgs.python3Packages.requests}/lib/python3.11/site-packages";
    
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
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.config/matugen/templates/kde
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.local/state/quickshell/user/generated
      
      # Create Python virtual environment if it doesn't exist
      if [ ! -d "${config.home.homeDirectory}/.local/state/quickshell/.venv" ]; then
        $DRY_RUN_CMD ${pkgs.python3}/bin/python -m venv ${config.home.homeDirectory}/.local/state/quickshell/.venv
        $DRY_RUN_CMD ${config.home.homeDirectory}/.local/state/quickshell/.venv/bin/pip install Pillow numpy requests materialyoucolor
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
    '';
  };

  # === SYSTEMD USER SERVICES ===
  systemd.user.services = {
    # Ydotool daemon
    ydotool = {
      Unit = {
        Description = "Ydotool daemon";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.ydotool}/bin/ydotoold";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  # === PROGRAMS CONFIGURATION ===
  programs = {
    # Enable command-not-found for better error messages
    command-not-found.enable = true;
  };
} 