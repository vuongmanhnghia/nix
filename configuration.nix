{ config, pkgs, inputs, vars, lib, ... }:

{
  # Import all configuration modules
  imports = [
    ./hardware-configuration.nix # Hardware configurations
    ./system                     # System-level configurations (boot, users, networking, etc.)
    ./desktop                    # Desktop environment configurations (GNOME, audio, graphics)
    ./programs                   # Application configurations (gaming, development, multimedia)
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    openssl
    glibc
    zlib
    libgcc
  ];
    
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # === AUDIO SYSTEM (CRITICAL) ===
  # sound.enable is deprecated - not needed anymore
  services.pulseaudio.enable = false;     # Disable PulseAudio (use PipeWire instead)
  
  # SSH configuration
  programs.ssh.startAgent = true; # Start SSH agent for key management

  # Disable nscd
  services.nscd.enable = false;

  # Sử dụng systemd-resolved thay thế
  services.resolved.enable = true;

  # Disable NSS modules để tránh conflict
  system.nssModules = lib.mkForce [];
    
  # Enable Nix flakes and new command syntax
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # System version - should match your NixOS release
  system.stateVersion = vars.nix_version;
}