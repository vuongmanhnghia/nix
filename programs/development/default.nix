{ config, pkgs, ... }:

{
  imports = [
    ./cpp.nix
    ./python.nix
    ./golang.nix
    ./database.nix
    ./docker.nix
    ./git.nix
    ./tools.nix
    ./networks.nix
    ./system.nix
  ];

  environment.systemPackages = with pkgs; [
    # === UTILITIES ===
    curl     # Command-line tool for data transfer with URLs
    wget     # Network downloader for retrieving files from servers
    tree     # Display directory structures in tree format
    htop     # Interactive process viewer and system monitor
    
    # === MODERN CLI REPLACEMENTS ===
    ripgrep  # Fast text search tool (better grep replacement)
    fd       # Fast and user-friendly alternative to find
    bat      # Syntax-highlighted cat replacement
    eza      # Modern ls replacement with better formatting
    
    # === COMMAND LINE ENHANCEMENTS ===
    bash-completion   # Enhanced bash completion
    nix-bash-completions  # Nix-specific bash completions
    bash-preexec     # Preexec hooks for bash
    nix-index        # Fast file and package search for Nix
    comma            # Command-not-found handler for Nix
    blesh            # Bash Line Editor with syntax highlighting
    
    # === ADDITIONAL CLI TOOLS ===
    thefuck          # Command correction tool
    mcfly            # Neural command history search
    
    # === ARCHIVE AND COMPRESSION TOOLS ===
    unzip    # Extract ZIP archives
    p7zip    # 7-Zip archive format support    
  ];
}