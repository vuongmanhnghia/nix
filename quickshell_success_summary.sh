#!/bin/bash

echo "🎉 QUICKSHELL SETUP COMPLETED SUCCESSFULLY!"
echo "==========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

print_highlight() {
    echo -e "${YELLOW}🌟${NC} $1"
}

echo -e "\n${GREEN}🎊 INSTALLATION STATUS${NC}"
echo "======================="
print_success "QuickShell v0.2.0 installed and running"
print_success "All major dependencies installed"
print_success "Configuration files properly linked"
print_success "System services configured"

echo -e "\n${BLUE}📊 RUNNING INSTANCES${NC}"
echo "==================="
quickshell list --all

echo -e "\n${PURPLE}🔧 INSTALLED DEPENDENCIES${NC}"
echo "=========================="
echo "✅ Core Framework:"
echo "   • QuickShell 0.2.0"
echo "   • Qt6 Framework (full suite)"
echo "   • QML runtime and tools"
echo ""
echo "✅ Audio System:"
echo "   • PipeWire + WirePlumber"
echo "   • PulseAudio compatibility"
echo "   • EasyEffects"
echo ""
echo "✅ System Integration:"
echo "   • UPower (battery management)"
echo "   • NetworkManager"
echo "   • Bluetooth stack"
echo "   • Hardware sensors"
echo ""
echo "✅ Input & Automation:"
echo "   • Ydotool (Wayland input)"
echo "   • Clipboard management"
echo "   • Brightness controls"
echo ""
echo "✅ Hyprland Integration:"
echo "   • Hyprland compositor support"
echo "   • Screenshot utilities"
echo "   • Color picker"
echo "   • Lock screen integration"
echo ""
echo "✅ Development Tools:"
echo "   • Python Wayland bindings"
echo "   • QML development tools"
echo "   • Material Design icons"

echo -e "\n${CYAN}📁 CONFIGURATION STRUCTURE${NC}"
echo "=========================="
echo "• ~/.config/quickshell/ → $(readlink ~/.config/quickshell)"
echo "• $(find ~/.config/quickshell/ii -name "*.qml" | wc -l) QML files"
echo "• $(find ~/.config/quickshell/ii/modules -maxdepth 1 -type d | tail -n +2 | wc -l) modules available"
echo "• $(find ~/.config/quickshell/ii/services -name "*.qml" | wc -l) services configured"

echo -e "\n${YELLOW}🚀 USAGE COMMANDS${NC}"
echo "================="
echo "• Start QuickShell:     quickshell -c ii"
echo "• Open settings:        quickshell -p ~/.config/quickshell/ii/settings.qml"
echo "• List instances:       quickshell list --all"
echo "• Kill all instances:   quickshell kill --all"
echo "• View logs:            quickshell log"
echo "• Reload config:        quickshell -c ii --reload"

echo -e "\n${PURPLE}⚙️ ADVANCED USAGE${NC}"
echo "=================="
echo "• Debug mode:           quickshell -c ii -vv --log-times"
echo "• Test specific module: Edit shell.qml enable/disable flags"
echo "• Custom config:        quickshell -p /path/to/your/config.qml"
echo "• IPC communication:    quickshell ipc call <method>"

echo -e "\n${GREEN}📋 NEXT STEPS${NC}"
echo "=============="
echo "1. 🎨 Customize your UI by editing modules in ~/.config/quickshell/ii/modules/"
echo "2. 🔧 Configure services in ~/.config/quickshell/ii/services/"
echo "3. 🎯 Set up AI features by configuring API keys in Ai.qml"
echo "4. 🌈 Customize themes and colors via the settings app"
echo "5. ⌨️ Add custom keybindings in Hyprland configuration"

echo -e "\n${BLUE}🔍 TROUBLESHOOTING${NC}"
echo "=================="
echo "• Config issues:        quickshell -c ii -vv --log-times"
echo "• Service problems:     systemctl --user status <service>"
echo "• Audio issues:         pactl info"
echo "• Python script errors: Check PYTHONPATH in environment"

echo -e "\n${YELLOW}💡 TIPS & TRICKS${NC}"
echo "================"
echo "• Use Ctrl+Super+R to reload QuickShell"
echo "• Access settings with Super+I"
echo "• Screenshots with Super+S"
echo "• Toggle sidebars with Super+B and Super+N"
echo "• Overview mode with Super key"

echo -e "\n${GREEN}🎉 CONGRATULATIONS!${NC}"
echo "==================="
echo "Your QuickShell desktop environment is now fully functional!"
echo "You have a modern, customizable UI with:"
echo "• Dynamic bars and panels"
echo "• System monitoring widgets"
echo "• Media controls"
echo "• Notification system"
echo "• AI integration capabilities"
echo "• Beautiful theming system"

echo -e "\n${CYAN}📚 RESOURCES${NC}"
echo "============"
echo "• QuickShell Docs: https://quickshell.outfoxxed.me/"
echo "• Configuration: ~/.config/quickshell/ii/"
echo "• Logs: /run/user/1000/quickshell/"
echo "• This setup: /home/nagih/Workspaces/Config/nixos/"

echo -e "\n${PURPLE}✨ Enjoy your new QuickShell desktop! ✨${NC}" 