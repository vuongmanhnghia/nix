#!/usr/bin/env bash
# Interactive menu để chọn script

echo "╔═══════════════════════════════════════════════╗"
echo "║   Quickshell Icon Management Tools            ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""
echo "Chọn một công cụ:"
echo ""
echo "  1) 🎯 Tạo icon substitutions tự động (Khuyến nghị)"
echo "  2) 📋 Xem danh sách windows đang mở"
echo "  3) 🔍 Tìm icon cho một app cụ thể"
echo "  4) 📝 Xem hướng dẫn nhanh"
echo "  5) 📚 Xem tài liệu đầy đủ"
echo "  0) ❌ Thoát"
echo ""
read -p "Lựa chọn của bạn [0-5]: " choice

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case $choice in
    1)
        echo ""
        "$SCRIPT_DIR/gen-icon-subs.sh"
        ;;
    2)
        echo ""
        "$SCRIPT_DIR/list-current-windows.sh"
        ;;
    3)
        echo ""
        read -p "Nhập tên class của app (vd: discord, Code): " appname
        if [ -n "$appname" ]; then
            "$SCRIPT_DIR/find-desktop-icon.sh" "$appname"
        else
            echo "❌ Cần nhập tên app!"
        fi
        ;;
    4)
        echo ""
        if [ -f "$SCRIPT_DIR/QUICKSTART.md" ]; then
            cat "$SCRIPT_DIR/QUICKSTART.md" | less
        else
            echo "❌ Không tìm thấy file QUICKSTART.md"
        fi
        ;;
    5)
        echo ""
        if [ -f "$SCRIPT_DIR/README.md" ]; then
            cat "$SCRIPT_DIR/README.md" | less
        else
            echo "❌ Không tìm thấy file README.md"
        fi
        ;;
    0)
        echo "Bye! 👋"
        exit 0
        ;;
    *)
        echo "❌ Lựa chọn không hợp lệ!"
        exit 1
        ;;
esac
