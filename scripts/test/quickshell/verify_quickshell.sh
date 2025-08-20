#!/bin/bash

# Script kiểm tra QuickShell
echo "🔍 KIỂM TRA QUICKSHELL INSTALLATION & CONFIGURATION"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if QuickShell binary exists
echo -e "\n${BLUE}1. Kiểm tra QuickShell binary${NC}"
if command -v quickshell >/dev/null 2>&1; then
    QUICKSHELL_VERSION=$(quickshell --version 2>/dev/null || echo "unknown")
    print_success "QuickShell binary được tìm thấy: $QUICKSHELL_VERSION"
    QUICKSHELL_PATH=$(which quickshell)
    print_info "Path: $QUICKSHELL_PATH"
else
    print_error "QuickShell binary không được tìm thấy trong PATH"
    echo "  Hãy đảm bảo QuickShell đã được cài đặt đúng cách trong NixOS"
    exit 1
fi

# Check configuration symlink
echo -e "\n${BLUE}2. Kiểm tra configuration symlink${NC}"
CONFIG_DIR="$HOME/.config/quickshell"
if [ -L "$CONFIG_DIR" ]; then
    TARGET=$(readlink "$CONFIG_DIR")
    if [ -d "$TARGET" ]; then
        print_success "Symlink ~/.config/quickshell hoạt động đúng"
        print_info "Target: $TARGET"
    else
        print_error "Symlink target không tồn tại: $TARGET"
        exit 1
    fi
elif [ -d "$CONFIG_DIR" ]; then
    print_warning "~/.config/quickshell là thư mục thật (không phải symlink)"
else
    print_error "~/.config/quickshell không tồn tại"
    exit 1
fi

# Check main configuration files
echo -e "\n${BLUE}3. Kiểm tra các file cấu hình chính${NC}"
MAIN_FILES=(
    "$CONFIG_DIR/ii/shell.qml"
    "$CONFIG_DIR/ii/settings.qml"
    "$CONFIG_DIR/ii/GlobalStates.qml"
)

for file in "${MAIN_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "$(basename "$file") tồn tại"
    else
        print_error "File không tồn tại: $file"
    fi
done

# Check modules directory
echo -e "\n${BLUE}4. Kiểm tra modules${NC}"
MODULES_DIR="$CONFIG_DIR/ii/modules"
if [ -d "$MODULES_DIR" ]; then
    MODULE_COUNT=$(find "$MODULES_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)
    print_success "Thư mục modules tồn tại với $MODULE_COUNT modules"
    
    # List available modules
    print_info "Modules có sẵn:"
    for module in "$MODULES_DIR"/*/; do
        if [ -d "$module" ]; then
            module_name=$(basename "$module")
            echo "    • $module_name"
        fi
    done
else
    print_error "Thư mục modules không tồn tại"
fi

# Check services directory
echo -e "\n${BLUE}5. Kiểm tra services${NC}"
SERVICES_DIR="$CONFIG_DIR/ii/services"
if [ -d "$SERVICES_DIR" ]; then
    SERVICE_COUNT=$(find "$SERVICES_DIR" -name "*.qml" -type f | wc -l)
    print_success "Thư mục services tồn tại với $SERVICE_COUNT services"
else
    print_error "Thư mục services không tồn tại"
fi

# Test QuickShell configuration syntax
echo -e "\n${BLUE}6. Kiểm tra syntax configuration${NC}"
print_info "Đang kiểm tra syntax các file QML..."

# Check if we can validate QML files
if command -v qmllint >/dev/null 2>&1; then
    print_info "Sử dụng qmllint để kiểm tra syntax..."
    SYNTAX_ERRORS=0
    
    for qml_file in $(find "$CONFIG_DIR" -name "*.qml" -type f); do
        if ! qmllint "$qml_file" >/dev/null 2>&1; then
            print_warning "Syntax warning trong: $(basename "$qml_file")"
            SYNTAX_ERRORS=$((SYNTAX_ERRORS + 1))
        fi
    done
    
    if [ $SYNTAX_ERRORS -eq 0 ]; then
        print_success "Không có syntax error được tìm thấy"
    else
        print_warning "$SYNTAX_ERRORS files có syntax warnings"
    fi
else
    print_warning "qmllint không có sẵn, bỏ qua kiểm tra syntax"
fi

# Test QuickShell dry-run (if supported)
echo -e "\n${BLUE}7. Test QuickShell dry-run${NC}"
print_info "Đang thử chạy QuickShell để kiểm tra cấu hình..."

# Try to run QuickShell with validation
if quickshell --help 2>&1 | grep -q "\--validate\|--dry-run\|--check"; then
    print_info "Chạy quickshell validation..."
    if quickshell --validate 2>/dev/null || quickshell --dry-run 2>/dev/null || quickshell --check 2>/dev/null; then
        print_success "QuickShell validation thành công"
    else
        print_error "QuickShell validation thất bại"
    fi
else
    print_info "QuickShell không hỗ trợ dry-run mode"
fi

# Check required dependencies
echo -e "\n${BLUE}8. Kiểm tra dependencies${NC}"
DEPS=("qmlscene" "qt6-qml" "qt6-quickcontrols2")

for dep in "${DEPS[@]}"; do
    if command -v "$dep" >/dev/null 2>&1 || rpm -qa | grep -q "$dep" || dpkg -l | grep -q "$dep" || nix-env -q | grep -q "$dep"; then
        print_success "$dep có sẵn"
    else
        print_warning "$dep có thể chưa được cài đặt"
    fi
done

# Check if QuickShell is running
echo -e "\n${BLUE}9. Kiểm tra QuickShell process${NC}"
if pgrep -f quickshell >/dev/null; then
    QUICKSHELL_PID=$(pgrep -f quickshell)
    print_success "QuickShell đang chạy (PID: $QUICKSHELL_PID)"
    
    # Get memory usage
    if command -v ps >/dev/null 2>&1; then
        MEMORY_USAGE=$(ps -p "$QUICKSHELL_PID" -o pid,ppid,rss,vsz,cmd --no-headers 2>/dev/null)
        if [ -n "$MEMORY_USAGE" ]; then
            print_info "Memory usage: $MEMORY_USAGE"
        fi
    fi
else
    print_warning "QuickShell không đang chạy"
    print_info "Để khởi động: quickshell"
fi

# Summary
echo -e "\n${BLUE}📋 TỔNG KẾT${NC}"
echo "============"

if [ -f "$CONFIG_DIR/ii/shell.qml" ] && command -v quickshell >/dev/null 2>&1; then
    print_success "QuickShell đã được cài đặt và cấu hình đúng cách"
    
    echo -e "\n${YELLOW}💡 HƯỚNG DẪN SỬ DỤNG:${NC}"
    echo "1. Để khởi động QuickShell: quickshell"
    echo "2. Để xem settings: quickshell --settings"
    echo "3. Để reload configuration: quickshell --reload"
    echo "4. File cấu hình chính: ~/.config/quickshell/ii/shell.qml"
    echo "5. Để tùy chỉnh modules: chỉnh sửa các file trong ~/.config/quickshell/ii/modules/"
    
    echo -e "\n${YELLOW}🔧 KIỂM TRA THÊM:${NC}"
    echo "• Kiểm tra log errors: journalctl --user -f -u quickshell"
    echo "• Monitor process: htop (tìm quickshell)"
    echo "• Test modules riêng lẻ trong settings app"
    
else
    print_error "QuickShell chưa được cấu hình hoàn chỉnh"
    echo "Vui lòng kiểm tra lại các bước cài đặt"
fi

echo -e "\n${GREEN}✨ Script hoàn thành!${NC}" 