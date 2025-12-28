{ config, pkgs, ... }:

let
  # beekeeperStudioDesktopItem = pkgs.makeDesktopItem {
  #   name = "beekeeper-studio";
  #   desktopName = "Beekeeper Studio";
  #   exec = "beekeeper-studio";
  #   icon = "beekeeper-studio";
  #   terminal = false;
  #   categories = [ "Development" "Database" ];
  #   startupWMClass = "beekeeper-studio";
  # };

  # bongocatDesktopItem = pkgs.makeDesktopItem {
  #   name = "bongocat";
  #   desktopName = "Bongo Cat";
  #   exec = "bongocat";
  #   icon = "bongocat";
  #   terminal = false;
  #   categories = [ "Development" ];
  #   startupWMClass = "bongocat";
  # };
in
{
  environment.systemPackages = with pkgs; [
    # beekeeperStudioDesktopItem
    # bongocatDesktopItem
  ];
}