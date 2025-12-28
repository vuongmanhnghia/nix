#!/usr/bin/env bash
# Script đơn giản để tìm icon của một ứng dụng cụ thể

if [ -z "$1" ]; then
    echo "Usage: $0 <window-class-name>"
    echo "Example: $0 firefox"
    exit 1
fi

CLASS_NAME="$1"

echo "=== Tìm kiếm icon cho: $CLASS_NAME ==="
echo ""

# 1. Tìm trong desktop entries
echo "1. Tìm trong desktop entries..."
DESKTOP_FILES=$(find /usr/share/applications ~/.local/share/applications -name "*.desktop" 2>/dev/null)

# Tìm theo StartupWMClass
MATCH=$(echo "$DESKTOP_FILES" | xargs grep -l "StartupWMClass=$CLASS_NAME" 2>/dev/null | head -1)
if [ -n "$MATCH" ]; then
    echo "   Tìm thấy file: $MATCH"
    ICON=$(grep "^Icon=" "$MATCH" | cut -d= -f2)
    echo "   Icon name: $ICON"
    echo ""
fi

# Tìm theo tên
if [ -z "$MATCH" ]; then
    MATCH=$(echo "$DESKTOP_FILES" | xargs grep -li "Name=.*$CLASS_NAME" 2>/dev/null | head -1)
    if [ -n "$MATCH" ]; then
        echo "   Tìm thấy file (by name): $MATCH"
        ICON=$(grep "^Icon=" "$MATCH" | cut -d= -f2)
        echo "   Icon name: $ICON"
        echo ""
    fi
fi

# 2. Tìm file icon trong hệ thống
echo "2. Tìm file icon trong hệ thống..."
ICON_LOCATIONS=$(find /usr/share/icons /run/current-system/sw/share/icons ~/.local/share/icons ~/.nix-profile/share/icons \
    -type f \( -name "${CLASS_NAME}.svg" -o -name "${CLASS_NAME}.png" -o -name "${CLASS_NAME,,}.svg" -o -name "${CLASS_NAME,,}.png" \) 2>/dev/null | head -5)

if [ -n "$ICON_LOCATIONS" ]; then
    echo "   Tìm thấy:"
    echo "$ICON_LOCATIONS" | sed 's/^/     /'
else
    echo "   Không tìm thấy file icon trực tiếp"
fi

echo ""
echo "3. Các biến thể có thể thử:"
echo "   - ${CLASS_NAME}"
echo "   - ${CLASS_NAME,,}"  # lowercase
echo "   - $(echo "$CLASS_NAME" | sed 's/\([A-Z]\)/-\1/g' | tr '[:upper:]' '[:lower:]' | sed 's/^-//')"  # kebab-case

# Nếu là reverse domain name
if [[ "$CLASS_NAME" == *.*.* ]]; then
    echo "   - $(echo "$CLASS_NAME" | awk -F. '{print $NF}')"  # last part
fi
