rec {
  # NIX
  nix_version = "25.11";
  nix_config = "~/Workspaces/config/nixos"; # Path to NixOS config

  # SYSTEM
  isa = "x86_64"; # uname -m (lowercase)
  os = "linux"; # uname -s (lowercase)

  # DISPLAY
  port_name = "eDP-1";               # xrandr | grep " connected" | head -1 | awk '{print $1}'
  resolution = "1920x1080";         # xrandr | grep " connected" | head -1 | awk '{print $3}' | cut -d '+' -f 1
  frequency = "144.00";                # xrandr | grep -oP '\d+\.\d+(?=[*+ ])' | sort -rn | head -n 1

  # NETWORKING
  hostname = "nixos-laptop";
  nameservers = [ "8.8.8.8" "8.8.4.4" ];
  firewall = {
    enable = true;
    tcp_ports = [ 
      22
      80
      443
    ];
    udp_ports = [ ];
    trusted_interfaces = [ "tailscale0" ];
  };
  fallback_dns = [ "1.1.1.1" "1.0.0.1" ];
  tailscale = {
    enable = true;
  };

  # USER
  user = {
    name = "Nagih";
    username = "nagih";
    description = "Vuong Manh Nghia";
    email = "vuongmanhnghia@gmail.com";
  };

  # GIT
  git_name = "Nagih";
  git_email = "vuongmanhnghia@gmail.com";

  # ALIAS
  alias = {
    cls = "clear";
    blog = "cd /home/${user.username}/hugo";

    # === SYSTEM MANAGEMENT (Enhanced) ===
    oh = "cd ~/ && echo 'Went back home'";
    nixc = "cd ${nix_config}";
    nix-rebuild = "sudo nixos-rebuild switch --flake ${nix_config} --impure";
    nix-test = "sudo nixos-rebuild test --flake ${nix_config} --impure";
    home-rebuild = "home-manager switch --flake ${nix_config}";
    generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    nix-clean = "sudo nix-collect-garbage -d && sudo nix-collect-garbage -d && nix-store --optimize";
    nix-reset = "sudo systemctl stop nix-daemon && sudo rm -rf /nix/store/* && sudo rm -rf /nix/var/nix/db/* && sudo systemctl start nix-daemon && sudo nixos-rebuild switch --flake ${nix_config} --impure";

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
    
    # === DOCUMENTATION ===
    docs = "cd ~/Documents";
    down = "cd ~/Downloads";   
  };

  # SYNCTHING
  syncthing = {
    enable = true;
    
    settings = {
      gui = {
        address = "127.0.0.1:8384";  
        user = "${user.username}";          
      };

      devices = {
        "nixos-desktop" = { id = "CQA7ZJT-S4HOWZ5-TZLMHEC-B7XGZB4-XWVA7BM-IPR3RPL-SCTFXIA-O6GSHQQ"; };
        "syncthing-server" = { id = "C746FCG-KGT3QXD-ITR65Y5-CNWNSAI-YGLNZNL-TUFTRZF-D4R3M5M-3BRTPQN"; };
      };
      
      folders = {
        "workspaces" = {
          id = "workspaces";
          path = "/home/${user.username}/Workspaces";
          devices = [ "nixos-desktop" "syncthing-server" ];
        };
        "documents" = {
          id = "documents";
          path = "/home/${user.username}/Documents";
          devices = [ "nixos-desktop" "syncthing-server" ];
        };
        "pictures" = {
          id = "pictures";
          path = "/home/${user.username}/Pictures";
          devices = [ "nixos-desktop" "syncthing-server" ];
        };
        "hugo" = {
          id = "hugo";
          path = "/home/${user.username}/hugo";
          devices = [ "nixos-desktop" "syncthing-server" ];
        };
      };
    };
  };

  cloudflared = {
    enable = false;
  };
}