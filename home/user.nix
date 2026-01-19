{ config, pkgs, unstable, inputs, vars, ... }:
{
  imports = [ 
    ./default.nix
  ];

  home.username = vars.user.username;            
  home.homeDirectory = "/home/${vars.user.username}"; 
  home.stateVersion = vars.nix_version;        

  programs.git = {
    settings = {
      user = {
        name = vars.git_name;               
        email = vars.git_email;
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
    unstable.warp-terminal
    unstable.obsidian                 
    unstable.obs-studio               
    seafile-client                    
    (prismlauncher.override {
      jdks = [
        jdk
        jdk17
      ];
    })
  ];

  home.shellAliases = vars.alias;
  
  services.syncthing = vars.syncthing;

  # Tạo .npmrc file
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
    cache=${config.home.homeDirectory}/.npm-cache
    init-author-name=${vars.user.name}
    init-author-email=${vars.user.email}
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
    
    # === QUICKSHELL SPECIFIC ===
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
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
