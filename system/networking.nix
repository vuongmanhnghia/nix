{ config, pkgs, ... }:
{
  networking = {
    # === SYSTEM IDENTIFICATION ===
    hostName = "nixos"; # System hostname for network identification
    networkmanager = {
      enable = true; # Enable NetworkManager for easy network management
      # Tối ưu WiFi performance
      wifi = {
        powersave = false; # Tắt powersave cho WiFi để có hiệu suất tốt hơn
        scanRandMacAddress = false; # Tắt random MAC để tránh vấn đề kết nối
      };
      # Cải thiện DNS resolution
      dns = "systemd-resolved";
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
    
    # === DNS CONFIGURATION ===
    nameservers = [
      "1.1.1.1"     # Cloudflare DNS primary (thường nhanh hơn cho VN)
      "1.0.0.1"     # Cloudflare DNS secondary
      "8.8.8.8"     # Google DNS primary (backup)
      "8.8.4.4"     # Google DNS secondary (backup)
    ];
    
    # === WIRELESS CONFIGURATION ===
    # wireless.enable = false; # Đảm bảo tắt wpa_supplicant khi dùng NetworkManager
  };

  # === SYSTEM OPTIMIZATION ===
  # Tối ưu kernel parameters cho network
  boot.kernel.sysctl = {
    # Network buffer optimization
    "net.core.rmem_default" = 262144;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_default" = 262144;
    "net.core.wmem_max" = 16777216;
    "net.core.netdev_max_backlog" = 5000;
    
    # TCP optimization
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
    
    # Giảm latency
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_low_latency" = 1;
  };

  # === HARDWARE SUPPORT ===
  # Enable firmware cho WiFi cards
  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true; # Bao gồm non-free firmware nếu cần
  };

  # === SERVICES ===
  # Systemd-resolved cho DNS caching
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
    fallbackDns = [ "8.8.8.8" "8.8.4.4" ];
    extraConfig = ''
      DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com
      FallbackDNS=8.8.8.8#dns.google 8.8.4.4#dns.google
      DNSOverTLS=yes
      MulticastDNS=yes
      LLMNR=yes
      Cache=yes
      CacheFromLocalhost=no
    '';
  };

  # === VPN SERVICES ===
  services.tailscale = {
    enable = true; # Enable Tailscale VPN mesh network
    useRoutingFeatures = "client"; # Enable routing features for client mode
    openFirewall = true; # Automatically open required firewall ports
    # Allow user to control Tailscale without sudo
    extraUpFlags = [ "--operator=nagih" ];
  };

  # === ADDITIONAL OPTIMIZATIONS ===
  # Network tools hữu ích cho debugging
  environment.systemPackages = with pkgs; [
    networkmanager-openvpn  # OpenVPN support
    networkmanager-openconnect  # Cisco VPN support
    wirelesstools           # iwconfig, iwlist
    iw                      # modern wireless tools
    ethtool                 # ethernet tools
    tcpdump                 # network monitoring
    iperf3                  # network performance testing
    mtr                     # network diagnostic tool
  ];

  # === MODULE LOADING ===
  # Đảm bảo load các module cần thiết
  boot.extraModulePackages = with config.boot.kernelPackages; [
    # Thêm driver WiFi cụ thể nếu cần, ví dụ:
    # rtl8821ce  # cho Realtek WiFi cards
    # broadcom_sta  # cho Broadcom WiFi cards
  ];

  # Load modules at boot nếu cần
  boot.kernelModules = [
    # "iwlwifi"  # Intel WiFi
    # "ath9k"    # Atheros WiFi
    # Uncomment module phù hợp với WiFi card của bạn
  ];
}