#!/usr/bin/env bash
# Script tự động kiểm tra và tạo danh sách icon substitutions cho Quickshell

set -e

# Màu sắc cho output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Quickshell Icon Fixer ===${NC}\n"

# Thư mục icon themes
ICON_DIRS=(
    "/usr/share/icons"
    "/run/current-system/sw/share/icons"
    "$HOME/.local/share/icons"
    "$HOME/.nix-profile/share/icons"
)

# File output
OUTPUT_FILE="/tmp/quickshell_substitutions.txt"
MISSING_FILE="/tmp/quickshell_missing_icons.txt"

# Xóa file cũ
> "$OUTPUT_FILE"
> "$MISSING_FILE"

echo -e "${YELLOW}Bước 1: Lấy danh sách các window đang mở...${NC}\n"

# Lấy danh sách window classes
WINDOWS=$(hyprctl clients -j | jq -r '.[] | .class' | sort -u)

if [ -z "$WINDOWS" ]; then
    echo -e "${RED}Không tìm thấy window nào. Hãy mở một số ứng dụng trước!${NC}"
    exit 1
fi

echo -e "${GREEN}Tìm thấy các ứng dụng:${NC}"
echo "$WINDOWS" | sed 's/^/  - /'
echo ""

# Hàm kiểm tra icon có tồn tại không
check_icon_exists() {
    local icon_name="$1"
    
    for icon_dir in "${ICON_DIRS[@]}"; do
        if [ -d "$icon_dir" ]; then
            # Tìm file icon với các extension phổ biến
            if find "$icon_dir" -type f \( -name "${icon_name}.svg" -o -name "${icon_name}.png" \) 2>/dev/null | grep -q .; then
                return 0
            fi
        fi
    done
    return 1
}

# Hàm tìm icon phù hợp
find_matching_icon() {
    local class_name="$1"
    local lowercase=$(echo "$class_name" | tr '[:upper:]' '[:lower:]')
    local kebab=$(echo "$class_name" | sed 's/\([A-Z]\)/-\1/g' | tr '[:upper:]' '[:lower:]' | sed 's/^-//')
    
    # Thử các biến thể
    local variants=(
        "$class_name"
        "$lowercase"
        "$kebab"
        "${class_name,,}"  # lowercase bash
    )
    
    # Thử reverse domain name (org.gnome.Calculator -> calculator)
    if [[ "$class_name" == *.*.* ]]; then
        local reverse_domain=$(echo "$class_name" | awk -F. '{print $NF}')
        variants+=("$reverse_domain")
        variants+=("${reverse_domain,,}")
    fi
    
    # Kiểm tra từng variant
    for variant in "${variants[@]}"; do
        if check_icon_exists "$variant"; then
            echo "$variant"
            return 0
        fi
    done
    
    # Tìm trong desktop entries
    local desktop_icon=$(find /usr/share/applications ~/.local/share/applications -name "*.desktop" 2>/dev/null | \
        xargs grep -l "StartupWMClass=$class_name" 2>/dev/null | head -1 | \
        xargs grep "^Icon=" 2>/dev/null | cut -d= -f2)
    
    if [ -n "$desktop_icon" ] && check_icon_exists "$desktop_icon"; then
        echo "$desktop_icon"
        return 0
    fi
    
    # Tìm bằng tên gần đúng trong desktop files
    desktop_icon=$(find /usr/share/applications ~/.local/share/applications -name "*.desktop" 2>/dev/null | \
        xargs grep -i "Name.*$class_name" 2>/dev/null | head -1 | cut -d: -f1 | \
        xargs grep "^Icon=" 2>/dev/null | cut -d= -f2)
    
    if [ -n "$desktop_icon" ] && check_icon_exists "$desktop_icon"; then
        echo "$desktop_icon"
        return 0
    fi
    
    return 1
}

echo -e "${YELLOW}Bước 2: Kiểm tra icon cho từng ứng dụng...${NC}\n"

while IFS= read -r class; do
    [ -z "$class" ] && continue
    
    # Kiểm tra nếu icon tồn tại với tên gốc
    if check_icon_exists "$class"; then
        echo -e "  ${GREEN}✓${NC} $class: Icon tồn tại"
        continue
    fi
    
    # Tìm icon phù hợp
    echo -e "  ${YELLOW}?${NC} $class: Đang tìm icon..."
    
    matched_icon=$(find_matching_icon "$class" 2>/dev/null)
    
    if [ -n "$matched_icon" ]; then
        echo -e "  ${GREEN}✓${NC} $class → $matched_icon"
        echo "    \"$class\": \"$matched_icon\"," >> "$OUTPUT_FILE"
    else
        echo -e "  ${RED}✗${NC} $class: Không tìm thấy icon"
        echo "$class" >> "$MISSING_FILE"
    fi
done <<< "$WINDOWS"

echo ""
echo -e "${YELLOW}Bước 3: Tạo code substitutions...${NC}\n"

if [ -s "$OUTPUT_FILE" ]; then
    echo -e "${GREEN}Tìm thấy $(wc -l < "$OUTPUT_FILE") icon mappings!${NC}\n"
    echo -e "${BLUE}Thêm các dòng sau vào file${NC}"
    echo -e "${BLUE}dotfiles/quickshell/ii/services/AppSearch.qml${NC}"
    echo -e "${BLUE}trong property substitutions:${NC}\n"
    
    echo "property var substitutions: ({"
    echo "    // === AUTO-GENERATED SUBSTITUTIONS ==="
    cat "$OUTPUT_FILE" | sort
    echo "    // === END AUTO-GENERATED ==="
    echo "})"
    echo ""
    
    # Tạo file patch
    PATCH_FILE="/tmp/quickshell_substitutions_patch.txt"
    {
        echo "    // === AUTO-GENERATED SUBSTITUTIONS ($(date +%Y-%m-%d)) ==="
        cat "$OUTPUT_FILE" | sort | sed 's/,$/,/'
        echo "    // === END AUTO-GENERATED ==="
    } > "$PATCH_FILE"
    
    echo -e "${GREEN}✓ Đã lưu vào $PATCH_FILE${NC}"
else
    echo -e "${GREEN}Tất cả các icon đều tồn tại! Không cần substitutions.${NC}"
fi

echo ""

if [ -s "$MISSING_FILE" ]; then
    echo -e "${YELLOW}Cảnh báo: Không tìm thấy icon cho các ứng dụng sau:${NC}"
    cat "$MISSING_FILE" | sed 's/^/  - /'
    echo ""
    echo -e "${BLUE}Gợi ý:${NC}"
    echo "  1. Cài thêm icon themes:"
    echo "     nix-shell -p hicolor-icon-theme breeze-icons adwaita-icon-theme"
    echo "  2. Hoặc tạo custom icons trong ~/.local/share/icons/"
    echo "  3. Hoặc map thủ công sang icon khác"
fi

echo ""
echo -e "${BLUE}=== Thống kê ===${NC}"
echo "  Total windows: $(echo "$WINDOWS" | wc -l)"
echo "  Icons OK: $(echo "$WINDOWS" | wc -l | awk -v missing="$(wc -l < "$MISSING_FILE" 2>/dev/null || echo 0)" '{print $1 - missing}')"
echo "  Need mapping: $(wc -l < "$OUTPUT_FILE" 2>/dev/null || echo 0)"
echo "  Missing: $(wc -l < "$MISSING_FILE" 2>/dev/null || echo 0)"
echo ""

# Tạo backup và apply nếu user muốn
if [ -s "$OUTPUT_FILE" ]; then
    echo -e "${YELLOW}Bạn có muốn tự động apply các thay đổi vào AppSearch.qml? (y/N)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        APPSEARCH_FILE="$HOME/Workspaces/Config/nixos/dotfiles/quickshell/ii/services/AppSearch.qml"
        
        if [ -f "$APPSEARCH_FILE" ]; then
            # Backup
            cp "$APPSEARCH_FILE" "${APPSEARCH_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
            echo -e "${GREEN}✓ Đã backup file gốc${NC}"
            
            echo -e "${BLUE}File đã được backup. Vui lòng thêm substitutions thủ công.${NC}"
            echo -e "${BLUE}Nội dung cần thêm đã được lưu tại: $PATCH_FILE${NC}"
        else
            echo -e "${RED}Không tìm thấy file AppSearch.qml${NC}"
        fi
    fi
fi

echo ""
echo -e "${GREEN}Hoàn thành!${NC}"
