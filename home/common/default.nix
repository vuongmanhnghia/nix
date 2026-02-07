{ config, pkgs, unstable, inputs, commonVars, hostVars, ... }:

{
  home.username = hostVars.user.username;            
  home.homeDirectory = "/home/${hostVars.user.username}"; 
  home.stateVersion = commonVars.nix_version;
  
  imports = [
    # Desktop
    ../../modules/home-manager/desktop/hyprland
    ../../modules/home-manager/desktop/hyprlock
    ../../modules/home-manager/desktop/hypridle
    ../../modules/home-manager/desktop/xdg-portal

    # Features
    ../../modules/home-manager/features/quickshell
    ../../modules/home-manager/features/zsh
    ../../modules/home-manager/features/nvim
    ../../modules/home-manager/features/wezterm
    ../../modules/home-manager/features/tmux
    ../../modules/home-manager/features/git
    ../../modules/home-manager/features/fcitx5
    ../../modules/home-manager/features/mpv
    ../../modules/home-manager/features/nemo
    ../../modules/home-manager/features/fastfetch
    ../../modules/home-manager/features/ripgrep
    ../../modules/home-manager/features/starship
    ../../modules/home-manager/features/cava
    ../../modules/home-manager/features/kitty
    ../../modules/home-manager/features/qimgv

    # CLI
    ../../modules/home-manager/features/cli/nix
    ../../modules/home-manager/features/cli/utils
    ../../modules/home-manager/features/cli/devtools
    
    # GUI
    ../../modules/home-manager/gui/cursor
    ../../modules/home-manager/gui/fontconfig
    ../../modules/home-manager/gui/gtk-theme
    ../../modules/home-manager/gui/kde
    ../../modules/home-manager/gui/kvantum
    ../../modules/home-manager/gui/matugen
    ../../modules/home-manager/gui/qt5ct
    ../../modules/home-manager/gui/qt6ct  

    # Development
    ../../modules/home-manager/development/database
    ../../modules/home-manager/development/lsp/python
    ../../modules/home-manager/development/lsp/golang
    ../../modules/home-manager/development/lsp/cpp
    ../../modules/home-manager/development/virtualization/machines
    ../../modules/home-manager/development/virtualization/docker
    ../../modules/home-manager/development/virtualization/kubernetes
    ../../modules/home-manager/development/networking
  ];

  programs.direnv.enable = true;
  programs.git.settings.user = {
    name = hostVars.git_name;               
    email = hostVars.git_email;
  };

  services.syncthing = hostVars.syncthing;

  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
    cache=${config.home.homeDirectory}/.npm-cache
    init-author-name=${hostVars.user.name}
    init-author-email=${hostVars.user.email}
    init-license=MIT
    save-exact=true
    package-lock=true
  '';

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    documents = "${config.home.homeDirectory}/Documents";
    pictures = "${config.home.homeDirectory}/Pictures";
    
    extraConfig = {
      XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
      XDG_WORKSPACES_DIR = "${config.home.homeDirectory}/Workspaces";
    };
  };

  home.sessionVariables = {
    # Editor
    EDITOR = "nvim";
    VISUAL = "nvim";

    # Directories
    DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
    DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents";
    NIX_CONFIG_DIR = "${hostVars.nix_config}";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    
    extraConfig = ''
      AddKeysToAgent yes
      IdentityFile ~/.ssh/id_ed25519
    '';

    matchBlocks = {
      "*" = {
        forwardAgent = false;
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        compression = true;
        identitiesOnly = true;
      };
    };
  };
}
