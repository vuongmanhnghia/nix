{ config, pkgs, lib, ... }:

{
  # Hyprland system configuration  
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Essential system packages for Hyprland
  environment.systemPackages = with pkgs; [
    papirus-icon-theme
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

    # GCC 15 lib for GLIBCXX_3.4.34 (required by Hyprland 0.52.1)
    gcc15.cc.lib
    
    # Wrapper for Hyprland with correct LD_LIBRARY_PATH
    (pkgs.writeShellScriptBin "hyprland" ''
      export LD_LIBRARY_PATH="${pkgs.gcc15.cc.lib}/lib:$LD_LIBRARY_PATH"
      exec ${pkgs.hyprland}/bin/Hyprland "$@"
    '')
  ];

  # Services
  security.polkit.enable = true;
  services.gvfs.enable = true;

  # Environment variables (configured in dotfiles/hypr/conf/environment.conf)
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };
  
  # Add GCC 15 lib to LD_LIBRARY_PATH for GLIBCXX_3.4.34 (required by Hyprland)
  environment.sessionVariables.LD_LIBRARY_PATH = pkgs.lib.mkAfter [ "${pkgs.gcc15.cc.lib}/lib" ];
}