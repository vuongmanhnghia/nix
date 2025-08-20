echo "
██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗ 
██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗
███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║
██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║
██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝
╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 
-------------------------------------------------------------------"

# Configure Nix
echo "Configuring Nix..."\n\n
echo "-----------------------------------"

echo "Detecting monitor port name and resolution..."
echo ""
port_name=$(xrandr | grep " connected" | head -1 | awk '{print $1}')
resolution=$(xrandr | grep " connected" | head -1 | awk '{print $3}' | cut -d '+' -f 1)
read -p "What is your display frequency(hz)? (144/165/180, etc...): " frequency
echo ""

echo "Display configuration analyzed successfully!"
echo ""

echo "
DISPLAY:
  PORT: $port_name
  RESOLUTION: $resolution
  FREQUENCY: $frequency
"
echo ""

echo "Configuring environment..."

# Configure monitors.nix
monitors_path="./home/shared/hypr/modules/monitors.nix"
if [ -f "$monitors_path" ]; then
    rm $monitors_path
fi
cat > $monitors_path << EOF
# ███╗   ███╗ ██████╗ ███╗   ██╗██╗████████╗ ██████╗ ██████╗ ███████╗
# ████╗ ████║██╔═══██╗████╗  ██║██║╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝
# ██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║   ██║   ██║██████╔╝███████╗
# ██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║   ██║   ██║██╔══██╗╚════██║
# ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║   ██║   ╚██████╔╝██║  ██║███████║
# ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝
# --------------------------------------------------------------------


{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "$port_name, $resolution@$frequency, 0x0, 1"
      ];
    };
  };
}
EOF

# Configure environment.nix
environment_path="./home/shared/hypr/modules/environment.nix"
if [ -f "$environment_path" ]; then
    rm $environment_path
fi
if [ $resolution == "2560x1440" ]; then
cat > $environment_path << EOF
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
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
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
EOF
else
cat > $environment_path << EOF
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
        "GDK_SCALE,1"
        "ELM_SCALE,1"
        "QT_SCALE_FACTOR,1"

        "XCURSOR_SIZE,32"
        "HYPRCURSOR_SIZE,32"
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
EOF
fi

echo "Environment configured successfully!"
echo "-----------------------------------"


