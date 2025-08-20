#!/bin/bash

echo "🔍 QUICKSHELL CONFIGURATION ANALYSIS"
echo "====================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_section() {
    echo -e "\n${BLUE}$1${NC}"
    echo "$(printf '=%.0s' {1..60})"
}

print_subsection() {
    echo -e "\n${CYAN}$1${NC}"
    echo "$(printf '-%.0s' {1..40})"
}

check_dependency() {
    local dep=$1
    local desc=$2
    if command -v "$dep" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $dep - $desc"
        return 0
    else
        echo -e "${RED}✗${NC} $dep - $desc"
        return 1
    fi
}

check_service() {
    local service=$1
    local desc=$2
    if systemctl --user is-active "$service" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $service (active) - $desc"
    elif systemctl --user is-enabled "$service" >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠${NC} $service (enabled but not running) - $desc"
    else
        echo -e "${RED}✗${NC} $service (not available) - $desc"
    fi
}

print_section "1. CONFIGURATION STRUCTURE ANALYSIS"

echo "📁 QuickShell Config Directory:"
ls -la ~/.config/quickshell/

echo -e "\n📁 Main Components:"
echo "  • $(find ~/.config/quickshell/ii -name "*.qml" | wc -l) QML files"
echo "  • $(find ~/.config/quickshell/ii/modules -maxdepth 1 -type d | tail -n +2 | wc -l) modules"
echo "  • $(find ~/.config/quickshell/ii/services -name "*.qml" | wc -l) services"
echo "  • $(find ~/.config/quickshell/ii/scripts -type f | wc -l) scripts"

print_section "2. CORE DEPENDENCIES CHECK"

print_subsection "QuickShell Core"
check_dependency "quickshell" "QuickShell binary"
if command -v quickshell >/dev/null 2>&1; then
    echo "  Version: $(quickshell --version | head -1)"
fi

print_subsection "Qt6 Framework"
check_dependency "qml" "QML runtime"
check_dependency "qmllint" "QML syntax checker"
echo "Qt6 packages installed:"
nix-env -q | grep qt6 | head -5 || echo "  No qt6 packages found in user profile"

print_section "3. AUDIO SYSTEM DEPENDENCIES"

print_subsection "Audio Core"
check_dependency "pipewire" "Modern audio server"
check_dependency "wireplumber" "PipeWire session manager"
check_dependency "pactl" "PulseAudio control"
check_dependency "easyeffects" "Audio effects"

print_subsection "Audio Services"
check_service "pipewire" "PipeWire audio server"
check_service "wireplumber" "PipeWire session manager"
check_service "pipewire-pulse" "PipeWire PulseAudio compatibility"

print_section "4. SYSTEM MONITORING DEPENDENCIES"

print_subsection "Power Management"
check_dependency "upower" "Power management"
check_dependency "acpi" "ACPI utilities"
check_service "upower" "UPower daemon"

print_subsection "Hardware Monitoring"
check_dependency "sensors" "Hardware sensors"
check_dependency "lscpu" "CPU information"
check_dependency "free" "Memory information"

print_section "5. NETWORK & CONNECTIVITY"

print_subsection "Network Management"
check_dependency "nmcli" "NetworkManager CLI"
check_dependency "nm-applet" "NetworkManager applet"
check_service "NetworkManager" "NetworkManager service"

print_subsection "Bluetooth"
check_dependency "bluetoothctl" "Bluetooth control"
check_service "bluetooth" "Bluetooth service"

print_section "6. INPUT & AUTOMATION"

print_subsection "Input Automation"
check_dependency "ydotool" "Wayland input automation"
check_dependency "ydotoold" "Ydotool daemon"
check_service "ydotool" "Ydotool daemon service"

print_subsection "Clipboard"
check_dependency "wl-copy" "Wayland clipboard copy"
check_dependency "wl-paste" "Wayland clipboard paste"
check_dependency "cliphist" "Clipboard history"

print_section "7. DISPLAY & BRIGHTNESS"

print_subsection "Brightness Control"
check_dependency "brightnessctl" "Backlight control"
check_dependency "ddcutil" "Monitor DDC control"

print_subsection "Screenshot & Color"
check_dependency "hyprshot" "Hyprland screenshot"
check_dependency "hyprpicker" "Color picker"

print_section "8. NOTIFICATIONS"

check_dependency "notify-send" "Desktop notifications"
check_dependency "dunst" "Notification daemon"
check_service "dunst" "Dunst notification daemon"

print_section "9. HYPRLAND INTEGRATION"

print_subsection "Hyprland Core"
check_dependency "hyprctl" "Hyprland control"
check_dependency "hyprlock" "Screen locker"
check_dependency "hypridle" "Idle management"

print_subsection "Hyprland Services"
if pgrep -f hyprland >/dev/null; then
    echo -e "${GREEN}✓${NC} Hyprland compositor (running)"
else
    echo -e "${RED}✗${NC} Hyprland compositor (not running)"
fi

print_section "10. AI & OPTIONAL SERVICES"

print_subsection "AI Services"
check_dependency "ollama" "Local AI models"
check_dependency "curl" "HTTP client"
check_dependency "jq" "JSON processor"

print_section "11. PYTHON ENVIRONMENT"

print_subsection "Python Dependencies"
check_dependency "python3" "Python runtime"

echo "Python packages check:"
python3 -c "import pywayland; print('✓ pywayland available')" 2>/dev/null || echo -e "${RED}✗${NC} pywayland not available"
python3 -c "import setproctitle; print('✓ setproctitle available')" 2>/dev/null || echo -e "${RED}✗${NC} setproctitle not available"

print_section "12. QUICKSHELL FUNCTIONALITY TEST"

echo "Testing QuickShell config loading..."
echo "Config 'ii' test (timeout 5s):"
if timeout 5s quickshell -c ii -v >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Config 'ii' loads successfully"
else
    echo -e "${RED}✗${NC} Config 'ii' has loading issues"
    echo "Error details:"
    timeout 3s quickshell -c ii -v 2>&1 | head -10 | sed 's/^/  /'
fi

print_section "13. RECOMMENDATIONS"

echo -e "${YELLOW}Based on analysis:${NC}"
echo ""
echo "1. Install missing dependencies:"
echo "   sudo nixos-rebuild switch --flake ."
echo ""
echo "2. Enable required services:"
echo "   systemctl --user enable --now ydotool"
echo "   systemctl --user enable --now dunst"
echo ""
echo "3. Test QuickShell step by step:"
echo "   quickshell -c ii -vv --log-times"
echo ""
echo "4. Check specific service logs:"
echo "   journalctl --user -f -u pipewire"
echo "   journalctl --user -f -u ydotool"

echo -e "\n${GREEN}✨ Analysis completed!${NC}"
echo "Review the output above to identify missing dependencies." 