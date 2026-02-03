{ config, pkgs, inputs, hostVars, lib, ... }:

{
  system.stateVersion = hostVars.nix_version;

  imports = [
    ../../modules/nixos/hardware                   # Hardware configurations (Bluetooth, Boot, Nvidia, etc.)
    ../../modules/nixos/desktop                    # Desktop environment configurations (Hyprland core, audio, fonts, etc.)
    ../../modules/nixos/services                   # Services configurations (Cloudflared, Docker, etc.)
  ];
}