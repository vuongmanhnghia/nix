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

      bind = [
        "ALT, SPACE, exec, $menu"

        # === QUICK SHELL ===
        "$mainMod, R, exec, pkill quickshell; qs -c $qsConfig &" # [hidden] Restart Quickshell
        "$mainMod, Super_L, exec, qs -c $qsConfig ipc call TEST_ALIVE || pkill fuzzel || fuzzel" # [hidden] Launcher (fallback)

        "Ctrl, Super_L, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "Ctrl, Super_R, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]

        "$mainMod, mouse:272, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "$mainMod, mouse:273, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "$mainMod, mouse:274, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "$mainMod, mouse:275, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "$mainMod, mouse:276, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "$mainMod, mouse:277, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]

        "$mainMod, mouse_up, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        "$mainMod, mouse_down, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
        
        "$mainMod ALT, A, global, quickshell:sidebarLeftToggleDetach" # [hidden]
        "$mainMod, A, global, quickshell:sidebarLeftToggle" # [hidden]
        "$mainMod, O, global, quickshell:sidebarLeftToggle" # [hidden]

        "Ctrl ALT, Delete, exec, qs -c $qsConfig ipc call TEST_ALIVE || pkill wlogout || wlogout -p layer-shell" # [hidden] Session menu (fallback)
        "SHIFT $mainMod ALT, Slash, exec, qs -p ~/.config/quickshell/$qsConfig/welcome.qml" # [hidden] Launch welcome app
        "Ctrl $mainMod, R, exec, killall ags agsv1 gjs ydotool qs quickshell; qs -c $qsConfig &" # Restart widgets

        # === WORKSPACE MANAGEMENT ===

        #/# bind = $mainMod, ←/↑/→/↓,, # Focus in direction
        "$mainMod, left, movefocus, l" 
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        #/# bind = $mainMod SHIFT, ←/↑/→/↓,, # Move in direction
        "$mainMod CTRL, left, movewindow, l"
        "$mainMod CTRL, right, movewindow, r"
        "$mainMod CTRL, up, movewindow, u"
        "$mainMod CTRL, down, movewindow, d"

        #/# bind = $mainMod, mouse_down/up, workspace, e+1/e-1 # Move to next/previous workspace
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        #/# bind = $mainMod, left/right, workspace, e-1/e+1 # Move to next/previous workspace
        "$mainMod, left, workspace, e-1"
        "$mainMod, right, workspace, e+1"

        #/# bind = Ctrl $mainMod, ←/→,, # Focus left/right
        "$mainMod CTRL, Right, workspace, r+1" # [hidden]
        "$mainMod CTRL, Left, workspace, r-1" # [hidden]

        #/# bind = $mainMod, h/l/k/j, workspace, e-1/e+1/e-1/e+1 # Move to next/previous workspace
        "$mainMod, h, workspace, r-1"
        "$mainMod, l, workspace, r+1"

        #/# bind = $mainMod, Hash,, # Focus workspace # (1, 2, 3,...)
        "$mainMod, 1, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 1" # [hidden]
        "$mainMod, 2, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 2" # [hidden]
        "$mainMod, 3, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 3" # [hidden]
        "$mainMod, 4, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 4" # [hidden]
        "$mainMod, 5, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 5" # [hidden]
        "$mainMod, 6, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 6" # [hidden]
        "$mainMod, 7, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 7" # [hidden]
        "$mainMod, 8, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 8" # [hidden]
        "$mainMod, 9, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 9" # [hidden]
        "$mainMod, 0, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 10" # [hidden]

        #/# bind = Ctrl $mainMod ALT, ←/→,, # [hidden] Focus busy left/right
        "$mainMod CTRL ALT, Right, workspace, m+1" # [hidden]
        "$mainMod CTRL ALT, Left, workspace, m-1" # [hidden]

        #/# bind = $mainMod, Page_↑/↓,, # Focus left/right
        "$mainMod, Page_Down, workspace, +1" # [hidden]
        "$mainMod, Page_Up, workspace, -1" # [hidden]
        "$mainMod CTRL, Page_Down, workspace, r+1" # [hidden]
        "$mainMod CTRL, Page_Up, workspace, r-1" # [hidden]

        #/# bind = $mainMod, Scroll ↑/↓,, # Focus left/right
        "$mainMod, mouse_up, workspace, +1" # [hidden]
        "$mainMod, mouse_down, workspace, -1" # [hidden]
        "$mainMod CTRL, mouse_up, workspace, r+1" # [hidden]
        "$mainMod CTRL, mouse_down, workspace, r-1" # [hidden]

        ## Special
        "$mainMod, S, togglespecialworkspace" # Toggle scratchpad
        "$mainMod, mouse:275, togglespecialworkspace" # [hidden]
        "$mainMod CTRL, BracketLeft, workspace, -1" # [hidden]
        "$mainMod CTRL, BracketRight, workspace, +1" # [hidden]

        #/# bind = Ctrl $mainMod, ↑/↓,, # Focus left/right
        "$mainMod CTRL, Up, workspace, r-5" # [hidden]
        "$mainMod CTRL, Down, workspace, r+5" # [hidden]

        #/# bind = $mainMod ALT, Hash,, # Send to workspace # (1, 2, 3,...)
        "$mainMod SHIFT, 1, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspace 1" # [hidden] or movetoworkspacesilent
        "$mainMod SHIFT, 2, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspace 2" # [hidden] or movetoworkspacesilent
        "$mainMod SHIFT, 3, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspace 3" # [hidden] or movetoworkspacesilent
        "$mainMod SHIFT, 4, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspace 4" # [hidden] or movetoworkspacesilent
        "$mainMod SHIFT, 5, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspace 5" # [hidden] or movetoworkspacesilent
        "$mainMod SHIFT, 6, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspace 6" # [hidden] or movetoworkspacesilent
        "$mainMod SHIFT, 7, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspace 7" # [hidden] or movetoworkspacesilent
        "$mainMod SHIFT, 8, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspace 8" # [hidden] or movetoworkspacesilent
        "$mainMod SHIFT, 9, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspace 9" # [hidden] or movetoworkspacesilent
        "$mainMod SHIFT, 0, exec, ~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspace 10" # [hidden] or movetoworkspacesilent

        #/#/# bind = $mainMod SHIFT, Scroll ↑/↓,, # Send to workspace left/right
        "$mainMod SHIFT, mouse_down, movetoworkspace, r-1" # [hidden]
        "$mainMod SHIFT, mouse_up, movetoworkspace, r+1" # [hidden]
        "$mainMod ALT, mouse_down, movetoworkspace, -1" # [hidden]
        "$mainMod ALT, mouse_up, movetoworkspace, +1" # [hidden]

        #/# bind = $mainMod SHIFT, Page_↑/↓,, # Send to workspace left/right
        "$mainMod ALT, Page_Down, movetoworkspace, +1" # [hidden]
        "$mainMod ALT, Page_Up, movetoworkspace, -1" # [hidden]
        "$mainMod SHIFT, Page_Down, movetoworkspace, r+1"  # [hidden]
        "$mainMod SHIFT, Page_Up, movetoworkspace, r-1"  # [hidden]
        "Ctrl $mainMod SHIFT, Right, movetoworkspace, r+1" # [hidden]
        "Ctrl $mainMod SHIFT, Left, movetoworkspace, r-1" # [hidden]
        
        # === WINDOW MANAGEMENT ===
        "ALT, F4, killactive" # [hidden] Close (Windows)
        "$mainMod, Q, killactive" # Close
        "$mainMod SHIFT, Q, exec, hyprctl kill" # Forcefully zap a window
        # Positioning mode
        "$mainMod ALT, SPACE, togglefloating" # Float/Tile
        "$mainMod, F, fullscreen, 0" # Fullscreen
        "$mainMod SHIFT, F, fullscreen, +1" # Maximize
        "$mainMod ALT, F, fullscreenstate, 0 3" # Fullscreen spoof
        "$mainMod, P, pin" # Pin 

        "$mainMod ALT, S, movetoworkspacesilent, special" # Send to scratchpad

        "$mainMod SHIFT, S, togglespecialworkspace" # [hidden]
        "ALT, Tab, cyclenext" # [hidden] sus keybind
        "ALT, Tab, bringactivetotop" # [hidden] bring it to the top

        # #!
        # # Testing
        # "$mainMod ALT, f11, exec, bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | grep -v -i "nipple" | grep -v -i "pussy" | shuf -n 1); ACTION=$(notify-send "Test notification with body image" "This notification should contain your user account <b>image</b> and <a href=\"https://discord.com/app\">Discord</a> <b>icon</b>. Oh and here is a random image in your Pictures folder: <img src=\"$RANDOM_IMAGE\" alt=\"Testing image\"/>" -a "Hyprland keybind" -p -h "string:image-path:/var/lib/AccountsService/icons/$USER" -t 6000 -i "discord" -A "openImage=Open profile image" -A "action2=Open the random image" -A "action3=Useless button"); [[ $ACTION == *openImage ]] && xdg-open "/var/lib/AccountsService/icons/$USER"; [[ $ACTION == *action2 ]] && xdg-open \"$RANDOM_IMAGE\"' # [hidden]
        # "$mainMod ALT, f12, exec, bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | grep -v -i "nipple" | grep -v -i "pussy" | shuf -n 1); ACTION=$(notify-send "Test notification" "This notification should contain a random image in your <b>Pictures</b> folder and <a href=\"https://discord.com/app\">Discord</a> <b>icon</b>.\n<i>Flick right to dismiss!</i>" -a "Discord (fake)" -p -h "string:image-path:$RANDOM_IMAGE" -t 6000 -i "discord" -A "openImage=Open profile image" -A "action2=Useless button" -A "action3=Cry more"); [[ $ACTION == *openImage ]] && xdg-open "/var/lib/AccountsService/icons/$USER"; [[ $ACTION == *action2 ]] && xdg-open \"$RANDOM_IMAGE\"' # [hidden]
        # "$mainMod ALT, Equal, exec, notify-send "Urgent notification" "Ah hell no" -u critical -a 'Hyprland keybind' # [hidden]

        ##! Session
        "$mainMod, Backspace, exec, loginctl lock-session" # Lock
        "$mainMod SHIFT, Backspace, exec, loginctl lock-session" # [hidden]
        "$mainMod SHIFT ALT, mouse:275, exec, playerctl previous" # [hidden]
        "$mainMod SHIFT ALT, mouse:276, exec, playerctl next || playerctl position \$(bc <<< \"100 * \$(playerctl metadata mpris:length) / 1000000 / 100\")" # [hidden]
        
        ##! Apps
        "$mainMod, SPACE, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh $terminal kitty -1 foot alacritty wezterm konsole kgx uxterm xterm" # [hidden] (terminal) (alt)
        "$mainMod, D, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh discord" # [hidden] (discord) (alt)
        "$mainMod, C, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh $codeEditor" # [hidden] (code editor) (alt)
        "$mainMod, E, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh $fileManager dolphin nautilus nemo thunar" # [hidden] (file manager) (alt)
        "$mainMod, B, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh $browser google-chrome-stable zen-browser firefox brave chromium microsoft-edge-stable opera librewolf" # [hidden] (browser) (alt)
        
        "$mainMod SHIFT, W, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh wps onlyoffice-desktopeditors" # Office software
        "$mainMod, X, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh kate gnome-text-editor emacs" # Text editor
        "Ctrl $mainMod, V, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh pavucontrol-qt pavucontrol" # Volume mixer

        # Cursed stuff
        # Make window not amogus large
        "$mainMod CTRL, Backslash, resizeactive, exact 640 480" # [hidden]
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
