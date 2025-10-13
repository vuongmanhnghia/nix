{ config, pkgs, ... }:

{
  # Hyprland system configuration
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Essential system packages for Hyprland
  environment.systemPackages = with pkgs; [
    # Core applications (defined in dotfiles/hypr/conf/programs.conf)
    kitty
    nemo
    
    # Wayland utilities
    wl-clipboard
    grim
    slurp
    hyprshot
    
    # Visual and audio
    swww
    cava
    brightnessctl
    pavucontrol
    
    # Clipboard and notifications
    cliphist
    swaynotificationcenter
    wlogout
    
    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    
    # Theming
    papirus-icon-theme
    catppuccin-gtk
    catppuccin-cursors.mochaDark
    apple-cursor
    
    # Wallpaper theming
    matugen
    
    # Utilities
    playerctl
    networkmanagerapplet
    blueman
    oh-my-posh
    fastfetch
    
    # Qt theming
    libsForQt5.qt5ct
    kdePackages.qt6ct
    
    # Additional tools
    gnome-characters
    vips
    nwg-look
    cheese
    loupe
    celluloid
    gnome-text-editor
    obs-studio
    ffmpeg
    
    # Audio and notifications
    pulseaudio
    libnotify

    hyprlock
    pamixer

    hyprpicker
    hyprcursor
    swappy
    wf-recorder

    foot
    fish
    starship
    eza


    python3Packages.kde-material-you-colors
    # kvantum
    libsForQt5.qt5ct
    qt6Packages.qt6ct

    mpv
    lxqt.pavucontrol-qt
    tesseract

    fuzzel
    wdisplays
  ];

  # Display manager
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = false;
    displayManager.gdm.enable = false;
  };
  
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Environment variables (configured in dotfiles/hypr/conf/environment.conf)
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  # Services
  security.polkit.enable = true;
  services.gvfs.enable = true;
} 