{ config, pkgs, unstable, hostVars, ... }:

{
  # === STEAM GAMING PLATFORM ===
  programs.steam = {
    enable = true;                    # Enable Steam gaming platform
    remotePlay.openFirewall = true;   # Allow Steam Remote Play through firewall
    gamescopeSession.enable = true;   # Enable Gamescope compositor session for Steam Deck-like experience
  };
  
  # === GAMING PERFORMANCE OPTIMIZATION ===
  programs.gamemode.enable = true;    # Enable GameMode for automatic CPU/GPU optimization during gaming

  # === GAMING SOFTWARE PACKAGES ===
  environment.systemPackages = with pkgs; [
    unstable.steam                # Steam gaming platform
    unstable.protonup-qt          # GUI tool for managing Proton versions (Steam's Wine fork)
    unstable.steam-run            # Utility for running non-Steam applications with Steam's runtime
    # winePackages.stable         # Stable Wine version for running Windows games/applications
    winetricks                    # Script to install Windows components in Wine prefixes
    wineWowPackages.waylandFull   # Wine version with Wayland support
    # lutris                      # Open-source gaming platform for managing and launching games
  ];
  
  # === GAMING CONTROLLER SUPPORT ===
  # udev rules for proper controller recognition and permissions
  services.udev.extraRules = ''
    # PlayStation 4/5 Controllers - DualShock 4 and DualSense support
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", MODE="0664", GROUP="wheel"
    
    # Xbox Controllers - Xbox One and Series X/S controller support
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", MODE="0664", GROUP="wheel"
    
    # Nintendo Switch Pro Controller support
    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0664", GROUP="wheel"
  '';

  # === USER PERMISSIONS ===
  users.users.${hostVars.user.username}.extraGroups = [ "gamemode" ];
} 