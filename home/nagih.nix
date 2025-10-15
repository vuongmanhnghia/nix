{ config, pkgs, unstable, inputs ? {}, ... }:

{
  # === IMPORT SHARED CONFIGURATION ===
  imports = [ 
    ./default.nix                    # Import shared home configuration for all users
  ];

  # === USER INFORMATION ===
  home.username = "nagih";            # Username for this configuration
  home.homeDirectory = "/home/nagih"; # User's home directory path
  home.stateVersion = "25.05";        # Home Manager version (should match NixOS)

  # === USER-SPECIFIC GIT CONFIGURATION ===
  programs.git = {
    userName = "Nagih";                    # Git commit author name
    userEmail = "vuongmanhnghia@gmail.com"; # Git commit author email
  };

  # xdg.desktopEntries.cursor = {
  #   name = "Cursor";
  #   noDisplay = true;
  # };

  # === USER-SPECIFIC APPLICATIONS ===
  home.packages = with pkgs; [
    # === PERSONAL PRODUCTIVITY APPLICATIONS ===
    unstable.brave                    # Brave web browser
    unstable.discord                  # Discord chat and communication platform
    unstable.spotify                  # Spotify music streaming service
    unstable.vscode                   # Visual Studio Code - Source code editor
    unstable.jetbrains.idea-community # IntelliJ IDEA Community Edition
    unstable.telegram-desktop         # Telegram desktop
    
    # === PRODUCTIVITY AND CONTENT CREATION ===
    unstable.obsidian                 # Note-taking and knowledge management application
    unstable.zoom-us                  # Zoom video conferencing and collaboration tool
    unstable.obs-studio               # Open Broadcaster Software for streaming and recording

    unstable.lorien                   # Lorien - A modern, feature-rich note-taking app
    unstable.rpi-imager               # Raspberry Pi Imager

    # === VRCHAT ===
    # unstable.alcom                    # Alcom - A modern, feature-rich note-taking app
    # unstable.alvr                     # ALVR - Android VR Headset Emulator

    # === MINECARFT ===
    (prismlauncher.override {
      # Cung cấp các phiên bản Java mà Minecraft thường yêu cầu
      jdks = [
        jdk
      ];
    })
  ];

  home.shellAliases = {
    blog = "cd /home/nagih/hugo";
  };
  
  # === SYNCTHING FILE SYNCHRONIZATION SERVICE ===
  services.syncthing = {
    enable = true;  # Enable Syncthing file synchronization
    
    settings = {
      # === SYNCTHING WEB GUI CONFIGURATION ===
      gui = {
        address = "127.0.0.1:8384";  # Local web interface address
        user = "nagih";              # GUI username
      };
      
      # === DEVICE CONFIGURATION ===
      devices = {
        "laptop" = { id = "Q2LOGWQ-TERICTE-TXSUI6Q-5ZRDFEG-BEBWGFE-CVKBXTF-XHBSNCN-U6PHIA3"; };
        "desktop" = { id = "CQA7ZJT-S4HOWZ5-TZLMHEC-B7XGZB4-XWVA7BM-IPR3RPL-SCTFXIA-O6GSHQQ"; };
      };
      
      # === FOLDER SYNCHRONIZATION CONFIGURATION ===
      folders = {
        "Pictures" = {
          id = "pictures";
          path = "/home/nagih/Pictures";
          devices = [ "laptop" "desktop" ];
        };
        
        "Documents" = {
          id = "documents";
          path = "/home/nagih/Documents";
          devices = [ "laptop" "desktop" ];
        };
        
        "Workspaces" = {
          id = "workspaces";
          path = "/home/nagih/Workspaces";
          devices = ["desktop" "laptop"];
        };
      };
    };
  };

  # Tạo .npmrc file
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
    cache=${config.home.homeDirectory}/.npm-cache
    init-author-name=Nagih
    init-author-email=vuongmanhnghia@gmail.com
    init-license=MIT
    save-exact=true
    package-lock=true
  '';
  
  # === DIRECTORY CREATION ===
  home.activation.createSyncDirs = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/Documents
    mkdir -p $HOME/Workspaces
    mkdir -p $HOME/Pictures/Screenshots
  '';

  # === USER-SPECIFIC ENVIRONMENT VARIABLES ===
  home.sessionVariables = {
    DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
    DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents";
    
    # === HYPRLAND SPECIFIC ===
    TERMINAL = "kitty";
    BROWSER = "brave";
    EDITOR = "nvim";
    
    # === QUICKSHELL SPECIFIC ===
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
}