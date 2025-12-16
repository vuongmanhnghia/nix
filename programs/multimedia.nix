{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mpv                 # Versatile media player
    libreoffice         # Office suite
    evince              # PDF viewer
    file-roller         # Archive manager
  ];
}