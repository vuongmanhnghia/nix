{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # === WAYLAND UTILITIES ===
    grim              # Screenshot utility
    slurp             # Region selector
    hyprshot          # Screenshot tool for Hyprland
    swappy            # Screenshot editor
    wf-recorder       # Screen recording
    wtype             # Wayland type utility
    
    # === CLIPBOARD AND NOTIFICATIONS ===
    cliphist                    # Clipboard manager
    swaynotificationcenter      # Notification daemon
    
    # === VISUAL AND AUDIO ===
    swww              # Wallpaper daemon
    brightnessctl     # Brightness control
    pavucontrol       # PulseAudio volume control
    pamixer           # PulseAudio mixer
    lxqt.pavucontrol-qt  # Qt-based volume control
    
    # === SYSTEM UTILITIES ===
    playerctl                # Media player control
    networkmanagerapplet     # Network manager applet
    blueman                  # Bluetooth manager
    wlogout                  # Logout menu
    wdisplays                # Display configuration
    
    # === MULTIMEDIA ===
    cheese            # Webcam utility
    
    # === ADDITIONAL TOOLS ===
    tesseract            # OCR tool
    ffmpeg               # Multimedia framework
    
    # === AUDIO AND NOTIFICATIONS ===
    pulseaudio
    libnotify

    # === UTILITIES ===
    procps                 # Process utilities (pidof, etc.)
    util-linux             # System utilities
    findutils              # File finding utilities
    gnugrep                # GNU grep
    gnused                 # GNU sed
    gawk                   # GNU awk
    bash                   # Bash shell
  ];
}
