#!/bin/bash

echo "🔧 FIXING QUICKSHELL NOTIFICATION CONFLICT"
echo "=========================================="

CONFIG_FILE="$HOME/.config/illogical-impulse/config.json"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

if [ ! -f "$CONFIG_FILE" ]; then
    print_warning "Config file không tồn tại: $CONFIG_FILE"
    print_info "Tạo config file mới..."
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo '{}' > "$CONFIG_FILE"
fi

print_info "Cập nhật config để tự động kill notification daemons conflicts..."

# Update config to auto kill notification daemons
jq '.conflictKiller.autoKillNotificationDaemons = true | .conflictKiller.autoKillTrays = true' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

print_success "Đã cập nhật config!"

echo ""
print_info "Config hiện tại:"
jq '.conflictKiller' "$CONFIG_FILE" 2>/dev/null || echo "Chưa có section conflictKiller"

echo ""
print_warning "Giải thích:"
echo "• autoKillNotificationDaemons = true: Tự động kill mako/dunst conflicts"
echo "• autoKillTrays = true: Tự động kill kded6 tray conflicts"
echo "• Điều này sẽ tránh dialog xuất hiện mỗi lần rebuild"

echo ""
print_info "Restart QuickShell để áp dụng config mới:"
echo "pkill quickshell && qs -c ii &" 