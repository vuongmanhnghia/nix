# ███████╗███╗   ██╗██╗   ██╗██╗██████╗  ██████╗ ███╗   ██╗███╗   ███╗███████╗███╗   ██╗████████╗
# ██╔════╝████╗  ██║██║   ██║██║██╔══██╗██╔═══██╗████╗  ██║████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
# █████╗  ██╔██╗ ██║██║   ██║██║██████╔╝██║   ██║██╔██╗ ██║██╔████╔██║█████╗  ██╔██╗ ██║   ██║   
# ██╔══╝  ██║╚██╗██║╚██╗ ██╔╝██║██╔══██╗██║   ██║██║╚██╗██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   
# ███████╗██║ ╚████║ ╚████╔╝ ██║██║  ██║╚██████╔╝██║ ╚████║██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   
# ╚══════╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   
#------------------------------------------------------------------------------------------------


{ config, lib, pkgs, hostVars, ... }:


{
  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "GDK_SCALE,1"
        "ELM_SCALE,1"
        "QT_SCALE_FACTOR,1"
        
        # === CURSOR THEME ===
        "XCURSOR_THEME,apple-cursor"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,apple-cursor"
        "HYPRCURSOR_SIZE,24"

        # ############ Wayland #############
        "ELECTRON_OZONE_PLATFORM_HINT,auto"

        # ############ Themes #############
        "XDG_MENU_PREFIX,plasma-"
        "QT_QPA_PLATFORMTHEME,qt6ct"

        # ######## Virtual envrionment #########
        "ILLOGICAL_IMPULSE_VIRTUAL_ENV=${config.home.homeDirectory}/.local/state/quickshell/.venv"
      ];
    };
  };
}
