{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qimgv               # Image viewer
    libreoffice         # Office suite
    evince              # PDF viewer
    file-roller         # Archive manager
  ];
}