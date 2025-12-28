# ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗██████╗ ██╗   ██╗██╗     ███████╗
# ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔══██╗██║   ██║██║     ██╔════╝
# ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║██████╔╝██║   ██║██║     █████╗  
# ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║██╔══██╗██║   ██║██║     ██╔══╝  
# ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝██║  ██║╚██████╔╝███████╗███████╗
#  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝
#------------------------------------------------------------------------------------



{ config, lib, pkgs, ... }:

{ 
  wayland.windowManager.hyprland = {
    settings = {
      windowrulev2 = [
        # Minecraft
        "fullscreen, class:^(Minecraft.*)$"
        "size 1920 1080, class:^(Minecraft.*)$"
        "center, class:^(Minecraft.*)$"
        # Disable blur for xwayland context menus
        "noblur,class:^()$,title:^()$"
        # "noblu, xwayland:1"


        # Floating
        "center, title:^(Open File)(.*)$"
        "float, title:^(Open File)(.*)$"
        "center, title:^(Select a File)(.*)$"
        "float, title:^(Select a File)(.*)$"
        "center, title:^(Choose wallpaper)(.*)$"
        "float, title:^(Choose wallpaper)(.*)$"
        "size 60% 65%, title:^(Choose wallpaper)(.*)$"
        "center, title:^(Open Folder)(.*)$"
        "float, title:^(Open Folder)(.*)$"
        "center, title:^(Save As)(.*)$"
        "float, title:^(Save As)(.*)$"
        "center, title:^(Library)(.*)$"
        "float, title:^(Library)(.*)$"
        "center, title:^(File Upload)(.*)$"
        "float, title:^(File Upload)(.*)$"
        "center, title:^(.*)(wants to save)$"
        "float, title:^(.*)(wants to save)$"
        "center, title:^(.*)(wants to open)$"
        "float, title:^(.*)(wants to open)$"
        "float, class:^(blueberry\.py)$"
        "float, class:^(guifetch)$   # FlafyDev/guifetch"
        "float, class:^(pavucontrol)$"
        "size 45%, class:^(pavucontrol)$"
        "center, class:^(pavucontrol)$"
        "float, class:^(org.pulseaudio.pavucontrol)$"
        "size 45%, class:^(org.pulseaudio.pavucontrol)$"
        "center, class:^(org.pulseaudio.pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "size 45%, class:^(nm-connection-editor)$"
        "center, class:^(nm-connection-editor)$"
        "float, class:.*plasmawindowed.*"
        "float, class:kcm_.*"
        "float, class:.*bluedevilwizard"
        "float, title:.*Welcome"
        "float, title:^(illogical-impulse Settings)$"
        "float, title:.*Shell conflicts.*"
        "float, class:org.freedesktop.impl.portal.desktop.kde"
        "size 60% 65%, class:org.freedesktop.impl.portal.desktop.kde"
        "float, class:^(Zotero)$"
        "size 45%, class:^(Zotero)$"

        # Move
        # kde-material-you-colors spawns a window when changing dark/light theme. This is to make sure it doesn't interfere at all.
        "float, class:^(plasma-changeicons)$"
        "noinitialfocus, class:^(plasma-changeicons)$"
        "move 999999 999999, class:^(plasma-changeicons)$"
        # stupid dolphin copy
        "move 40 80, title:^(Copying — Dolphin)$"

        # Tiling
        "tile, class:^dev\.warp\.Warp$"

        # Picture-in-Picture
        "float, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
        "keepaspectratio, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
        "move 73% 72%, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
        "size 25%, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
        "float, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
        "pin, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"

        # --- Tearing ---
        "immediate, title:.*\.exe"
        "immediate, title:.*minecraft.*"
        "immediate, class:^(steam_app).*"

        # No shadow for tiled windows (matches windows that are not floating).
        "noshadow, floating:0"
      ];

      layerrule = [
        # ######## Layer rules ########
        "xray 1, .*"
        # "noanim, .*"
        "noanim, walker"
        "noanim, selection"
        "noanim, overview"
        "noanim, anyrun"
        "noanim, indicator.*"
        "noanim, osk"
        "noanim, hyprpicker"

        "noanim, noanim"
        "blur, gtk-layer-shell"
        "ignorezero, gtk-layer-shell"
        "blur, launcher"
        "ignorealpha 0.5, launcher"
        "blur, notifications"
        "ignorealpha 0.69, notifications"
        "blur, logout_dialog # wlogout"

        "animation slide left, sideleft.*"
        "animation slide right, sideright.*"
        "blur, session[0-9]*"
        "blur, bar[0-9]*"
        "ignorealpha 0.6, bar[0-9]*"
        "blur, barcorner.*"
        "ignorealpha 0.6, barcorner.*"
        "blur, dock[0-9]*"
        "ignorealpha 0.6, dock[0-9]*"
        "blur, indicator.*"
        "ignorealpha 0.6, indicator.*"
        "blur, overview[0-9]*"
        "ignorealpha 0.6, overview[0-9]*"
        "blur, cheatsheet[0-9]*"
        "ignorealpha 0.6, cheatsheet[0-9]*"
        "blur, sideright[0-9]*"
        "ignorealpha 0.6, sideright[0-9]*"
        "blur, sideleft[0-9]*"
        "ignorealpha 0.6, sideleft[0-9]*"
        "blur, indicator.*"
        "ignorealpha 0.6, indicator.*"
        "blur, osk[0-9]*"
        "ignorealpha 0.6, osk[0-9]*"

        # Quickshell
        "blurpopups, quickshell:.*"
        "blur, quickshell:.*"
        "ignorealpha 0.79, quickshell:.*"
        "animation slide, quickshell:bar"
        "animation slide, quickshell:verticalBar"
        "animation fade, quickshell:screenCorners"
        "animation slide right, quickshell:sidebarRight"
        "animation slide left, quickshell:sidebarLeft"
        "animation slide bottom, quickshell:osk"
        "animation slide bottom, quickshell:dock"
        "blur, quickshell:session"
        "noanim, quickshell:session"
        "ignorealpha 0, quickshell:session"
        "animation fade, quickshell:notificationPopup"
        "blur, quickshell:backgroundWidgets"
        "ignorealpha 0.05, quickshell:backgroundWidgets"
        "noanim, quickshell:screenshot"
        "animation popin 120%, quickshell:screenCorners"
        "noanim, quickshell:lockWindowPusher"

        # Launchers need to be FAST
        "noanim, quickshell:overview"
        "noanim, gtk4-layer-shell"
        ## outfoxxed's stuff
        "blur, shell:bar"
        "ignorezero, shell:bar"
        "blur, shell:notifications"
        "ignorealpha 0.1, shell:notifications"
      ];

      workspace = [
        "special:special, gapsout:30"
      ];
    };
  };
}



