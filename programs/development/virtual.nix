{ config, pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    docker-compose    # Multi-container Docker orchestration

    vagrant           # Development environment manager

    qemu             # Generic and open source machine emulator and virtualizer
    libvirt          # API for managing platform virtualization
    virt-manager     # Desktop user interface for managing virtual machines
    libguestfs       # Tools for accessing and modifying virtual machine disk images
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
    virtualbox.host.enable = false;
  };

  # === NETWORK BRIDGE CONFIGURATION ===
  # networking.bridges.br0.interfaces = [ "eno1" ];
  # networking.interfaces.br0.useDHCP = true; # Bridge sẽ nhận IP từ router
  # networking.interfaces.eno1.useDHCP = false; # Card mạng thật không cần IP nữa

  # systemd.sockets.libvirtd.socketConfig.TimeoutIdleSec = 0;

  # --- CẤU HÌNH MACVTAP CHO WI-FI (CÁCH TƯƠNG THÍCH) ---

  # 1. Khai báo để tạo file cấu hình mạng cho libvirt
  environment.etc."libvirt/qemu/networks/macvtap-bridge.xml".text = ''
    <network>
      <name>macvtap-bridge</name>
      <forward mode='bridge'>
        <interface dev='wlp0s20f3'/>
      </forward>
    </network>
  '';

  # 2. Yêu cầu libvirtd tự động khởi động mạng này khi nó chạy
  #    (Tương đương với lệnh `virsh net-autostart macvtap-bridge`)
  virtualisation.libvirtd.extraConfig = ''
    network_autostart_every_boot = 1
  '';
}