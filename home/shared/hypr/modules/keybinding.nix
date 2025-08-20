# ██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ██╗███╗   ██╗ ██████╗ 
# ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██║████╗  ██║██╔════╝ 
# █████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║██║██╔██╗ ██║██║  ███╗
# ██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║██║██║╚██╗██║██║   ██║
# ██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝██║██║ ╚████║╚██████╔╝
# ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
#-----------------------------------------------------------------------------


{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      "$mainMod" = "SUPER";
      "$altMod" = "ALT";
      "$shiftMod" = "SHIFT";
      "$controlMod" = "CTRL";

      bind = [
        # Toggle overview/launcher
        "Super, Super_L, exec, qs -c $qsConfig ipc call TEST_ALIVE || pkill fuzzel || fuzzel # [hidden] Launcher (fallback)"
        "Super, Super_R, exec, qs -c $qsConfig ipc call TEST_ALIVE || pkill fuzzel || fuzzel # [hidden] Launcher (fallback)"
        "Ctrl, Super_L, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "Ctrl, Super_R, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "Super, mouse:272, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "Super, mouse:273, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "Super, mouse:274, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "Super, mouse:275, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "Super, mouse:276, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "Super, mouse:277, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "Super, mouse_up, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "Super, mouse_down, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "Super+Alt, A, global, quickshell:sidebarLeftToggleDetach" # [hidden]
        "Super, B, global, quickshell:sidebarLeftToggle" # [hidden]
        "Super, O, global, quickshell:sidebarLeftToggle" # [hidden]
        "Ctrl+Alt, Delete, exec, qs -c $qsConfig ipc call TEST_ALIVE || pkill wlogout || wlogout -p layer-shell" # [hidden] Session menu (fallback)
        "Shift+Super+Alt, Slash, exec, qs -p ~/.config/quickshell/$qsConfig/welcome.qml" # [hidden] Launch welcome app
        "Ctrl+Super, R, exec, killall ags agsv1 gjs ydotool qs quickshell; qs -c $qsConfig &" # Restart widgets
        #/# bind = Super, ←/↑/→/↓,, # Focus in direction
        "Super, Left, movefocus, l" # [hidden]
        "Super, Right, movefocus, r" # [hidden]
        "Super, Up, movefocus, u" # [hidden]
        "Super, Down, movefocus, d" # [hidden]
        "Super, BracketLeft, movefocus, l" # [hidden]
        "Super, BracketRight, movefocus, r" # [hidden]
        #/# bind = Super+Shift, ←/↑/→/↓,, # Move in direction
        "Super+Shift, Left, movewindow, l" # [hidden]
        "Super+Shift, Right, movewindow, r" # [hidden]
        "Super+Shift, Up, movewindow, u" # [hidden]
        "Super+Shift, Down, movewindow, d" # [hidden]
        "Alt, F4, killactive, # [hidden] Close (Windows)"
        "Super, Q, killactive, # Close"
        "Super+Shift+Alt, Q, exec, hyprctl kill # Forcefully zap a window"
        # Positioning mode
        "Super+Alt, Space, togglefloating, # Float/Tile"
        "Super, D, fullscreen, 1 # Maximize"
        "Super, F, fullscreen, 0 # Fullscreen"
        "Super+Alt, F, fullscreenstate, 0 3 # Fullscreen spoof"
        "Super, P, pin # Pin"

        #/# bind = Super+Alt, Hash,, # Send to workspace # (1, 2, 3,...)
        "Super+Alt, 1, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 1" # [hidden]
        "Super+Alt, 2, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 2" # [hidden]
        "Super+Alt, 3, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 3" # [hidden]
        "Super+Alt, 4, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 4" # [hidden]
        "Super+Alt, 5, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 5" # [hidden]
        "Super+Alt, 6, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 6" # [hidden]
        "Super+Alt, 7, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 7" # [hidden]
        "Super+Alt, 8, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 8" # [hidden]
        "Super+Alt, 9, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 9" # [hidden]
        "Super+Alt, 0, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 10" # [hidden]

        #/#/# bind = Super+Shift, Scroll ↑/↓,, # Send to workspace left/right
        "Super+Shift, mouse_down, movetoworkspace, r-1" # [hidden]
        "Super+Shift, mouse_up, movetoworkspace, r+1" # [hidden]
        "Super+Alt, mouse_down, movetoworkspace, -1" # [hidden]
        "Super+Alt, mouse_up, movetoworkspace, +1" # [hidden]

        #/# bind = Super+Shift, Page_↑/↓,, # Send to workspace left/right
        "Super+Alt, Page_Down, movetoworkspace, +1" # [hidden]
        "Super+Alt, Page_Up, movetoworkspace, -1" # [hidden]
        "Super+Shift, Page_Down, movetoworkspace, r+1"  # [hidden]
        "Super+Shift, Page_Up, movetoworkspace, r-1"  # [hidden]
        "Ctrl+Super+Shift, Right, movetoworkspace, r+1" # [hidden]
        "Ctrl+Super+Shift, Left, movetoworkspace, r-1" # [hidden]

        "Super+Alt, S, movetoworkspacesilent, special" # Send to scratchpad

        "Ctrl+Super, S, togglespecialworkspace" # [hidden]
        "Alt, Tab, cyclenext" # [hidden] sus keybind
        "Alt, Tab, bringactivetotop" # [hidden] bring it to the top

        ##! Workspace
        # Switching
        #/# bind = Super, Hash,, # Focus workspace # (1, 2, 3,...)
        "Super, 1, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 1" # [hidden]
        "Super, 2, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 2" # [hidden]
        "Super, 3, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 3" # [hidden]
        "Super, 4, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 4" # [hidden]
        "Super, 5, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 5" # [hidden]
        "Super, 6, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 6" # [hidden]
        "Super, 7, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 7" # [hidden]
        "Super, 8, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 8" # [hidden]
        "Super, 9, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 9" # [hidden]
        "Super, 0, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 10" # [hidden]

        #/# bind = Ctrl+Super, ←/→,, # Focus left/right
        "Ctrl+Super, Right, workspace, r+1" # [hidden]
        "Ctrl+Super, Left, workspace, r-1" # [hidden]
        #/# bind = Ctrl+Super+Alt, ←/→,, # [hidden] Focus busy left/right
        "Ctrl+Super+Alt, Right, workspace, m+1" # [hidden]
        "Ctrl+Super+Alt, Left, workspace, m-1" # [hidden]
        #/# bind = Super, Page_↑/↓,, # Focus left/right
        "Super, Page_Down, workspace, +1" # [hidden]
        "Super, Page_Up, workspace, -1" # [hidden]
        "Ctrl+Super, Page_Down, workspace, r+1" # [hidden]
        "Ctrl+Super, Page_Up, workspace, r-1" # [hidden]
        #/# bind = Super, Scroll ↑/↓,, # Focus left/right
        "Super, mouse_up, workspace, +1" # [hidden]
        "Super, mouse_down, workspace, -1" # [hidden]
        "Ctrl+Super, mouse_up, workspace, r+1" # [hidden]
        "Ctrl+Super, mouse_down, workspace, r-1" # [hidden]
        ## Special
        "Super, S, togglespecialworkspace" # Toggle scratchpad
        "Super, mouse:275, togglespecialworkspace" # [hidden]
        "Ctrl+Super, BracketLeft, workspace, -1" # [hidden]
        "Ctrl+Super, BracketRight, workspace, +1" # [hidden]
        "Ctrl+Super, Up, workspace, r-5" # [hidden]
        "Ctrl+Super, Down, workspace, r+5" # [hidden]

        # #!
        # # Testing
        # "Super+Alt, f11, exec, bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | grep -v -i "nipple" | grep -v -i "pussy" | shuf -n 1); ACTION=$(notify-send "Test notification with body image" "This notification should contain your user account <b>image</b> and <a href=\"https://discord.com/app\">Discord</a> <b>icon</b>. Oh and here is a random image in your Pictures folder: <img src=\"$RANDOM_IMAGE\" alt=\"Testing image\"/>" -a "Hyprland keybind" -p -h "string:image-path:/var/lib/AccountsService/icons/$USER" -t 6000 -i "discord" -A "openImage=Open profile image" -A "action2=Open the random image" -A "action3=Useless button"); [[ $ACTION == *openImage ]] && xdg-open "/var/lib/AccountsService/icons/$USER"; [[ $ACTION == *action2 ]] && xdg-open \"$RANDOM_IMAGE\"' # [hidden]
        # "Super+Alt, f12, exec, bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | grep -v -i "nipple" | grep -v -i "pussy" | shuf -n 1); ACTION=$(notify-send "Test notification" "This notification should contain a random image in your <b>Pictures</b> folder and <a href=\"https://discord.com/app\">Discord</a> <b>icon</b>.\n<i>Flick right to dismiss!</i>" -a "Discord (fake)" -p -h "string:image-path:$RANDOM_IMAGE" -t 6000 -i "discord" -A "openImage=Open profile image" -A "action2=Useless button" -A "action3=Cry more"); [[ $ACTION == *openImage ]] && xdg-open "/var/lib/AccountsService/icons/$USER"; [[ $ACTION == *action2 ]] && xdg-open \"$RANDOM_IMAGE\"' # [hidden]
        # "Super+Alt, Equal, exec, notify-send "Urgent notification" "Ah hell no" -u critical -a 'Hyprland keybind' # [hidden]

        ##! Session
        "Super, L, Lock, exec, loginctl lock-session" # Lock
        "Super+Shift, L, exec, loginctl lock-session" # [hidden]
        "Super+Shift+Alt, mouse:275, exec, playerctl previous" # [hidden]
        "Super+Shift+Alt, mouse:276, exec, playerctl next || playerctl position \$(bc <<< \"100 * \$(playerctl metadata mpris:length) / 1000000 / 100\")" # [hidden]
        
        ##! Apps
        "Super, Return, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh \${TERMINAL} kitty -1 foot alacritty wezterm konsole kgx uxterm xterm" # Terminal
        "Super, T, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh \${TERMINAL} kitty -1 foot alacritty wezterm konsole kgx uxterm xterm" # [hidden] (terminal) (alt)
        "Ctrl+Alt, T, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh \${TERMINAL} kitty -1 foot alacritty wezterm konsole kgx uxterm xterm" # [hidden] (terminal) (for Ubuntu people)
        "Super, E, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh dolphin nautilus nemo thunar \${TERMINAL} \"kitty -1 fish -c yazi\"" # File manager
        "Super, W, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh google-chrome-stable zen-browser firefox brave chromium microsoft-edge-stable opera librewolf" # Browser
        "Super, C, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh code codium cursor zed zedit zeditor kate gnome-text-editor emacs \"command -v nvim && kitty -1 nvim\" \"command -v micro && kitty -1 micro\"" # Code editor
        "Super+Shift, W, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh wps onlyoffice-desktopeditors" # Office software
        "Super, X, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh kate gnome-text-editor emacs" # Text editor
        "Ctrl+Super, V, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh pavucontrol-qt pavucontrol" # Volume mixer
        "Super, I, exec, XDG_CURRENT_DESKTOP=gnome ~/.config/hypr/hyprland/scripts/launch_first_available.sh \"qs -p ~/.config/quickshell/\${qsConfig}/settings.qml\" systemsettings gnome-control-center better-control" # Settings app
        "Ctrl+Shift, Escape, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh gnome-system-monitor \"plasma-systemmonitor --page-name Processes\" \"command -v btop && kitty -1 fish -c btop\"" # Task manager
        # Cursed stuff
        # Make window not amogus large
        "Ctrl+Super, Backslash, resizeactive, exact 640 480" # [hidden]
      ];

      # Resize window
      binde = [
        "$mainMod SHIFT, h, resizeactive,-50 0"
        "$mainMod SHIFT, l, resizeactive,50 0"
        "$mainMod SHIFT, k, resizeactive,0 -50"
        "$mainMod SHIFT, j, resizeactive,0 50"
      ];

      # Move window
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/volume.sh --inc"
        ", XF86AudioLowerVolume, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/volume.sh --dec"
        ", XF86AudioMute, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/volume.sh --toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/brightness.sh --inc"
        ", XF86MonBrightnessDown, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/brightness.sh --dec"
      ];
    };
  };
}
