{ config, lib, pkgs, ... }:

let
  lock_cmd = "hyprctl dispatch global quickshell:lock & pidof qs quickshell hyprlock || hyprlock";
  suspend_cmd = "systemctl suspend || loginctl suspend";
in
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${lock_cmd}";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch global quickshell:lockFocus";
        inhibit_sleep = 3;
      };

      listener = [
        # === LOCKSCREEN ===
        {
          timeout = 300;                                # 5min
          on-timeout = "loginctl lock-session";         # lock screen when timeout has passed
        }

        # === TURN OFF SCREEN ===
        {
          timeout = 600;                                                      # 5.5min
          on-timeout = "hyprctl dispatch dpms off";                          # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on";        # screen on when activity is detected after timeout has fired.
        }

        # === SUSPEND ===
        {
          timeout = 900;                               # 30min
          on-timeout = "${suspend_cmd}";             # suspend pc
        }
        
        # === MONITOR DIM ===
        {
          timeout = 300;                                # 5min.
          on-timeout = "brightnessctl -s set 10";       # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r";               # monitor backlight restore.
        }
      ];
    };
  };
}