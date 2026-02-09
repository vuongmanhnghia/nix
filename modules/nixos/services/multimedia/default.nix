{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    libreoffice # Office suite
    evince # PDF viewer
    file-roller # Archive manager
  ];

  services.tumbler.enable = true;
}
