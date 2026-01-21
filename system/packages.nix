{ config, pkgs, ... }:

{
  # Essential system packages only - development tools moved to programs/development/
  environment.systemPackages = with pkgs; [
    # === NETWORK UTILITIES ===
    curl     # Command-line tool for data transfer with URLs
    wget     # Network downloader for retrieving files from web servers
    
    # === REMOTE ACCESS ===
    openssh  # Secure Shell for remote login and command execution
    
    # === SYSTEM MONITORING ===
    htop     # Interactive process viewer and system monitor
    
    # === SYSTEM UTILITIES ===
    file          # File type identification utility
    which         # Locate command binary in PATH
    tree          # Display directory structure in tree format
    fzf           # Fuzzy finder for command-line
    wl-clipboard  # Clipboard manager for Wayland
  ];
  
  # Allow installation of proprietary software (required for some development tools)
  nixpkgs.config.allowUnfree = true;
} 