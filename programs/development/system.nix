{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # === SYSTEM INFORMATION TOOLS ===
    neofetch  # System information display tool
    lshw      # List hardware information
    pciutils  # PCI bus utilities (lspci)
    usbutils  # USB utilities (lsusb)
  ];
}