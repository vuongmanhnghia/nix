#  █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
# ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
# ███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║   
# ██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║   
# ██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║   
# ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
#------------------------------------------------------------------------------

{ config, lib, pkgs, hostVars, ... }:

{
  wayland.windowManager.hyprland = {    
    settings = {
      exec-once = [
        # Set monitors
        "${hostVars.nix_config}/scripts/set_monitors.sh"
        
        "${hostVars.nix_config}/modules/home-manager/desktop/hyprland/scripts/start_geoclue_agent.sh"
        "qs -c $qsConfig &" # QuickShell

        # Setup fcitx5
        "export GTK_IM_MODULE=fcitx5"
        "export QT_IM_MODULE=fcitx5"
        "export XMODIFIERS=@im=fcitx5"
        "export INPUT_METHOD=fcitx5"
        "export SDL_IM_MODULE=fcitx5"
        "fcitx5"

        # Core components (authentication, lock screen, notification daemon)
        "gnome-keyring-daemon --start --components=secrets"
        "/usr/lib/polkit-kde-authentication-agent-1 || /usr/libexec/polkit-kde-authentication-agent-1  || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1"
        "hypridle"
        "dbus-update-activation-environment --all"
        "sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # Some fix idk"
        "hyprpm reload"

        # Clipboard: history
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store && qs -c $qsConfig ipc call cliphistService update"
        "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store && qs -c $qsConfig ipc call cliphistService update"

        # Set cursor theme
        "hyprctl setcursor macOS 24"

        # Network management
        "${pkgs.networkmanagerapplet}/bin/nm-applet"

        # "otd-daemon" # Tablet
      ];
    };
  };
}