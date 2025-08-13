{ config, pkgs, ... }:

{
  # === IMPORT SHARED CONFIGURATION ===
  imports = [ 
    ./default.nix         # Import shared home configuration for all users
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

  xdg.desktopEntries.cursor = {
    name = "Cursor";
    noDisplay = true;
  };

  # === USER-SPECIFIC APPLICATIONS ===
  home.packages = with pkgs; [
    # === PERSONAL PRODUCTIVITY APPLICATIONS ===
    firefox         # Firefox web browser
    discord         # Discord chat and communication platform
    spotify         # Spotify music streaming service
    code-cursor     # Cursor AI-powered code editor
    navicat-premium # Navicat Premium - Database management tool
   
    # === GAMING APPLICATIONS ===
    steam           # Steam gaming platform
    steam-run       # Steam runtime for non-Steam applications
    protonup-qt     # Proton version management GUI tool
    winetricks      # Wine/Proton dependency management tool
    
    # === PRODUCTIVITY AND CONTENT CREATION ===
    obsidian        # Note-taking and knowledge management application
    zoom-us         # Zoom video conferencing and collaboration tool
    obs-studio      # Open Broadcaster Software for streaming and recording

    lorien          # Lorien - A modern, feature-rich note-taking app
    

    # === VRCHAT ===
    alcom           # Alcom - A modern, feature-rich note-taking app
    alvr            # ALVR - Android VR Headset Emulator

    rpi-imager      # Raspberry Pi Imager
    
  ];

  home.shellAliases = {
    blog = "cd /home/nagih/blog";
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
      # Define other devices for synchronization (replace IDs with actual device IDs)
      devices = {
        "laptop" = { id = "Q2LOGWQ-TERICTE-TXSUI6Q-5ZRDFEG-BEBWGFE-CVKBXTF-XHBSNCN-U6PHIA3"; };   # Laptop device
        "desktop" = { id = "IZLHQHS-TLCQ6EV-XR73OJA-K5F6AUD-OOBNS4I-G4M5NGL-FYZWEHU-AQF3WA4"; }; # Desktop device
      };
      
      # === FOLDER SYNCHRONIZATION CONFIGURATION ===
      folders = {
        # Synchronize Documents folder across devices
        "Documents" = {
          id = "documents";                     # Unique folder identifier
          path = "/home/nagih/Documents";       # Local folder path
          devices = [ "laptop" "desktop" ];     # Devices to sync with
        };
        
        # Synchronize Workspaces folder for development projects
        # "Workspaces" = {
        #   id = "workspaces";                    # Unique folder identifier
        #   path = "/home/nagih/Workspaces";      # Local folder path
        #   devices = ["desktop" "laptop"];       # Devices to sync with

        #   ignores = [
        #     # Loại bỏ nix configuration
        #     "**/Config/nixos/"

        #     # Loại bỏ các folder node_modules (thường rất lớn)
        #     "node_modules/"
        #     "**/node_modules/"
            
        #     # Loại bỏ các folder build/dist outputs
        #     "build/"
        #     "dist/"
        #     "**/build/"
        #     "**/dist/"
            
        #     # Loại bỏ các folder cache và temporary
        #     ".cache/"
        #     "**/.cache/"
        #     "tmp/"
        #     "**/tmp/"
            
        #     # Loại bỏ các file log
        #     "*.log"
        #     "**/*.log"
            
        #     # Loại bỏ các folder cụ thể theo tên
        #     "project-secret/"
        #     "old-projects/"
        #     "archived/"
            
        #     # Loại bỏ các file và folder ẩn của IDE
        #     ".vscode/"
        #     ".idea/"
        #     "**/.vscode/"
        #     "**/.idea/"
            
        #     # Loại bỏ các folder git (nếu không muốn sync .git)
        #     ".git/"
        #     "**/.git/"
            
        #     # Loại bỏ các file backup
        #     "*.bak"
        #     "*.backup"
        #     "*~"
        #   ];
        # };
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
  # Ensure required directories exist for Syncthing
  home.activation.createSyncDirs = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/Documents   # Create Documents directory if it doesn't exist
    mkdir -p $HOME/Workspaces  # Create Workspaces directory if it doesn't exist
    mkdir -p $HOME/Pictures/Screenshots  # Create Screenshots directory for Hyprland
  '';

  # === USER-SPECIFIC ENVIRONMENT VARIABLES ===
  home.sessionVariables = {
    DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";  # Downloads directory path
    DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents"; # Documents directory path
    
    # === HYPRLAND SPECIFIC ===
    TERMINAL = "kitty";                                      # Default terminal
    BROWSER = "firefox";                                       # Default browser  
    EDITOR = "nvim";                                          # Default editor
  };
}
