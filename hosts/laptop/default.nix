{ hostVars, ... }:

{
  system.stateVersion = hostVars.nix_version;

  imports = [
    ./hardware-configuration.nix # Hardware configurations
    ../common
  ];
}