# 📦 Quickshell Icon Tools - Summary

## 🎯 Đã tạo thành công!

Bộ công cụ hoàn chỉnh để quản lý và sửa lỗi icon trong Quickshell trên Hyprland.

## 📁 Cấu trúc thư mục

```
scripts/quickshell/
├── menu.sh                      # 🌟 Menu tương tác
├── gen-icon-subs.sh            # 🌟 Generator chính (khuyến nghị)
├── list-current-windows.sh     # Xem windows đang mở
├── find-desktop-icon.sh        # Tìm icon cho 1 app
├── check-window-class.sh       # Kiểm tra class name
├── auto-fix-icons.sh           # Advanced auto-fixer
├── check-icons-simple.sh       # Simple checker
├── QUICKSTART.md               # 📖 Hướng dẫn nhanh
└── README.md                   # 📚 Tài liệu đầy đủ
```

## 🚀 Cách sử dụng nhanh nhất

### Chạy menu tương tác:

```bash
~/Workspaces/Config/nixos/scripts/quickshell/menu.sh
```

### Hoặc chạy trực tiếp:

```bash
# Tạo substitutions tự động
~/Workspaces/Config/nixos/scripts/quickshell/gen-icon-subs.sh

# Xem windows
~/Workspaces/Config/nixos/scripts/quickshell/list-current-windows.sh

# Tìm icon cho app cụ thể
~/Workspaces/Config/nixos/scripts/quickshell/find-desktop-icon.sh discord
```

## ✅ Đã cập nhật

File config đã được cập nhật với substitutions:

```
dotfiles/quickshell/ii/services/AppSearch.qml
```

Các icon đã được map:

-   ✓ brave-browser → brave-desktop
-   ✓ code → visual-studio-code
-   ✓ discord → discord
-   ✓ kitty → kitty
-   ✓ obsidian → obsidian

## 🔄 Áp dụng thay đổi

Sau khi thêm substitutions mới vào AppSearch.qml:

```bash
# Restart Quickshell
Super + R

# Hoặc
pkill quickshell && qs -c ii &
```

## 📖 Tài liệu

-   **Quickstart**: `scripts/quickshell/QUICKSTART.md`
-   **Full docs**: `scripts/quickshell/README.md`

## 💡 Workflow thông thường

1. **Mở app** có icon bị lỗi
2. **Chạy** `gen-icon-subs.sh`
3. **Copy** substitutions vào `AppSearch.qml`
4. **Restart** Quickshell (`Super+R`)
5. **Enjoy!** 🎉

## 🐛 Nếu gặp vấn đề

### Icon vẫn lỗi sau khi thêm substitutions?

-   Kiểm tra đã restart Quickshell chưa
-   Kiểm tra tên icon có đúng không
-   Thử tìm icon trong `/usr/share/icons/`

### Không tìm thấy icon nào?

```bash
# Cài thêm icon themes
sudo nixos-rebuild switch --flake .
# sau khi thêm vào desktop/hyprland.nix:
# - hicolor-icon-theme
# - breeze-icons
# - adwaita-icon-theme
```

### Script không chạy?

```bash
# Kiểm tra quyền thực thi
chmod +x ~/Workspaces/Config/nixos/scripts/quickshell/*.sh
```

## 🎓 Tips

-   Chạy `gen-icon-subs.sh` sau khi cài app mới
-   Backup `AppSearch.qml` trước khi chỉnh sửa
-   Group substitutions theo category
-   Thêm comment cho các mappings đặc biệt

## 📞 Support

Nếu cần thêm mappings cho apps khác, chỉ cần:

1. Mở app đó
2. Chạy menu hoặc gen-icon-subs.sh
3. Follow instructions

---

**Happy Hyprland-ing! 🚀**

Made with ❤️ by GitHub Copilot
