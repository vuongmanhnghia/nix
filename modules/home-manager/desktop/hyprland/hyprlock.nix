{ config, lib, pkgs, hostVars, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      source = "/home/${hostVars.user.username}/.config/hypr/hyprlock/colors.conf";

      general = {
        grace = 1;
        fractional_scaling = 2;
        immediate_render = true;
      };

      background = [
        {
          color = "rgba(181818FF)"; # color will be rendered initially until path is available
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 2;

          dots_size = 0.1; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.3; # Scale of dots' absolute size, 0.0 - 1.0

          outer_color = "$entry_border_color";
          inner_color = "$entry_background_color";
          font_color = "$entry_color";

          fade_on_empty = true;

          position = "0, 20";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$LAYOUT";
          color = "$text_color";
          font_size = 14;
          font_family = "$font_family";
          position = "-30, 30";
          halign = "right";
          valign = "bottom";
        }

        { # Caps Lock Warning
          monitor = "";
          text = "cmd[update:250] ${hostVars.nix_config}/home/shared/hypr/scripts/hyprlock/check-capslock.sh";
          color = "$text_color";
          font_size = 13;
          font_family = "$font_family";
          position = "0, -25";
          halign = "center";
          valign = "center";
        }

        { # Date
          monitor = "";
          text = "cmd[update:5000] date +\"%A, %B %d\"";
          color = "$text_color";
          font_size = 17;
          font_family = "$font_family_clock";

          position = "0, 240";
          halign = "center";
          valign = "center";
        }

        { # User
          monitor = "";
          text = "    $USER";
          color = "$text_color";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          font_size = 20;
          font_family = "$font_family";
          position = "0, 50";
          halign = "center";
          valign = "bottom";
        }

        { # Status
          monitor = "";
          text = "cmd[update:5000] ${hostVars.nix_config}/home/shared/hypr/scripts/hyprlock/status.sh";
          color = "$text_color";
          font_size = 14;
          font_family = "$font_family";

          position = "30, -30";
          halign = "left";
          valign = "top";
        }
      ];
    };
  };
}