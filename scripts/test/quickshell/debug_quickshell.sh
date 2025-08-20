#!/bin/bash

echo "🔍 QUICKSHELL DEBUG ANALYSIS"
echo "============================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_section() {
    echo -e "\n${BLUE}$1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

print_section "1. ENVIRONMENT VARIABLES"
echo "QT_QPA_PLATFORM: ${QT_QPA_PLATFORM:-not set}"
echo "QT_WAYLAND_DISABLE_WINDOWDECORATION: ${QT_WAYLAND_DISABLE_WINDOWDECORATION:-not set}"
echo "XDG_SESSION_TYPE: ${XDG_SESSION_TYPE:-not set}"
echo "WAYLAND_DISPLAY: ${WAYLAND_DISPLAY:-not set}"

print_section "2. QUICKSHELL VERSION & LOCATION"
which quickshell
quickshell --version

print_section "3. CONFIG STRUCTURE"
echo "Config directory:"
ls -la ~/.config/quickshell/

echo -e "\nii directory:"
ls -la ~/.config/quickshell/ii/

print_section "4. SYMLINK TARGET"
echo "Symlink target:"
readlink ~/.config/quickshell
echo -e "\nTarget contents:"
ls -la "$(readlink ~/.config/quickshell)"

print_section "5. MAIN CONFIG FILE ANALYSIS"
echo "shell.qml content (first 20 lines):"
head -20 ~/.config/quickshell/ii/shell.qml

print_section "6. SERVICES ANALYSIS"
echo "Available services:"
ls ~/.config/quickshell/ii/services/ | head -10

echo -e "\nFirst service file analysis (Ai.qml first 10 lines):"
head -10 ~/.config/quickshell/ii/services/Ai.qml

print_section "7. MODULES ANALYSIS"
echo "Available modules:"
ls ~/.config/quickshell/ii/modules/

echo -e "\nChecking common module:"
ls ~/.config/quickshell/ii/modules/common/

print_section "8. QT DEPENDENCIES"
echo "Checking Qt libraries:"
find /nix/store -name "*qt6*" -type d 2>/dev/null | head -5

print_section "9. DETAILED ERROR ANALYSIS"
echo "Running QuickShell with maximum verbosity (first 50 lines of output):"
timeout 10s quickshell -c ii -vv --log-times 2>&1 | head -50

print_section "10. QML IMPORT PATH"
echo "Checking QML import paths:"
echo "QML_IMPORT_PATH: ${QML_IMPORT_PATH:-not set}"
echo "QML2_IMPORT_PATH: ${QML2_IMPORT_PATH:-not set}"

# Try to find QML modules
echo -e "\nLooking for QML modules in system:"
find /nix/store -name "qml" -type d 2>/dev/null | head -5

print_section "11. PROCESS ANALYSIS"
echo "QuickShell processes:"
pgrep -f quickshell || echo "No QuickShell processes running"

echo -e "\n${GREEN}Debug analysis completed!${NC}"
echo "Review the output above to identify potential issues." 