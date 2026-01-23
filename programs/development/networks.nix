{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    arp-scan        # Network discovery tool (Layer 2)
    nmap            # Network discovery and security auditing tool (Layer 3/4)
    netplan         # Network configuration tool
    dig             # DNS lookup tool
    inetutils       # Network utilities (ping, traceroute, etc.)
    stun            # NAT traversal tool
    linssid         # Wireless network scanner
    wireshark       # Network protocol analyzer
    kubectl         # Kubernetes command-line tool
    cilium-cli      # Cilium command-line tool
  ];
}