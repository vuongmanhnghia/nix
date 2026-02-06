{ config, pkgs, ... }:

{
  imports = [
    ./general.nix
    ./autostart.nix
    ./colors.nix
    ./environment.nix
    ./input.nix
    ./keybinding.nix
    ./programs.nix
    ./tags.nix
    ./windowrule.nix
    ./workspaces.nix
  ];
}