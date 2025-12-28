{ config, pkgs, ... }:

{
  # === BLUETOOTH CONFIGURATION ===

  # Enable Bluetooth support
  hardware.bluetooth = {
    enable = true;                  # Bật dịch vụ Bluetooth
    powerOnBoot = true;             # Bật Bluetooth khi khởi động hệ thống
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket"; # Bật các profile Bluetooth phổ biến
        Experimental = true;                # Bật tính năng thử nghiệm
        KernelExperimental = true;         # Bật các tính năng kernel mới
      };
    };
  };

  # Enable blueman applet for Bluetooth management
  services.blueman.enable = true;

  # Install Bluetooth utilities
  environment.systemPackages = with pkgs; [
    bluez          # Core Bluetooth stack
    bluez-tools    # Command line tools for Bluetooth
  ];
} 