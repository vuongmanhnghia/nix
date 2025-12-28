#!/usr/bin/env bash
# Script hiển thị thông tin chi tiết về các window đang mở

echo "=== Danh sách Window đang mở trên Hyprland ==="
echo ""

hyprctl clients -j | jq -r '.[] | 
"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Class:     \(.class)
Title:     \(.title)
Workspace: \(.workspace.id)
PID:       \(.pid)
Address:   \(.address)
"' | head -n -1

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "=== Tổng kết ==="
TOTAL=$(hyprctl clients -j | jq '. | length')
UNIQUE=$(hyprctl clients -j | jq -r '.[].class' | sort -u | wc -l)
echo "Tổng số window: $TOTAL"
echo "Số ứng dụng khác nhau: $UNIQUE"
echo ""
echo "=== Danh sách Class (unique) ==="
hyprctl clients -j | jq -r '.[].class' | sort -u | sed 's/^/  • /'
