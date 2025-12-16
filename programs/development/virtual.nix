{ config, pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    docker-compose   # Multi-container Docker orchestration
    vagrant          # Development environment manager
    qemu             # Generic and open source machine emulator and virtualizer
    libvirt          # API for managing platform virtualization
    virt-manager     # Desktop user interface for managing virtual machines
    libguestfs       # Tools for accessing and modifying virtual machine disk images
    ansible          # Automation tool for configuration management and application deployment
    terraform        # Infrastructure as Code tool for building, changing, and versioning infrastructure
    awscli2          # Official Amazon AWS command-line interface version 2
  ];  
  
  virtualisation = {
    # === DOCKER CONFIGURATION ===
    docker = {
      enable = true;        # Enable Docker containerization platform
      # Automatic cleanup to prevent disk space issues
      autoPrune = {
        enable = true;      # Enable automatic cleanup of unused Docker resources
        dates = "weekly";   # Run cleanup weekly
      };
    };

    # === VIRTUALIZATION CONFIGURATION ===
    libvirtd.enable = true;  # API for managing KVM/QEMU and platform virtualization
  };

  # Libvirt network configuration for WiFi bridge
  environment.etc."libvirt/qemu/networks/macvtap-bridge.xml".text = ''
    <network>
      <name>macvtap-bridge</name>
      <forward mode='bridge'>
        <interface dev='wlp0s20f3'/>
      </forward>
    </network>
  '';

  virtualisation.libvirtd.extraConfig = ''
    network_autostart_every_boot = 1
  '';
}