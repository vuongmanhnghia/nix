{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qimgv               # Image viewer
    logseq              # Knowledge management and collaboration platform
    libreoffice         # Office suite
    evince              # PDF viewer
    file-roller         # Archive manager
    teams-for-linux     # Microsoft Teams client
    drawio              # Diagramming application
    # lorien              # A modern, feature-rich note-taking app
  ];
}