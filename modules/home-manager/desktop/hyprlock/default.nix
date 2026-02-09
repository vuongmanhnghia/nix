{
  config,
  lib,
  pkgs,
  hostVars,
  end-4-dots,
  ...
}:

let
  rawConfig = builtins.readFile "${end-4-dots}/dots/.config/hypr/hyprlock.conf";

  finalConfig =
    builtins.replaceStrings
      [
        "\${XDG_CONFIG_HOME:-$HOME/.config}"
        "color = rgba(181818FF)"
      ]
      [
        "${end-4-dots}/dots/.config"
        "path = $background_image\ncolor = rgba(181818FF)\nblur_passes = 2\nblur_size = 3\nnoise = 0.01\ncontrast = 0.8\nbrightness = 0.8\nvibrancy = 0.1\nvibrancy_darkness = 0.0"
      ]
      rawConfig;
in
{
  programs.hyprlock = {
    enable = true;

    extraConfig = ''
      ${finalConfig}
    '';

    settings = {
      background = [
        {
          path = "$background_image";
        }
      ];
    };
  };
}
