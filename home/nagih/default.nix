{ config, pkgs, unstable, inputs, hostVars, ... }:

{
  home.username = hostVars.user.username;            
  home.homeDirectory = "/home/${hostVars.user.username}"; 
  home.stateVersion = hostVars.nix_version;
  
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
    ../../modules/home-manager/features/mpv
    ../../modules/home-manager/features/nemo
    ../../modules/home-manager/features/fastfetch
    ../../modules/home-manager/features/ripgrep
    ../../modules/home-manager/features/starship
    
    # GUI
    ../../modules/home-manager/gui/cursor
    ../../modules/home-manager/gui/fontconfig
    ../../modules/home-manager/gui/gtk-theme
    ../../modules/home-manager/gui/kde
    ../../modules/home-manager/gui/kvantum
    ../../modules/home-manager/gui/matugen
    ../../modules/home-manager/gui/qt5ct
    ../../modules/home-manager/gui/qt6ct      
  ];

  programs.direnv = {
    enable = true;
  };  

  programs.git = {
    settings = {
      user = {
        name = hostVars.git_name;               
        email = hostVars.git_email;
      };
    };
  };

  home.packages = with pkgs; [
    unstable.brave                    
    unstable.discord                  
    unstable.spotify                  
    unstable.vscode                   
    unstable.antigravity              
    unstable.telegram-desktop         
    unstable.slack                    
    unstable.obsidian                 
    unstable.obs-studio               
    (prismlauncher.override {
      jdks = [
        jdk
        jdk17
      ];
    })
  ];

  home.shellAliases = hostVars.alias;
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
    DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
    DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents";
    NIX_CONFIG = "${hostVars.nix_config}";
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

      "i-* mi-*" = {
        userKnownHostsFile = "/dev/null";
        proxyCommand = "sh -c '${pkgs.awscli2}/bin/aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters \"portNumber=%p\"'";
      };
      
      "gitlab.nooblearn2code.com" = {
        hostname = "14.225.218.83";
        user = "git";
        port = 222;
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
  };
}
