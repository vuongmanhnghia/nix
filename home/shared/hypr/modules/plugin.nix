{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(000000)";
          workspace_method = "first 1"; # [center/first] [workspace] e.g. first 1 or center m+1

          enable_gesture = false; # laptop touchpad, 4 fingers
          gesture_distance = 300; # how far is the "max"
          gesture_positive = false;
        };
      };
    };
  };
}


