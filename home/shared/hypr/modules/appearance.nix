#  █████╗ ██████╗ ██████╗ ███████╗ █████╗ ██████╗  █████╗ ███╗   ██╗ ██████╗███████╗ 
# ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗████╗  ██║██╔════╝██╔════╝     
# ███████║██████╔╝██████╔╝█████╗  ███████║██████╔╝███████║██╔██╗ ██║██║     █████╗     
# ██╔══██║██╔═══╝ ██╔═══╝ ██╔══╝  ██╔══██║██╔══██╗██╔══██║██║╚██╗██║██║     ██╔══╝   
# ██║  ██║██║     ██║     ███████╗██║  ██║██║  ██║██║  ██║██║ ╚████║╚██████╗███████╗   
# ╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝  
#-----------------------------------------------------------------------------------


{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      general = {
        gaps_in = 3;
        gaps_out = 3;
        gaps_workspaces = 50;

        border_size = 1;
        
        "col.active_border" = "$outline";
        "col.inactive_border" = "$outline_variant";

        resize_on_border = true;
        no_focus_fallback = true;
        allow_tearing = false;

        snap = {
          enabled = true;
        };
      };

      decoration = {
        rounding = 18;
        # rounding_power = 2;
        
        # active_opacity = 1.0;
        # inactive_opacity = 0.8;

        # shadow = {
        #   enabled = true;
        #   range = 4;
        #   render_power = 3;
        #   color = "rgba(1a1a1aee)";
        # };

        blur = {
          enabled = true;
          xray = true;
          special = false;
          new_optimizations = true;
          size = 14;
          passes = 3;
          brightness = 1;
          noise = 0.01;
          contrast = 1;
          popups = true;
          popups_ignorealpha = 0.6;
          input_methods = true;
          input_methods_ignorealpha = 0.8;
        };

        shadow = {
          enabled = true;
          ignore_window = true;
          range = 30;
          offset = "0 2";
          render_power = 4;
          color = "rgba(00000010)";
        };

        # Dim
        dim_inactive = true;
        dim_strength = 0.025;
        dim_special = 0.07;
      };
    };
  };
}


