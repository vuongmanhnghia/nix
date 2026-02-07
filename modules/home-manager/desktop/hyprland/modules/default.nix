{ config, pkgs, ... }:

{
  imports = [
    ./general.nix
    ./autostart.nix
    ./colors.nix
    ./environment.nix
    ./keybinding.nix
    ./programs.nix
    ./windowrule.nix
    ./workspaces.nix
  ];
}