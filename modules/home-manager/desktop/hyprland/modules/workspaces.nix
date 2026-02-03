# ██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗███████╗██████╗  █████╗  ██████╗███████╗███████╗
# ██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝
# ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ ███████╗██████╔╝███████║██║     █████╗  ███████╗
# ██║███╗██║██║   ██║██╔══██╗██╔═██╗ ╚════██║██╔═══╝ ██╔══██║██║     ██╔══╝  ╚════██║
# ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗███████║██║     ██║  ██║╚██████╗███████╗███████║
#  ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═════╝╚══════╝╚══════╝
#------------------------------------------------------------------------------------


{ config, lib, pkgs, hostVars, ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      workspace = [
        "1, monitor:${hostVars.port_name}"
        "2, monitor:${hostVars.port_name}"
        "3, monitor:${hostVars.port_name}"
        "4, monitor:${hostVars.port_name}"
        "5, monitor:${hostVars.port_name}"
        "6, monitor:${hostVars.port_name}"
        "7, monitor:${hostVars.port_name}"
        "8, monitor:${hostVars.port_name}"
        "9, monitor:${hostVars.port_name}"
        "10, monitor:${hostVars.port_name}"
      ];
    };
  };
}

