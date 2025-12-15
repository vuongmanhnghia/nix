{ config, pkgs, quickshell, ... }:

{
  # === QUICKSHELL DEPENDENCIES CONFIGURATION ===
  home.packages = with pkgs; [
    # === CORE QUICKSHELL ===
    quickshell.packages.${pkgs.system}.default  # QuickShell UI system
    wtype

    # === KDE ===
    # AUDIO
    cava
    lxqt.pavucontrol-qt
    libdbusmenu-gtk3
    playerctl

    # BACKLIGHT
    geoclue2
    brightnessctl
    ddcutil

    # BASIC
    axel
    bc
    coreutils
    cliphist
    rsync
    xdg-user-dirs          

    kdePackages.qt5compat
    kdePackages.syntax-highlighting
    kdePackages.bluedevil
    gnome-keyring
    kdePackages.plasma-nm
    kdePackages.polkit-kde-agent-1
    kdePackages.systemsettings
    
    # === QT6 FRAMEWORK ===
    # qt6.full                    # Complete Qt6 suite
    qt6.qtwayland              # Wayland support for Qt6
    qt6.qtdeclarative          # QML runtime and compiler
    qt6.qtsvg                  # SVG support
    qt6.qtimageformats         # Additional image format support
    qt6.qtmultimedia           # Multimedia support for media controls
    qt6.qtnetworkauth          # Network authentication (for AI services)
    qt6.qtpositioning          # Location and positioning services
    qt6.qttools                # Qt development tools (includes qmllint)
    
    # === AUDIO SYSTEM ===
    pavucontrol               # PulseAudio volume control
    
    # === SYSTEM MONITORING ===
    upower                    # Battery and power management
    acpi                      # ACPI utilities for battery info
    lm_sensors               # Hardware sensors
    
    # === NETWORK MANAGEMENT ===
    networkmanager           # Network connection management
    networkmanagerapplet     # NetworkManager system tray
    gnome-control-center     # Network connection editor
    
    # === BLUETOOTH ===
    bluez                    # Bluetooth protocol stack
    bluez-tools             # Bluetooth utilities
    
    # === CLIPBOARD MANAGEMENT ===
    cliphist                # Wayland clipboard history
    wl-clipboard            # Wayland clipboard utilities
    
    # === INPUT AUTOMATION ===
    ydotool                  # Input automation for Wayland
    
    # === NOTIFICATIONS ===
    libnotify               # Desktop notifications
    dunst                   # Notification daemon
    
    # === HYPRLAND INTEGRATION ===
    # Note: hyprland is provided by system (desktop/hyprland.nix) with GCC 15 fix
    hyprpicker              # Color picker
    hyprshot                # Screenshot utility
    hypridle                # Idle management
    hyprlock                # Screen locker
    hyprcursor              # Cursor theme manager
    xdg-desktop-portal-hyprland # XDG portal for Hyprland
    
    # === PYTHON DEPENDENCIES ===
    python3                 # Python runtime
    python3Packages.pywayland  # Python Wayland bindings
    python3Packages.setproctitle  # Process title setting
    python3Packages.pillow  # PIL for image processing
    python3Packages.numpy   # NumPy for image processing
    python3Packages.requests  # HTTP requests
    python3Packages.kde-material-you-colors # KDE Material You colors
    
    # === AI SERVICES (OPTIONAL) ===
    ollama                  # Local AI models
    curl                    # HTTP client for API calls
    jq                      # JSON processor
    
    # === WALLPAPER & THEMING ===
    matugen                 # Material Design color generation
    swww                    # Wallpaper manager
    imagemagick            # Image manipulation and identification
    cava                   # Audio visualizer
    
    # === UTILITIES ===
    procps                  # Process utilities (pidof, etc.)
    util-linux             # System utilities
    findutils              # File finding utilities
    gnugrep                # GNU grep
    gnused                 # GNU sed
    gawk                   # GNU awk
    bash                   # Bash shell
    
    # === FONTS & THEMING ===
    material-symbols       # Material Design icons
    noto-fonts            # Google Noto fonts
    noto-fonts-color-emoji      # Emoji support
    rubik                 # Rubik font for Hyprlock
    
    # === WIDGETS & TOOLS ===
    fuzzel                # Application launcher
    wlogout              # Logout menu
    swappy               # Screenshot editor
    grim                 # Screenshot utility
    slurp                # Area selection utility
    translate-shell      # Translation tool
    tesseract            # OCR engine
  ];
} 