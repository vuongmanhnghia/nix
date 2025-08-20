#!/bin/bash

echo "🚀 QUICKSHELL DEPENDENCIES INSTALLATION"
echo "========================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "\n${BLUE}$1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

print_step "1. BACKUP CURRENT CONFIGURATION"
BACKUP_DIR="/home/nagih/nixos-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r /home/nagih/Workspaces/Config/nixos/home/nagih.nix "$BACKUP_DIR/"
print_success "Backup created at: $BACKUP_DIR"

print_step "2. VALIDATE QUICKSHELL DEPENDENCIES FILE"
if [ -f "/home/nagih/Workspaces/Config/nixos/home/quickshell-dependencies.nix" ]; then
    print_success "QuickShell dependencies file exists"
    
    # Check syntax
    if nix-instantiate --parse /home/nagih/Workspaces/Config/nixos/home/quickshell-dependencies.nix >/dev/null 2>&1; then
        print_success "Dependencies file syntax is valid"
    else
        print_error "Dependencies file has syntax errors"
        echo "Syntax check output:"
        nix-instantiate --parse /home/nagih/Workspaces/Config/nixos/home/quickshell-dependencies.nix 2>&1 | head -10
        exit 1
    fi
else
    print_error "QuickShell dependencies file not found!"
    exit 1
fi

print_step "3. VALIDATE MAIN CONFIGURATION"
if nix-instantiate --parse /home/nagih/Workspaces/Config/nixos/home/nagih.nix >/dev/null 2>&1; then
    print_success "Main configuration syntax is valid"
else
    print_error "Main configuration has syntax errors"
    echo "Syntax check output:"
    nix-instantiate --parse /home/nagih/Workspaces/Config/nixos/home/nagih.nix 2>&1 | head -10
    exit 1
fi

print_step "4. VALIDATE FLAKE CONFIGURATION"
if nix flake check /home/nagih/Workspaces/Config/nixos 2>/dev/null; then
    print_success "Flake configuration is valid"
else
    print_error "Flake has issues"
    echo "Flake check output:"
    nix flake check /home/nagih/Workspaces/Config/nixos 2>&1 | head -10
fi

print_step "5. SYSTEM SERVICES CHECK"
print_info "Checking if system services need to be enabled..."

# Check if we need to enable system services
SYSTEM_SERVICES_NEEDED=false

if ! systemctl is-enabled bluetooth >/dev/null 2>&1; then
    print_info "Bluetooth service needs to be enabled"
    SYSTEM_SERVICES_NEEDED=true
fi

if ! systemctl is-enabled NetworkManager >/dev/null 2>&1; then
    print_info "NetworkManager service needs to be enabled"
    SYSTEM_SERVICES_NEEDED=true
fi

if [ "$SYSTEM_SERVICES_NEEDED" = true ]; then
    print_info "Some system services need configuration"
    print_info "This will be handled by nixos-rebuild"
fi

print_step "6. BUILD AND INSTALL"
print_info "Starting NixOS rebuild with QuickShell dependencies..."
print_info "This may take several minutes..."

cd /home/nagih/Workspaces/Config/nixos

if sudo nixos-rebuild switch --flake . --show-trace; then
    print_success "NixOS rebuild completed successfully!"
else
    print_error "NixOS rebuild failed!"
    echo "Check the error output above and fix any issues"
    exit 1
fi

print_step "7. ENABLE USER SERVICES"
print_info "Enabling user services..."

# Enable ydotool if available
if systemctl --user list-unit-files | grep -q ydotool; then
    systemctl --user enable ydotool
    systemctl --user start ydotool
    print_success "Ydotool service enabled and started"
else
    print_info "Ydotool service not available (will be enabled after next login)"
fi

print_step "8. POST-INSTALLATION VERIFICATION"
print_info "Verifying installation..."

# Check QuickShell
if command -v quickshell >/dev/null 2>&1; then
    print_success "QuickShell binary available"
    echo "  Version: $(quickshell --version | head -1)"
else
    print_error "QuickShell binary not found"
fi

# Check key dependencies
MISSING_DEPS=0

for dep in pipewire pactl nmcli bluetoothctl ydotool wl-copy cliphist brightnessctl notify-send hyprctl; do
    if command -v "$dep" >/dev/null 2>&1; then
        print_success "$dep available"
    else
        print_error "$dep missing"
        MISSING_DEPS=$((MISSING_DEPS + 1))
    fi
done

print_step "9. QUICKSHELL CONFIG TEST"
print_info "Testing QuickShell configuration..."

echo "Testing basic QuickShell functionality..."
if timeout 5s quickshell -c ii -v >/dev/null 2>&1; then
    print_success "QuickShell config 'ii' loads successfully!"
else
    print_error "QuickShell config 'ii' still has issues"
    echo "Detailed error output:"
    timeout 3s quickshell -c ii -v 2>&1 | head -15 | sed 's/^/  /'
fi

print_step "10. FINAL SUMMARY"

if [ $MISSING_DEPS -eq 0 ]; then
    print_success "All dependencies installed successfully!"
    echo ""
    echo -e "${GREEN}🎉 QuickShell is ready to use!${NC}"
    echo ""
    echo "To start QuickShell:"
    echo "  quickshell -c ii"
    echo ""
    echo "To open settings:"
    echo "  quickshell -p ~/.config/quickshell/ii/settings.qml"
    echo ""
    echo "To monitor logs:"
    echo "  quickshell log"
else
    print_error "$MISSING_DEPS dependencies are still missing"
    echo "Please check the NixOS configuration and rebuild again"
fi

echo -e "\n${BLUE}📝 NEXT STEPS:${NC}"
echo "1. Logout and login again to ensure all environment variables are loaded"
echo "2. Start QuickShell: quickshell -c ii"
echo "3. If issues persist, check logs: quickshell log"
echo "4. Gradually enable modules in shell.qml if needed"

echo -e "\n${GREEN}✨ Installation script completed!${NC}" 