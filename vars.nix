rec {
  # NIX
  nix_version = "25.11";
  nix_config = "~/Workspaces/config/nixos"; # Path to NixOS config

  # SYSTEM
  isa = "x86_64"; # uname -m (lowercase)
  os = "linux"; # uname -s (lowercase)

  # DISPLAY
  port_name = "DP-1";               # xrandr | grep " connected" | head -1 | awk '{print $1}'
  resolution = "2560x1440";         # xrandr | grep " connected" | head -1 | awk '{print $3}' | cut -d '+' -f 1
  frequency = "180";                # xrandr | grep -oP '\d+\.\d+(?=[*+ ])' | sort -rn | head -n 1
  
  # ENVIRONMENT
  environments = [
    "GDK_SCALE,1"
    "ELM_SCALE,1"
    "QT_SCALE_FACTOR,1"
    
    # === CURSOR THEME ===
    "XCURSOR_THEME,apple-cursor"
    "XCURSOR_SIZE,24"
    "HYPRCURSOR_THEME,apple-cursor"
    "HYPRCURSOR_SIZE,24"

    # ############ Wayland #############
    "ELECTRON_OZONE_PLATFORM_HINT,auto"

    # ############ Themes #############
    "XDG_MENU_PREFIX,plasma-"
    "QT_QPA_PLATFORMTHEME,qt6ct"

    # ######## Virtual envrionment #########
    "ILLOGICAL_IMPULSE_VIRTUAL_ENV, ~/.local/state/quickshell/.venv"
  ];

  # NETWORKING
  hostname = "nixos";
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
        "syncthing-server" = { 
          id = "6DLXC5P-OYUDW5M-7NYJOSU-3DHKU65-2KECRVD-MEVDAF4-CYTOJWE-7NJXFAF";
          addresses = [ "tcp://14.225.218.83:22000" ];
        };
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

  # CLOUDFLARED TUNNEL
  # tunnel = {
  #   id = "5f129b60-0c24-4fd4-9cbd-0b42657d59f7";
  #   domain = "nooblearn2code.com";
  #   file = "${nix_config}/secrets/cloudflared.age";
  #   owner = "root";
  #   mode = "440";
  # };

  cloudflared = {
    enable = false;

    # tunnels = {
    #   "${tunnel.id}" = {
    #     credentialsFile = config.age.secrets.cloudflared.path;     

    #     default = "http_status:404";
        
    #     ingress = {
    #       "labs.${tunnel.domain}" = {
    #         service = "https://localhost:9443";
    #         originRequest = {
    #           noTLSVerify = true; 
    #           httpHostHeader = "labs.${tunnel.domain}";
    #         };
    #       };

    #       "nixos.${tunnel.domain}" = {
    #         service = "ssh://localhost:22";
    #         originRequest = {
    #           noTLSVerify = true; 
    #           httpHostHeader = "nixos.${tunnel.domain}";
    #         };
    #       };
          
    #       "edge.${tunnel.domain}" = {
    #         service = "http://localhost:8000";
    #       };
    #     };
    #   };
    # };
  };
}