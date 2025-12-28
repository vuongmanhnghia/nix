{ config, pkgs, ... }:

{
  imports = [
    ./animation.nix
    ./appearance.nix
    ./autostart.nix
    ./colors.nix
    ./environment.nix
    ./input.nix
    ./keybinding.nix
    ./layout.nix
    ./misc.nix
    ./monitors.nix
    ./programs.nix
    ./tags.nix
    ./windowrule.nix
    ./workspaces.nix
    ./plugin.nix
  ];
}