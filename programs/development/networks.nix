{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    arp-scan        # Network discovery tool (Layer 2)
    nmap            # Network discovery and security auditing tool (Layer 3/4)
    netplan         # Network configuration tool
    dig             # DNS lookup tool
    inetutils       # Network utilities (ping, traceroute, etc.)
    # tailscale       # Network connectivity for developers
  ];
}