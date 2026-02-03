{ config, pkgs, hostVars, ... }: 

{
  networking = {
    hostName = hostVars.hostname;
    
    nameservers = hostVars.nameservers;

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      connectionConfig = {
        "ipv4.ignore-auto-dns" = "yes";
        "ipv6.ignore-auto-dns" = "yes";
      };
    };

    firewall = {
      enable = true;
      allowedTCPPorts = hostVars.firewall.tcp_ports;
      allowedUDPPorts = hostVars.firewall.udp_ports;
      trustedInterfaces = hostVars.firewall.trusted_interfaces;
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
    fallbackDns = hostVars.fallback_dns;
    extraConfig = ''
      DNSOverTLS=opportunistic
      MulticastDNS=yes
    '';
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
    extraUpFlags = [ "--operator=${hostVars.user.name}" "--accept-dns=false" ]; 
  };

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true; 
  };
}