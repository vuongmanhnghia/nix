{ config, pkgs, vars, ... }: 

{
  networking = {
    hostName = vars.hostname;
    
    nameservers = vars.nameservers;

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
      allowedTCPPorts = vars.firewall.tcp_ports;
      allowedUDPPorts = vars.firewall.udp_ports;
      trustedInterfaces = vars.firewall.trusted_interfaces;
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
    fallbackDns = vars.fallback_dns;
    extraConfig = ''
      DNSOverTLS=opportunistic
      MulticastDNS=yes
    '';
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
    extraUpFlags = [ "--operator=${vars.user.name}" "--accept-dns=false" ]; 
  };

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true; 
  };
}