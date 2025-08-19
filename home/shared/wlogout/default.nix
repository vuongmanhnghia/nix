# home/shared/wlogout.nix - Advanced wlogout configuration
{ config, pkgs, lib, ... }:

{
  # Tạo file layout với format đúng cho wlogout
  xdg.configFile."wlogout/layout".text = ''
    {
        "label" : "lock",
        "action" : "loginctl lock-session",
        "text" : "Lock",
        "keybind" : "l"
    }
    {
        "label" : "hibernate",
        "action" : "systemctl hibernate || loginctl hibernate",
        "text" : "Hibernate",
        "keybind" : "h"
    }
    {
        "label" : "logout",
        "action" : "hyprctl clients -j | jq -r '.[].pid' | xargs kill; pkill Hyprland || pkill sway || pkill niri || loginctl terminate-user $USER",
        "text" : "Logout",
        "keybind" : "e"
    }
    {
        "label" : "shutdown",
        "action" : "hyprctl clients -j | jq -r '.[].pid' | xargs kill; systemctl poweroff || loginctl poweroff",
        "text" : "Shutdown",
        "keybind" : "s"
    }
    {
        "label" : "suspend",
        "action" : "systemctl suspend || loginctl suspend",
        "text" : "Suspend",
        "keybind" : "u"
    }
    {
        "label" : "reboot",
        "action" : "hyprctl clients -j | jq -r '.[].pid' | xargs kill; systemctl reboot || loginctl reboot",
        "text" : "Reboot",
        "keybind" : "r"
    }
  '';

  # CSS styling với sử dụng system icons
  xdg.configFile."wlogout/style.css".text = ''
    * {
    
        all: unset;
        background-image: none;
        font-size: 16px;
        transition: 400ms cubic-bezier(0.05, 0.7, 0.1, 1);
    }

    window {
        background: rgba(0, 0, 0, 0.5);
    }

    button {
        font-family: 'Material Symbols Outlined';
        font-size: 10rem;
        background-color: rgba(11, 11, 11, 0.4);
        color: #FFFFFF;
        margin: 2rem;
        border-radius: 2rem;
        padding: 3rem;
    }

    button:focus,
    button:active,
    button:hover {
        background-color: rgba(51, 51, 51, 0.5);
        border-radius: 4rem;
    }
  '';

  # Shell aliases
  home.shellAliases = {
    logout-menu = "wlogout";
    wl = "wlogout";
  };

  # Session variables (tùy chọn)
  home.sessionVariables = {
    WLOGOUT_STYLE = "${config.xdg.configHome}/wlogout/style.css";
  };
}