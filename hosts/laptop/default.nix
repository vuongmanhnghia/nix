{ config, pkgs, inputs, hostVars, lib, ... }:

{
  system.stateVersion = hostVars.nix_version;

  imports = [
    ./hardware-configuration.nix # Hardware configurations
    ../common
  ];
}