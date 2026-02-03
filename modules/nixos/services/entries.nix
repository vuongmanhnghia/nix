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

  cisco-packet-tracerDesktopItem = pkgs.makeDesktopItem {
    name = "cisco-packet-tracer";
    desktopName = "Cisco Packet Tracer";
    exec = "cisco-packet-tracer";
    icon = "cisco-packet-tracer";
    terminal = false;
    categories = [ "Development" ];
    startupWMClass = "cisco-packet-tracer";
  };
in
{
  environment.systemPackages = with pkgs; [
    # beekeeperStudioDesktopItem
    # bongocatDesktopItem
    cisco-packet-tracerDesktopItem
  ];
}