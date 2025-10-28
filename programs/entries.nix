{ config, pkgs, ... }:

let
  chat2dbDesktopItem = pkgs.makeDesktopItem {
    name = "chat2db";
    desktopName = "Chat2DB";
    exec = "chat2db";
    icon = "chat2db";
    terminal = false;
    categories = [ "Development" "Database" ];
    startupWMClass = "chat2db";
  };
in
{
  environment.systemPackages = with pkgs; [
    chat2dbDesktopItem
  ];
}