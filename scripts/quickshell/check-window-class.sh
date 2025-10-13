#!/usr/bin/env bash
# Script để kiểm tra window class và icon name của ứng dụng đang chạy

echo "=== Danh sách các window đang mở ==="
echo ""

hyprctl clients -j | jq -r '.[] | "Class: \(.class)\nTitle: \(.title)\nPID: \(.pid)\n---"'

echo ""
echo "=== Hướng dẫn ==="
echo "1. Tìm 'Class' của ứng dụng muốn kiểm tra"
echo "2. Kiểm tra xem icon có tồn tại:"
echo "   gtk-launch --search <class-name>"
echo "3. Hoặc tìm file .desktop:"
echo "   find /usr/share/applications ~/.local/share/applications -name '*.desktop' | xargs grep -l '<class-name>'"
