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

      gestures = {
        workspace_swipe = true;
        workspace_swipe_distance = 700;
        workspace_swipe_fingers = 3;
        workspace_swipe_min_fingers = true;
        workspace_swipe_cancel_ratio = 0.2;
        workspace_swipe_min_speed_to_force = 5;
        workspace_swipe_direction_lock = true;
        workspace_swipe_direction_lock_threshold = 10;
        workspace_swipe_create_new = true;
      };

    };
  };
}


