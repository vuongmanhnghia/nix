#  ██████╗ ███████╗███╗   ██╗███████╗██████╗  █████╗ ██╗
# ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔══██╗██╔══██╗██║
# ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ██████╔╝███████║██║
# ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ██╔══██╗██╔══██║██║
# ╚██████╔╝███████╗██║ ╚████║███████╗██║  ██║██║  ██║███████╗
#  ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
#------------------------------------------------------------

{
  config,
  lib,
  pkgs,
  hostVars,
  end-4-dots,
  ...
}:

let
  rawConfig = builtins.readFile "${end-4-dots}/dots/.config/hypr/hyprland/general.conf";

  keysToRemove = [
    "on_focus_under_fullscreen"
    "vfr"
    "vrr"
  ];

  processConfig =
    content:
    let
      lines = lib.splitString "\n" content;

      shouldKeep = line: !(lib.any (key: lib.strings.hasInfix key line) keysToRemove);

      filteredLines = builtins.filter shouldKeep lines;
    in
    lib.concatStringsSep "\n" filteredLines;

  finalConfig = processConfig rawConfig;
in
{
  wayland.windowManager.hyprland = {
    settings = {
      misc = {
        vfr = 0;
        vrr = 2;
      };
    };
    extraConfig = ''
      ${finalConfig}
    '';
  };
}
