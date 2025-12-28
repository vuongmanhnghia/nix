{ config, pkgs, ... }:

{
  imports = [
    ./cpp-tools.nix   # C/C++ compilers, debuggers, and build tools
    ./python.nix
    ./golang.nix
    ./database.nix
    ./git.nix
    ./tools.nix
    ./networks.nix
    ./system.nix
    ./virtual.nix
    ./cloudflared.nix
  ];

  environment.systemPackages = with pkgs; [    
    # === MODERN CLI REPLACEMENTS ===
    ripgrep  # Fast text search tool (better grep replacement)
    fd       # Fast and user-friendly alternative to find
    bat      # Syntax-highlighted cat replacement
    eza      # Modern ls replacement with better formatting
    
    # === COMMAND LINE ENHANCEMENTS ===
    bash-completion   # Enhanced bash completion
    nix-bash-completions  # Nix-specific bash completions
    nix-index        # Fast file and package search for Nix
    comma            # Command-not-found handler for Nix
      
    # === ARCHIVE AND COMPRESSION TOOLS ===
    unzip    # Extract ZIP archives
    p7zip    # 7-Zip archive format support    

    (pkgs.callPackage ./coccoc.nix { })
  ];
}