{ config, pkgs, ... }:

let
  # chat2dbDesktopItem = pkgs.makeDesktopItem {
  #   name = "chat2db";
  #   desktopName = "Chat2DB";
  #   exec = "chat2db";
  #   icon = "chat2db";
  #   terminal = false;
  #   categories = [ "Development" "Database" ];
  #   startupWMClass = "chat2db";
  # };

  beekeeperStudioDesktopItem = pkgs.makeDesktopItem {
    name = "beekeeper-studio";
    desktopName = "Beekeeper Studio";
    exec = "beekeeper-studio";
    icon = "beekeeper-studio";
    terminal = false;
    categories = [ "Development" "Database" ];
    startupWMClass = "beekeeper-studio";
  };
in
{
  environment.systemPackages = with pkgs; [
    # chat2dbDesktopItem
    beekeeperStudioDesktopItem
  ];
}