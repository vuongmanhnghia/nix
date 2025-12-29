{
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";  # Để NetworkManager giao DNS cho systemd-resolved
      wifi = {
        powersave = false;
        scanRandMacAddress = false;
      };
    };

    # === FIREWALL CONFIGURATION ===
    firewall = {
      enable = true; # Enable firewall protection
      allowedTCPPorts = [
        22   # SSH - remote access
        80   # HTTP - web server
        443  # HTTPS - secure web server

        3000 # Development server port
        8080 # Alternative HTTP port
        8081 # Alternative HTTP port
      ];
      allowedUDPPorts = [ ]; # No UDP ports opened by default
      # Allow Tailscale traffic
      trustedInterfaces = [ "tailscale0" ];
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
    fallbackDns = [ "8.8.8.8" "8.8.4.4" ];
    extraConfig = ''
      DNS=1.1.1.1 1.0.0.1
      FallbackDNS=8.8.8.8 8.8.4.4
      DNSOverTLS=yes
      Cache=yes
    '';
  };

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true; # Bao gồm non-free firmware nếu cần
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client"; # Enable routing features for client mode
    openFirewall = true; # Automatically open required firewall ports
    # Allow user to control Tailscale without sudo
    extraUpFlags = [ "--operator=nagih" ];
  };
}