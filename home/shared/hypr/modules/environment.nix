# ███████╗███╗   ██╗██╗   ██╗██╗██████╗  ██████╗ ███╗   ██╗███╗   ███╗███████╗███╗   ██╗████████╗
# ██╔════╝████╗  ██║██║   ██║██║██╔══██╗██╔═══██╗████╗  ██║████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
# █████╗  ██╔██╗ ██║██║   ██║██║██████╔╝██║   ██║██╔██╗ ██║██╔████╔██║█████╗  ██╔██╗ ██║   ██║   
# ██╔══╝  ██║╚██╗██║╚██╗ ██╔╝██║██╔══██╗██║   ██║██║╚██╗██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   
# ███████╗██║ ╚████║ ╚████╔╝ ██║██║  ██║╚██████╔╝██║ ╚████║██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   
# ╚══════╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   
#------------------------------------------------------------------------------------------------


{ config, lib, pkgs, ... }:


{
  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "XCURSOR_SIZE,32"
        "HYPRCURSOR_SIZE,32"
        "GDK_SCALE,1"
        "ELM_SCALE,1"
        "QT_SCALE_FACTOR,1"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_QPA_PLATFORMTHEME,qt6ct"

        # === CURSOR THEME ===
        "XCURSOR_THEME,apple-cursor"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,apple-cursor"
        "HYPRCURSOR_SIZE,24"

        # ############ Wayland #############
        "ELECTRON_OZONE_PLATFORM_HINT,auto"

        # ############ Themes #############
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,kde"
        "XDG_MENU_PREFIX,plasma-"

        # ############ Terminal application #########
        "TERMINAL,kitty"

        # ######## Virtual envrionment #########
        "ILLOGICAL_IMPULSE_VIRTUAL_ENV, ~/.local/state/quickshell/.venv"
      ];
    };
  };
}
