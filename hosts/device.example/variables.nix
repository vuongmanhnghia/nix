rec {
  # NIX
  nix_version = "25.11";
  nix_config = ""; # Path to NixOS config (pwd)

  # SYSTEM
  isa = ""; # uname -m (lowercase)
  os = ""; # uname -s (lowercase)

  # DISPLAY
  port_name = "";                 # xrandr | grep " connected" | head -1 | awk '{print $1}'
  resolution = "";                # xrandr | grep " connected" | head -1 | awk '{print $3}' | cut -d '+' -f 1
  frequency = "";                 # xrandr | grep -oP '\d+\.\d+(?=[*+ ])' | sort -rn | head -n 1

  # NETWORKING
  hostname = "";
  nameservers = [ ];
  firewall = {
    enable = true;
    tcp_ports = [ ];
    udp_ports = [ ];
    trusted_interfaces = [ ];
  };
  fallback_dns = [ ];
  tailscale = { enable = false; };

  # USER
  user = {
    name = "";
    username = ""; # (home.username)
    description = "";
    email = "";
  };

  # GIT
  git_name = "${user.name}";
  git_email = "${user.email}";

  # ALIAS
  alias = { };

  # SYNCTHING
  syncthing = { enable = false; };

  # CLOUDFLARED
  cloudflared = { enable = false; };
}