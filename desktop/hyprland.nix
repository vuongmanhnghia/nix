{ config, pkgs, lib, ... }:

{
  # Import modularized Hyprland configuration
  imports = [
    ./hyprland
  ];
}