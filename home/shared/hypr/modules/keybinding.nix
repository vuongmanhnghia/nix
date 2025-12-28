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

      # bindid = [
      #   "$mainMod, Super_L, Toggle overview, global, quickshell:overviewToggleRelease" # Toggle overview/launcher
      #   "$mainMod, Super_R, Toggle overview, global, quickshell:overviewToggleRelease" # [hidden] Toggle overview/launcher
      # ];

      # binditn = [
      #   "$mainMod, catchall, global, quickshell:overviewToggleReleaseInterrupt" # [hidden]
      # ];

      # bindit = [
      #   "$mainMod, Super_L, global, quickshell:workspaceNumber" # [hidden]
      #   "$mainMod, Super_R, global, quickshell:workspaceNumber" # [hidden]
      # ];

      bindd = [
        "$mainMod, V, Clipboard history >> clipboard, global, quickshell:overviewClipboardToggle" # Clipboard history >> clipboard
        "$mainMod, Period, Emoji >> clipboard, global, quickshell:overviewEmojiToggle" # Emoji >> clipboard
        # "$mainMod, Tab, Toggle overview, global, quickshell:overviewToggle" # [hidden] Toggle overview/launcher (alt)
        "$mainMod, Tab, Toggle overview, global, quickshell:overviewToggle" # [hidden] Toggle overview/launcher (alt)
        # "$mainMod, A, Toggle left sidebar, global, quickshell:sidebarLeftToggle" # Toggle left sidebar
        # "$mainMod, N, Toggle right sidebar, global, quickshell:sidebarRightToggle" # Toggle right sidebar
        "$mainMod, Slash, Toggle cheatsheet, global, quickshell:cheatsheetToggle" # Toggle cheatsheet
        # "$mainMod, K, Toggle on-screen keyboard, global, quickshell:oskToggle" # Toggle on-screen keyboard
        # "$mainMod SHIFT, M, Toggle media controls, global, quickshell:mediaControlsToggle" # Toggle media controls
        "$mainMod CTRL ALT, Delete, Toggle session menu, global, quickshell:sessionToggle" # Toggle session menu
        "$mainMod SHIFT, H, Toggle bar, global, quickshell:barToggle" # Toggle bar
        "$mainMod CTRL, T, Change wallpaper, exec, ~/.config/quickshell/$qsConfig/scripts/colors/switchwall.sh" # Change wallpaper
        "$mainMod, V, Copy clipboard history entry, exec, qs -c $qsConfig ipc call TEST_ALIVE || pkill fuzzel || cliphist list | fuzzel --match-mode fzf --dmenu | cliphist decode | wl-copy" # [hidden]
        "$mainMod, Period, Copy an emoji, exec, qs -c $qsConfig ipc call TEST_ALIVE || pkill fuzzel || ~/.config/hypr/hyprland/scripts/fuzzel-emoji.sh copy" # [hidden] Emoji >> clipboard (fallback)
        "$mainMod SHIFT, S, Screen snip, exec, qs -p ~/.config/quickshell/$qsConfig/screenshot.qml || pidof slurp || hyprshot --freeze --clipboard-only --mode region --silent" # Screen snip
        "$mainMod SHIFT, T, Character recognition,exec,grim -g \$(slurp $SLURP_ARGS) tmp.png && tesseract tmp.png - | wl-copy && rm tmp.png" # [hidden]
        "$mainMod SHIFT, C, Color picker, exec, hyprpicker -a" # Pick color (Hex) >> clipboard
        "$mainMod Alt, R, Record region (no sound), exec, ~/.config/hypr/hyprland/scripts/record.sh" # Record region (no sound)
        "Ctrl Alt, R, Record screen (no sound), exec, ~/.config/hypr/hyprland/scripts/record.sh --fullscreen" # [hidden] Record screen (no sound)
        "$mainMod SHIFT Alt, R, Record screen (with sound), exec, ~/.config/hypr/hyprland/scripts/record.sh --fullscreen-sound" # Record screen (with sound)
        # AI
        "$mainMod SHIFT Alt, mouse:273, Generate AI summary for selected text, exec, ~/.config/hypr/hyprland/scripts/ai/primary-buffer-query.sh" # AI summary for selected text
      ];

      bindle = [
        "$mainMod, XF86MonBrightnessUp, exec, qs -c $qsConfig ipc call brightness increment || brightnessctl s 5% " # [hidden]
        "$mainMod, XF86MonBrightnessDown, exec, qs -c $qsConfig ipc call brightness decrement || brightnessctl s 5%-" # [hidden]
      ];

      bindld = [
        ",Print, Screenshot >> clipboard ,exec,grim - | wl-copy" # Screenshot >> clipboard
        "Ctrl,Print, Screenshot >> clipboard & save, exec, mkdir -p \$(xdg-user-dir PICTURES)/Screenshots && grim \$(xdg-user-dir PICTURES)/Screenshots/Screenshot_\$(date ' %Y-%m-%d_%H.%M.%S').png" # Screenshot >> clipboard & file
      ];

      bindl = [
        "$mainMod SHIFT, M, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/volume.sh --toggle" # Toggle mute speakers
        "$mainMod, M, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/volume.sh --toggle-mic" # Toggle mute mic
        ",XF86AudioMute, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/volume.sh --toggle" # [hidden]
        "Alt ,XF86AudioMute, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/volume.sh --toggle-mic" # [hidden]
        ",XF86AudioMicMute, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/volume.sh --toggle-mic" # [hidden]
        "$mainMod SHIFT, N, exec, playerctl next || playerctl position bc <<< 100 * \$(playerctl metadata mpris:length) / 1000000 / 100" # Next track
        ",XF86AudioNext, exec, playerctl next || playerctl position bc <<< 100 * \$(playerctl metadata mpris:length) / 1000000 / 100" # [hidden]
        ",XF86AudioPrev, exec, playerctl previous" # [hidden]
        "$mainMod SHIFT, B, exec, playerctl previous" # Previous track
        "$mainMod SHIFT, P, exec, playerctl play-pause" # Play/pause media
        ",XF86AudioPlay, exec, playerctl play-pause" # [hidden]
        ",XF86AudioPause, exec, playerctl play-pause" # [hidden]
      ];

      # Move window
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
        "$mainMod, mouse:274, movewindow" # [hidden]"
      ];

      bind = [
        # === QUICK SHELL ===
        "$mainMod, R, exec, pkill quickshell; qs -c $qsConfig &" # [hidden] Restart Quickshell
        # "ALT, SPACE, exec, ~/Workspaces/Config/nixos/scripts/fuzzel/fuzzel.sh" # [hidden] Launcher (fallback)
        
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

        # === VOLUME ===
        # Note: Mic mute ($mainMod, M) is in bindl section
        "$mainMod SHIFT, up, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/volume.sh --mic-inc"
        "$mainMod SHIFT, down, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/volume.sh --mic-dec"
        
        "$mainMod, up, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/volume.sh --inc"
        "$mainMod, down, exec, ~/Workspaces/Config/nixos/home/shared/hypr/scripts/volume.sh --dec"

        # === WORKSPACE MANAGEMENT ===

        #/# bind = $mainMod, ←/↑/→/↓,, # Focus in direction
        "$mainMod, left, movefocus, l" 
        "$mainMod, right, movefocus, r"

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

        ##! Session
        "$mainMod, Backspace, exec, loginctl lock-session" # Lock
        "$mainMod SHIFT, Backspace, exec, loginctl lock-session" # [hidden]
        "$mainMod SHIFT ALT, mouse:275, exec, playerctl previous" # [hidden]
        "$mainMod SHIFT ALT, mouse:276, exec, playerctl next || playerctl position \$(bc <<< \"100 * \$(playerctl metadata mpris:length) / 1000000 / 100\")" # [hidden]
        
        ##! Apps
        "$mainMod, SPACE, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh $terminal kitty -1 foot alacritty wezterm konsole kgx uxterm xterm" # [hidden] (terminal) (alt)
        "$mainMod, D, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh discord" # [hidden] (discord) (alt)
        # "$mainMod, C, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh $codeEditor" # [hidden] (code editor) (alt)
        "$mainMod, C, exec, $codeEditor" # [hidden] (code editor) (alt)
        "$mainMod, E, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh $fileManager dolphin nautilus nemo thunar" # [hidden] (file manager) (alt)
        "$mainMod, B, exec, ~/.config/hypr/hyprland/scripts/launch_first_available.sh $browser google-chrome-stable zen-browser brave firefox chromium microsoft-edge-stable opera librewolf" # [hidden] (browser) (alt)
        
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
