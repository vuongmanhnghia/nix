{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # === TERMINAL MULTIPLEXER AND UTILITIES ===
    htop              # Interactive process viewer and system monitor
    glow              # Markdown renderer for the terminal
    ripgrep           # Fast text search tool (better grep replacement)
    fd                # Fast and user-friendly alternative to find
    bat               # Syntax-highlighted cat replacement
    bash-completion   # Enhanced bash completion
    delta             # Git diff viewer with syntax highlighting
    zoxide            # Smart, fast directory jumper
    highlight         # Universal syntax highlighter
    neofetch          # System information tool
    lshw              # Hardware information tool
    pciutils          # PCI utilities (lspci)
    usbutils          # USB utilities (lsusb)
    woeusb-ng         # USB device manager)
    coreutils         # Core utilities
    bc                # Arbitrary precision calculator language
    

    # === ARCHIVE AND COMPRESSION TOOLS ===
    zip                     # Create ZIP archives
    unzip                   # Extract ZIP archives
    p7zip                   # 7-Zip archive format support    
    gzip                    # Compress files
    unrar                   # Extract RAR archives

    # === DOWNLOAD AND FILE TRANSFER TOOLS ===
    axel                    # Fast download accelerator
    rsync                   # File synchronization
  ];

  home.shellAliases = {
    cat = "bat --paging=never";
  };
}