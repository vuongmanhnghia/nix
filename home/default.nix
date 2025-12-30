{ config, pkgs, ... }:

{
  # === SHARED HOME MANAGER CONFIGURATIONS ===
  # Import common configurations used by all users
  imports = [
    ./shared/workflow.nix        # Workflow configuration
    ./shared/hypr/default.nix    # Hyprland configuration
    ./shared/matugen/default.nix # Matugen configuration
    ./shared/quickshell          # QuickShell configuration
    ./shared/git.nix             # Git version control configuration
    ./shared/zsh.nix             # Zsh shell with aliases and modern CLI tools
    ./shared/neovim.nix          # Neovim editor configuration with LSP
    ./shared/gtk-theme.nix       # GTK theme configuration (Phase 2)
    ./shared/kitty               # Kitty terminal configuration
    ./shared/fastfetch.nix       # Fastfetch configuration
    ./shared/ripgrep.nix         # Ripgrep configuration
    ./shared/wlogout/default.nix # Wlogout configuration
    ./shared/cursor.nix          # Cursor theme configuration
    ./shared/fuzzel.nix          # Fuzzel configuration
    ./shared/qt5ct.nix           # Qt5ct configuration
    ./shared/qt6ct.nix           # Qt6ct configuration
    ./shared/starship.nix        # Starship prompt configuration
    ./shared/fontconfig.nix      # Font configuration
    ./shared/xdg-portal.nix      # XDG desktop portal configuration
    ./shared/browser-flags.nix   # Browser optimization flags
    ./shared/mpv.nix             # MPV video player configuration
    ./shared/kde-theme.nix       # KDE theming configuration
    ./shared/kvantum.nix         # Kvantum Qt theming
    ./shared/kde-dialog.nix      # KDialog configuration
    ./shared/nemo.nix            # Nemo file manager configuration
    ./shared/tmux.nix            # Tmux configuration
  ];

  # === ESSENTIAL PACKAGES FOR ALL USERS ===
  home.packages = with pkgs; [
    # === DEVELOPMENT ESSENTIALS ===
    nodejs    # Node.js runtime
    yarn      # Alternative package manager for Node.js
    pnpm      # Alternative package manager for Node.js
    python3    # Python 3 interpreter for scripting and development
    
    # === MODERN TERMINAL UTILITIES ===
    ripgrep    # Fast text search tool (better grep replacement)
    fd         # Fast and user-friendly alternative to find
    eza        # Modern ls replacement with better formatting and colors
    bat        # Syntax-highlighted cat replacement with paging
    unzip      # Extract ZIP archives
    zip        # Create ZIP archives
    unrar      # Extract RAR archives
    
    # === SYSTEM MONITORING UTILITIES ===
    neofetch   # System information display tool with ASCII art
    nvtopPackages.nvidia      # NVIDIA GPU monitor
    
    # === WAYLAND CLIPBOARD UTILITIES ===
    wl-clipboard  # Wayland clipboard utilities (wl-copy, wl-paste)

    # Use GCC 15 lib for GLIBCXX_3.4.34 (required by Hyprland 0.52.1)
    # GCC 15 is backward compatible with GCC 14
    gcc15.cc.lib
  ];

  home.sessionVariables = {
    # GCC 15 lib path for GLIBCXX_3.4.34 support
    LD_LIBRARY_PATH = "${pkgs.gcc15.cc.lib}/lib:$LD_LIBRARY_PATH";
    
    # === NPM CONFIGURATION ===
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    NPM_CONFIG_CACHE = "${config.home.homeDirectory}/.npm-cache";
    NODE_PATH = "${config.home.homeDirectory}/.npm-global/lib/node_modules";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  programs.direnv = {
    enable = true;  # Enable direnv for environment variable management
  };

  # === SSH CONFIGURATION ===
  programs.ssh = {
    enable = true;  # Enable SSH client
    enableDefaultConfig = false;
    
    # SSH agent configuration for key management
    extraConfig = ''
      AddKeysToAgent yes  # Automatically add SSH keys to agent
      IdentityFile ~/.ssh/id_ed25519  # Default SSH key file
      Host *
        AddKeysToAgent yes  # Automatically add SSH keys to agent
    '';

    matchBlocks."*" = {
      forwardAgent = false;
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
      compression = true;
      user = "git";
      identitiesOnly = true;
    };
  };

  # === HOME MANAGER VERSION ===
  home.stateVersion = "25.11";  # Should match your NixOS release version
}
