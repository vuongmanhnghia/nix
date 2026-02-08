{ config, pkgs, unstable, hostVars, ... }:

{ 
  imports = [
    ../common
    
    # Applications
    ../../modules/home-manager/apps/beekeeper-studio
    # (pkgs.callPackage ../../modules/home-manager/build/coccoc { })
  ];

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
    unstable.drawio
    unstable.teams-for-linux
    unstable.logseq
    unstable.rpi-imager
    unstable.hugo 
    unstable.ngrok
    unstable.bruno
    (prismlauncher.override {
      jdks = [
        jdk
        jdk17
      ];
    })
  ];

  home.shellAliases = {
    cls = "clear";
    blog = "cd /home/nagih/hugo";
    nix-config = "cd /home/nagih/Workspaces/config/nixos";

    # === CODE EDITOR WORKFLOW (Enhanced) ===
    code = "cursor";
    idea = "idea-community";

    # === DEVELOPMENT SHORTCUTS ===
    wsp = "cd ~/Workspaces";
    prj = "cd ~/Workspaces/projects";
    noob = "cd ~/Workspaces/noob";
    ptit = "cd ~/Workspaces/ptit";
    vir = "cd ~/Workspaces/virtual";
    janus = "cd ~/Workspaces/projects/Janus";
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
