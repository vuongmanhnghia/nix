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
      monitor = [ # monitor = <tên>,<độ phân giải>@<tần số quét>,<vị trí>,<tỷ lệ>
        "$port_name, $resolution@$frequency, 0x0, 1, bitdepth, 10"
        "HDMI-A-1, 1920x1080@100, 2560x360, 1, bitdepth, 10"

        # Màn hình laptop, tự động chọn độ phân giải và tần số quét tốt nhất
        # "eDP-1,preferred,auto,1" 

        # Màn hình ngoài, 2560x1440@144Hz, đặt bên phải eDP-1, không scale
        #"DP-1,2560x1440@144,auto,1,bitdepth,10"

        # Có thể thêm dòng này để đặt màn hình chính
        # "workspace=DP-1,1" # Mở workspace 1 trên màn hình DP-1
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
        # "QS_CONFIG,ii"
        # "HYPRLAND_INSTANCE_SIGNATURE,wayland-1"
        
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



workspaces_path="./home/shared/hypr/modules/workspaces.nix"
if [ -f "$workspaces_path" ]; then
    rm $workspaces_path
fi
cat > $workspaces_path << EOF
# ██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗███████╗██████╗  █████╗  ██████╗███████╗███████╗
# ██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝
# ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ ███████╗██████╔╝███████║██║     █████╗  ███████╗
# ██║███╗██║██║   ██║██╔══██╗██╔═██╗ ╚════██║██╔═══╝ ██╔══██║██║     ██╔══╝  ╚════██║
# ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗███████║██║     ██║  ██║╚██████╗███████╗███████║
#  ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═════╝╚══════╝╚══════╝
#------------------------------------------------------------------------------------


{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      workspace = [
        "1, monitor:$port_name"
        "2, monitor:$port_name"
        "3, monitor:$port_name"
        "4, monitor:$port_name"
        "5, monitor:$port_name"
        "6, monitor:$port_name"
        "7, monitor:$port_name"
        "8, monitor:$port_name"
        "9, monitor:$port_name"
        "10, monitor:$port_name"
      ];
    };
  };
}

EOF

echo "Workspaces configured successfully!"
echo "-----------------------------------"


