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
    pkgs.unstable.brave # Web browser
  ];

  services.tumbler.enable = true;
}
