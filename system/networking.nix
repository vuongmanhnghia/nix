{ config, pkgs, ... }: 

{
  networking = {
    hostName = "nixos";
    
    nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ]; 

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
      allowedTCPPorts = [ 22 80 443 3000 8080 8081 ];
      allowedUDPPorts = [ ]; 
      trustedInterfaces = [ "tailscale0" ];
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
    fallbackDns = [ "8.8.8.8" "8.8.4.4" ];
    extraConfig = ''
      DNSOverTLS=opportunistic
      MulticastDNS=yes
    '';
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
    extraUpFlags = [ "--operator=nagih" "--accept-dns=false" ]; 
  };

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true; 
  };
}