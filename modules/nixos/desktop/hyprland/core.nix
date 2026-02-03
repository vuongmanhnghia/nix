{ config, pkgs, lib, ... }:

{
  # Hyprland core configuration  
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Core system services
  security.polkit.enable = true;
  services.gvfs.enable = true;

  # Environment variables for Hyprland
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };
  
  # Add GCC 15 lib to LD_LIBRARY_PATH for GLIBCXX_3.4.34 (required by Hyprland 0.52.1)
  environment.sessionVariables.LD_LIBRARY_PATH = pkgs.lib.mkAfter [ "${pkgs.gcc15.cc.lib}/lib" ];

  # Essential core packages
  environment.systemPackages = with pkgs; [
    # Core window manager packages
    gcc15.cc.lib
    
    # Wrapper for Hyprland with correct LD_LIBRARY_PATH
    (pkgs.writeShellScriptBin "hyprland" ''
      export LD_LIBRARY_PATH="${pkgs.gcc15.cc.lib}/lib:$LD_LIBRARY_PATH"
      exec ${pkgs.hyprland}/bin/Hyprland "$@"
    '')
    
    # Essential Hyprland utilities
    hyprlock
    hyprpicker
    hyprcursor
    
    # Core applications
    kitty           # Terminal emulator
    nemo            # File manager
  ];
}
