{ config, pkgs, ... }:

let
  beekeeperStudioDesktopItem = pkgs.makeDesktopItem {
    name = "beekeeper-studio";
    desktopName = "Beekeeper Studio";
    exec = "beekeeper-studio";
    icon = "beekeeper-studio";
    terminal = false;
    categories = [ "Development" "Database" ];
    startupWMClass = "beekeeper-studio";
  };

  # warpTerminalLatestDesktopItem = pkgs.makeDesktopItem {
  #   name = "warp-terminal-latest";
  #   desktopName = "Warp Terminal Latest";
  #   exec = "warp-terminal-latest";
  #   icon = "warp-terminal";
  #   categories = [ "Development" "Terminal" ];
  #   startupWMClass = "warp-terminal-latest";
  # };
in
{
  environment.systemPackages = with pkgs; [
    beekeeperStudioDesktopItem
    # warpTerminalLatestDesktopItem
  ];
}