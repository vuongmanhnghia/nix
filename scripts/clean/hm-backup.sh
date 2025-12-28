#!/run/current-system/sw/bin/bash

# Script để dọn dẹp Home Manager backup files trước khi rebuild
# Sử dụng: ./cleanup-hm-backups.sh [--dry-run]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
HOME_DIR="$HOME"
CONFIG_DIR="$HOME/.config"
DRY_RUN=false

# Parse arguments
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${YELLOW}🔍 DRY RUN MODE - No files will be deleted${NC}"
fi

echo -e "${GREEN}🧹 Cleaning up Home Manager backup files...${NC}"

# Function to remove backup files
cleanup_backups() {
    local pattern="$1"
    local description="$2"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}Would remove:${NC} $description"
        find "$CONFIG_DIR" -name "$pattern" 2>/dev/null || true
    else
        local count=$(find "$CONFIG_DIR" -name "$pattern" 2>/dev/null | wc -l)
        if [[ $count -gt 0 ]]; then
            echo -e "${RED}Removing:${NC} $description ($count files)"
            find "$CONFIG_DIR" -name "$pattern" -delete 2>/dev/null || true
        fi
    fi
}

# Clean up different types of backup files
cleanup_backups "*.backup" "Standard backup files (*.backup)"
cleanup_backups "*.backup-*" "Timestamped backup files (*.backup-*)"

# Clean up specific problematic directories
problematic_dirs=(
    ".config/hypr"
    ".config/wlogout" 
    ".config/fuzzel"
    ".config/kitty"
    ".config/rofi"
    ".config/fcitx5"
    ".cache/fcitx5"
    ".local/share/fcitx5"
)

for dir in "${problematic_dirs[@]}"; do
    full_path="$HOME/$dir"
    if [[ -d "$full_path" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            echo -e "${YELLOW}Would check:${NC} $dir"
            find "$full_path" -name "*.backup*" 2>/dev/null || true
        else
            local count=$(find "$full_path" -name "*.backup*" 2>/dev/null | wc -l)
            if [[ $count -gt 0 ]]; then
                echo -e "${RED}Cleaning:${NC} $dir ($count backup files)"
                find "$full_path" -name "*.backup*" -delete 2>/dev/null || true
            fi
        fi
    fi
done

# Clean up any leftover problematic backup directories
if [[ "$DRY_RUN" == "false" ]]; then
    # Remove empty .backup directories
    find "$CONFIG_DIR" -type d -name "*.backup" -empty -delete 2>/dev/null || true
fi

echo -e "${GREEN}✅ Cleanup complete!${NC}"

# Optionally run the rebuild
if [[ "$DRY_RUN" == "false" && "$2" == "--rebuild" ]]; then
    echo -e "${GREEN}🔄 Running nixos-rebuild switch...${NC}"
    sudo nixos-rebuild switch --flake .
fi