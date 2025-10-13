#!/usr/bin/env bash
# Script đơn giản nhất để tạo icon substitutions

echo "=== Quickshell Icon Generator ==="
echo ""

# Lấy window classes
WINDOWS=$(hyprctl clients -j 2>/dev/null | jq -r '.[] | .class' 2>/dev/null | sort -u)

if [ -z "$WINDOWS" ]; then
    echo "❌ Không tìm thấy window nào. Hãy mở một số ứng dụng!"
    exit 1
fi

echo "✓ Tìm thấy các ứng dụng:"
echo "$WINDOWS" | sed 's/^/  • /'
echo ""

OUTPUT="/tmp/quickshell_subs.txt"
> "$OUTPUT"

echo "Tạo substitutions..."
echo ""

# Danh sách mapping phổ biến
declare -A COMMON_SUBS
COMMON_SUBS=(
    ["code"]="visual-studio-code"
    ["Code"]="visual-studio-code"
    ["brave-browser"]="brave-desktop"
    ["google-chrome"]="google-chrome"
    ["chromium-browser"]="chromium"
    ["firefox"]="firefox"
    ["discord"]="discord"
    ["Discord"]="discord"
    ["spotify"]="spotify"
    ["Spotify"]="spotify"
    ["obsidian"]="obsidian"
    ["Obsidian"]="obsidian"
    ["telegram"]="telegram-desktop"
    ["slack"]="slack"
    ["kitty"]="kitty"
    ["Alacritty"]="alacritty"
    ["footclient"]="foot"
    ["nautilus"]="org.gnome.Nautilus"
    ["thunar"]="Thunar"
    ["nemo"]="nemo"
    ["pavucontrol-qt"]="pavucontrol"
)

echo "    // === ICON SUBSTITUTIONS (Generated $(date +%Y-%m-%d)) ===" >> "$OUTPUT"

while IFS= read -r class; do
    [ -z "$class" ] && continue
    
    # Kiểm tra trong common subs
    if [ -n "${COMMON_SUBS[$class]:-}" ]; then
        echo "  ✓ $class → ${COMMON_SUBS[$class]}"
        echo "    \"$class\": \"${COMMON_SUBS[$class]}\"," >> "$OUTPUT"
    else
        # Thử lowercase
        lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')
        if [ "$lower" != "$class" ]; then
            echo "  ? $class → $lower (lowercase)"
            echo "    \"$class\": \"$lower\",  // verify this!" >> "$OUTPUT"
        else
            echo "  ? $class → (không rõ, cần kiểm tra)"
            echo "    // \"$class\": \"???\",  // TODO" >> "$OUTPUT"
        fi
    fi
done <<< "$WINDOWS"

echo "    // === END SUBSTITUTIONS ===" >> "$OUTPUT"

echo ""
echo "✓ Đã tạo file: $OUTPUT"
echo ""
echo "==== Nội dung ===="
cat "$OUTPUT"
echo ""
echo "==== Hướng dẫn ===="
echo "1. Mở file: ~/Workspaces/Config/nixos/dotfiles/quickshell/ii/services/AppSearch.qml"
echo "2. Tìm dòng: property var substitutions: ({"
echo "3. Thêm các dòng trên vào trong {...}"
echo "4. Restart Quickshell: Super+R"
