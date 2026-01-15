{ config, pkgs, ... }:

{
  # === USER ACCOUNT CONFIGURATION ===
  users.users = {
    nagih = {
      isNormalUser = true;      # Standard user account (not system user)
      description = "Nagih";    # User description for display
      home = "/home/nagih";
      extraGroups = [ 
        "wheel"           # Enable sudo
        "networkmanager"  # Manage network connections
        "audio"           # Access audio devices
        "realtime"        # Real-time scheduling
        "video"           # Access video devices  
        "input"           # Access input devices
        "storage"         # Access storage devices
        "optical"         # Access optical drives
        "scanner"         # Access scanners
        "libvirtd"        # Virtualization
        "docker"          # Docker 
        "systemd-journal" # Read system logs
        "disk"            # Disk management access
        "adbusers"        # D-Bus access
        "kvm"             # KVM access
        "plugdev"         # Hotplug devices
      ];
      shell = pkgs.zsh;  # Default shell (zsh)

      # openssh.authorizedKeys.keys = [
      #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5zy0044P9cHpQ9zhu3wdnGzPrYIeVHavdd3sxeopHU vuongmanhnghia@gmail.com"
      # ];
    };
  };

  # Enable zsh system-wide if using it
  programs.zsh.enable = true;
  
  # Security configuration
  security.sudo.wheelNeedsPassword = true; # Require password for sudo

  # === SYSTEM GROUPS ===
  users.groups = {
    docker = {};  # Docker group for container management permissions
  };
}