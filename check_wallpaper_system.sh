#!/bin/bash

echo "🖼️  WALLPAPER SYSTEM STATUS CHECK"
echo "================================="

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
    echo "$(printf '=%.0s' {1..50})"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ️${NC} $1"
}

# Environment variables
QUICKSHELL_CONFIG_NAME="ii"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
PICTURES_DIR=$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")
CONFIG_DIR="$XDG_CONFIG_HOME/quickshell/$QUICKSHELL_CONFIG_NAME"
CACHE_DIR="$XDG_CACHE_HOME/quickshell"
STATE_DIR="$XDG_STATE_HOME/quickshell"
SHELL_CONFIG_FILE="$XDG_CONFIG_HOME/illogical-impulse/config.json"

print_section "1. ENVIRONMENT & PATHS"
echo "PICTURES_DIR: $PICTURES_DIR"
echo "CONFIG_DIR: $CONFIG_DIR"
echo "STATE_DIR: $STATE_DIR"
echo "SHELL_CONFIG_FILE: $SHELL_CONFIG_FILE"

print_section "2. REQUIRED DEPENDENCIES"

# Check curl
if command -v curl >/dev/null 2>&1; then
    print_success "curl available"
else
    print_error "curl not found - needed for downloading wallpapers"
fi

# Check jq
if command -v jq >/dev/null 2>&1; then
    print_success "jq available"
else
    print_error "jq not found - needed for JSON processing"
fi

# Check xdg-user-dir
if command -v xdg-user-dir >/dev/null 2>&1; then
    print_success "xdg-user-dir available"
else
    print_warning "xdg-user-dir not found - will use default paths"
fi

# Check matugen
if command -v matugen >/dev/null 2>&1; then
    print_success "matugen available"
else
    print_error "matugen not found - needed for color generation"
fi

# Check hyprctl
if command -v hyprctl >/dev/null 2>&1; then
    print_success "hyprctl available"
else
    print_error "hyprctl not found - needed for Hyprland integration"
fi

print_section "3. DIRECTORY STRUCTURE"

# Check Pictures/Wallpapers directory
if [ -d "$PICTURES_DIR/Wallpapers" ]; then
    print_success "Wallpapers directory exists: $PICTURES_DIR/Wallpapers"
    wallpaper_count=$(find "$PICTURES_DIR/Wallpapers" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) 2>/dev/null | wc -l)
    print_info "Found $wallpaper_count wallpaper files"
else
    print_warning "Wallpapers directory doesn't exist: $PICTURES_DIR/Wallpapers"
    print_info "Will be created when downloading wallpapers"
fi

# Check QuickShell state directory
if [ -d "$STATE_DIR/user/generated" ]; then
    print_success "QuickShell state directory exists"
else
    print_warning "QuickShell state directory doesn't exist: $STATE_DIR/user/generated"
fi

# Check config file
if [ -f "$SHELL_CONFIG_FILE" ]; then
    print_success "Shell config file exists"
    current_wallpaper=$(jq -r '.background.wallpaperPath // "null"' "$SHELL_CONFIG_FILE" 2>/dev/null)
    if [ "$current_wallpaper" != "null" ] && [ "$current_wallpaper" != "" ]; then
        print_info "Current wallpaper: $current_wallpaper"
        if [ -f "$current_wallpaper" ]; then
            print_success "Current wallpaper file exists"
        else
            print_error "Current wallpaper file not found"
        fi
    else
        print_warning "No wallpaper path set in config"
    fi
else
    print_error "Shell config file not found: $SHELL_CONFIG_FILE"
fi

print_section "4. SCRIPT AVAILABILITY"

# Check konachan script
KONACHAN_SCRIPT="$CONFIG_DIR/scripts/colors/random_konachan_wall.sh"
if [ -f "$KONACHAN_SCRIPT" ]; then
    print_success "Konachan script exists"
    if [ -x "$KONACHAN_SCRIPT" ]; then
        print_success "Konachan script is executable"
    else
        print_warning "Konachan script is not executable"
    fi
else
    print_error "Konachan script not found: $KONACHAN_SCRIPT"
    # Try alternative location
    ALT_KONACHAN_SCRIPT="/home/nagih/Workspaces/Config/dots-hyprland/.config/quickshell/ii/scripts/colors/random_konachan_wall.sh"
    if [ -f "$ALT_KONACHAN_SCRIPT" ]; then
        print_info "Found alternative location: $ALT_KONACHAN_SCRIPT"
    fi
fi

# Check switchwall script
SWITCHWALL_SCRIPT="$CONFIG_DIR/scripts/colors/switchwall.sh"
if [ -f "$SWITCHWALL_SCRIPT" ]; then
    print_success "Switchwall script exists"
    if [ -x "$SWITCHWALL_SCRIPT" ]; then
        print_success "Switchwall script is executable"
    else
        print_warning "Switchwall script is not executable"
    fi
else
    print_error "Switchwall script not found: $SWITCHWALL_SCRIPT"
fi

print_section "5. NETWORK CONNECTIVITY TEST"

print_info "Testing connection to Konachan API..."
if timeout 5 curl -s "https://konachan.net/post.json?limit=1" >/dev/null 2>&1; then
    print_success "Can connect to Konachan API"
else
    print_error "Cannot connect to Konachan API - check internet connection"
fi

print_section "6. QUICKSHELL INTEGRATION TEST"

# Check if QuickShell is running
if pgrep -f quickshell >/dev/null; then
    print_success "QuickShell is running"
    
    # Try to call QuickShell IPC
    if command -v quickshell >/dev/null 2>&1; then
        print_info "Testing QuickShell IPC..."
        if timeout 3 quickshell ipc call TEST_ALIVE >/dev/null 2>&1; then
            print_success "QuickShell IPC is working"
        else
            print_warning "QuickShell IPC test failed or timed out"
        fi
    fi
else
    print_warning "QuickShell is not running"
fi

print_section "7. PYTHON VIRTUAL ENVIRONMENT"

# Check virtual environment for Python scripts
VENV_PATH="$XDG_STATE_HOME/quickshell/.venv"
if [ -d "$VENV_PATH" ]; then
    print_success "Python virtual environment exists: $VENV_PATH"
    if [ -f "$VENV_PATH/bin/activate" ]; then
        print_success "Virtual environment activation script found"
    else
        print_error "Virtual environment activation script missing"
    fi
else
    print_warning "Python virtual environment not found: $VENV_PATH"
fi

print_section "8. MANUAL TEST COMMANDS"

echo -e "${YELLOW}🧪 Manual Test Commands:${NC}"
echo ""
echo "1. Test Konachan wallpaper download:"
echo "   bash ~/.config/quickshell/ii/scripts/colors/random_konachan_wall.sh"
echo ""
echo "2. Test wallpaper switching:"
echo "   bash ~/.config/quickshell/ii/scripts/colors/switchwall.sh --image /path/to/image.jpg"
echo ""
echo "3. Test from QuickShell settings:"
echo "   quickshell -p ~/.config/quickshell/ii/settings.qml"
echo ""
echo "4. Test from welcome app:"
echo "   quickshell -p ~/.config/quickshell/ii/welcome.qml"

print_section "9. TROUBLESHOOTING TIPS"

echo -e "${PURPLE}🔧 Common Issues & Solutions:${NC}"
echo ""
echo "• If konachanWallProc fails:"
echo "  - Check internet connection"
echo "  - Verify curl and jq are installed"
echo "  - Check script permissions"
echo ""
echo "• If wallpaper doesn't change:"
echo "  - Check matugen installation"
echo "  - Verify Hyprland is running"
echo "  - Check config file permissions"
echo ""
echo "• If colors don't update:"
echo "  - Check Python virtual environment"
echo "  - Verify color generation scripts"
echo "  - Check state directory permissions"

print_section "10. LIVE MONITORING"

echo -e "${CYAN}📊 To monitor wallpaper processes in real-time:${NC}"
echo ""
echo "• Watch QuickShell logs:"
echo "  quickshell log"
echo ""
echo "• Monitor file changes:"
echo "  watch -n 1 'ls -la $PICTURES_DIR/Wallpapers/ | tail -5'"
echo ""
echo "• Check process activity:"
echo "  watch -n 1 'pgrep -f \"konachan\\|switchwall\\|matugen\"'"

echo -e "\n${GREEN}✨ Wallpaper system check completed!${NC}" 