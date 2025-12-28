# ██╗███╗   ██╗██████╗ ██╗   ██╗████████╗
# ██║████╗  ██║██╔══██╗██║   ██║╚══██╔══╝
# ██║██╔██╗ ██║██████╔╝██║   ██║   ██║   
# ██║██║╚██╗██║██╔═══╝ ██║   ██║   ██║   
# ██║██║ ╚████║██║     ╚██████╔╝   ██║   
# ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝    ╚═╝   
#----------------------------------------


{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      input = {
        kb_layout = "us";
        numlock_by_default = true;
        repeat_delay = 250;
        repeat_rate = 35;
        sensitivity = 0; 

        follow_mouse = 1;
        off_window_axis_events = 2;

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
          scroll_factor = 0.5;
        };
      };

      binds = {
        scroll_event_delay = 0;
        hide_special_on_workspace_change = true;
      };

      cursor = {
        zoom_factor = 1;
        zoom_rigid = false;
      };

    };
  };
}


