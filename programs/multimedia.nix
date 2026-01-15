{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    logseq              # Knowledge management and collaboration platform
    mpv                 # Versatile media player
    libreoffice         # Office suite
    evince              # PDF viewer
    file-roller         # Archive manager
    teams-for-linux     # Microsoft Teams client
    drawio              # Diagramming application
    # lorien              # A modern, feature-rich note-taking app
  ];
}