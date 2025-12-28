#!/usr/bin/env bash
# Script đơn giản hơn để kiểm tra icons

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Quickshell Icon Checker ===${NC}\n"

# Lấy danh sách window classes
echo -e "${YELLOW}Đang lấy danh sách window...${NC}"
WINDOWS=$(hyprctl clients -j | jq -r '.[] | .class' | sort -u)

if [ -z "$WINDOWS" ]; then
    echo -e "${RED}Không tìm thấy window nào!${NC}"
    exit 1
fi

echo -e "${GREEN}Tìm thấy $(echo "$WINDOWS" | wc -l) ứng dụng${NC}\n"

OUTPUT_FILE="/tmp/quickshell_substitutions.qml"
> "$OUTPUT_FILE"

echo "    // === AUTO-GENERATED $(date +%Y-%m-%d\ %H:%M) ===" >> "$OUTPUT_FILE"

# Hàm đơn giản kiểm tra icon
check_icon() {
    local name="$1"
    if [ -z "$name" ]; then
        return 1
    fi
    
    # Tìm trong các thư mục icon phổ biến
    find /usr/share/icons /run/current-system/sw/share/icons -type f \
        \( -name "${name}.svg" -o -name "${name}.png" \) 2>/dev/null | head -1 | grep -q . && return 0
    
    return 1
}

while IFS= read -r class; do
    [ -z "$class" ] && continue
    
    echo -n "Checking: $class ... "
    
    # Kiểm tra tên gốc
    if check_icon "$class"; then
        echo -e "${GREEN}OK${NC}"
        continue
    fi
    
    # Thử lowercase
    lowercase=$(echo "$class" | tr '[:upper:]' '[:lower:]')
    if [ "$lowercase" != "$class" ] && check_icon "$lowercase"; then
        echo -e "${YELLOW}→ $lowercase${NC}"
        echo "    \"$class\": \"$lowercase\"," >> "$OUTPUT_FILE"
        continue
    fi
    
    # Thử tìm trong desktop files
    desktop_icon=$(find /usr/share/applications ~/.local/share/applications -name "*.desktop" 2>/dev/null | \
        xargs grep -h "^Icon=" 2>/dev/null | grep -i "$class" | head -1 | cut -d= -f2 | tr -d ' ')
    
    if [ -n "$desktop_icon" ] && check_icon "$desktop_icon"; then
        echo -e "${YELLOW}→ $desktop_icon${NC}"
        echo "    \"$class\": \"$desktop_icon\"," >> "$OUTPUT_FILE"
        continue
    fi
    
    # Một số mapping phổ biến
    case "$class" in
        "code"|"Code")
            echo -e "${YELLOW}→ visual-studio-code${NC}"
            echo "    \"$class\": \"visual-studio-code\"," >> "$OUTPUT_FILE"
            ;;
        "brave-browser")
            echo -e "${YELLOW}→ brave-desktop${NC}"
            echo "    \"$class\": \"brave-desktop\"," >> "$OUTPUT_FILE"
            ;;
        "obsidian")
            echo -e "${YELLOW}→ obsidian${NC}"
            echo "    \"$class\": \"obsidian\"," >> "$OUTPUT_FILE"
            ;;
        *)
            echo -e "${RED}MISSING${NC}"
            echo "    // \"$class\": \"???\",  // TODO: find icon" >> "$OUTPUT_FILE"
            ;;
    esac
    
done <<< "$WINDOWS"

echo "    // === END AUTO-GENERATED ===" >> "$OUTPUT_FILE"

echo ""
echo -e "${GREEN}✓ Hoàn thành!${NC}\n"

if [ -s "$OUTPUT_FILE" ]; then
    echo -e "${BLUE}Nội dung để thêm vào AppSearch.qml:${NC}\n"
    cat "$OUTPUT_FILE"
    echo ""
    echo -e "${BLUE}Đã lưu vào: $OUTPUT_FILE${NC}"
fi
