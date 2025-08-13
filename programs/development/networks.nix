{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nmap            # Network discovery and security auditing tool
    inetutils       # Network utilities (ping, traceroute, etc.)
    tailscale       # Network connectivity for developers
  ];
}