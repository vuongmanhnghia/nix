{ config, pkgs, hostVars, ... }:

{
  environment.systemPackages = with pkgs; [
    docker-compose   # Multi-container Docker orchestration
    vagrant          # Development environment manager
    qemu             # Generic and open source machine emulator and virtualizer
    libvirt          # API for managing platform virtualization
    virtiofsd        # Virtio Filesystem Daemon for shared folder support
    virt-manager     # Desktop user interface for managing virtual machines
    libguestfs       # Tools for accessing and modifying virtual machine disk images
    ansible          # Automation tool for configuration management and application deployment
    terraform        # Infrastructure as Code tool for building, changing, and versioning infrastructure
    awscli2          # Official Amazon AWS command-line interface version 2
    ssm-session-manager-plugin
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
    libvirtd = {
      enable = true;        # Enable libvirt daemon for virtualization management
      qemu = {
        package = pkgs.qemu_kvm;  # Use KVM-enabled QEMU for better performance
        runAsRoot = false;         # Run QEMU as unprivileged user (more secure)
        swtpm.enable = true;       # Enable TPM emulation support
        # OVMF is now included by default, no need to configure
      };
      onBoot = "start";            # Start default libvirt networks on boot
      onShutdown = "shutdown";     # Gracefully shutdown VMs on host shutdown
    };

    # Shared memory for better VM performance
    spiceUSBRedirection.enable = true;
  };

  # Add user to required groups for virtualization
  users.users.${hostVars.user.username} = {
    extraGroups = [ "libvirtd" "docker" "kvm" ];
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

  # Enable dnsmasq for libvirt default network
  virtualisation.libvirtd.extraConfig = ''
    unix_sock_group = "libvirtd"
    unix_sock_rw_perms = "0770"
  '';

  # Optional: Enable nested virtualization (if your CPU supports it)
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_amd nested=1
  '';
}