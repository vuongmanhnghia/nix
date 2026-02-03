{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # === WAYLAND UTILITIES ===
    wl-clipboard      # Wayland clipboard utilities
    grim              # Screenshot utility
    slurp             # Region selector
    hyprshot          # Screenshot tool for Hyprland
    swappy            # Screenshot editor
    wf-recorder       # Screen recording
    
    # === CLIPBOARD AND NOTIFICATIONS ===
    cliphist                    # Clipboard manager
    swaynotificationcenter      # Notification daemon
    
    # === VISUAL AND AUDIO ===
    swww              # Wallpaper daemon
    cava              # Audio visualizer
    brightnessctl     # Brightness control
    pavucontrol       # PulseAudio volume control
    pamixer           # PulseAudio mixer
    lxqt.pavucontrol-qt  # Qt-based volume control
    
    # === SYSTEM UTILITIES ===
    playerctl                # Media player control
    networkmanagerapplet     # Network manager applet
    blueman                  # Bluetooth manager
    wlogout                  # Logout menu
    fuzzel                   # Application launcher
    wdisplays                # Display configuration
    
    # === MULTIMEDIA ===
    mpv               # Video player
    cheese            # Webcam utility
    
    # === SYSTEM INFO ===
    fastfetch         # System information tool
    
    # === ADDITIONAL TOOLS ===
    tesseract            # OCR tool
    ffmpeg               # Multimedia framework
    
    # === AUDIO AND NOTIFICATIONS ===
    pulseaudio
    libnotify
  ];
}
