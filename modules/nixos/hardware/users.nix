{ config, pkgs, hostVars, ... }:

{
  # === USER ACCOUNT CONFIGURATION ===
  users.users = {
    ${hostVars.user.username} = {
      isNormalUser = true;     
      description = "${hostVars.user.description}";
      home = "/home/${hostVars.user.username}";
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
    };
  };

  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = true;
}