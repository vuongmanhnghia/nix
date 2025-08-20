{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vlc
    gimp
    libreoffice
    evince
    file-roller
    mpv
  ];
}