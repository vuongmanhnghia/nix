# CHEAT SHEET - Quickshell 0.2.0 Fix

## 🚀 Sau mỗi lần update:

```bash
cd ~/Workspaces/Config/nixos/dotfiles/quickshell
./fix-quickshell-0.2.sh
```

**Xong!** Script sẽ tự động fix mọi thứ.

---

## 📋 Chi tiết (nếu muốn biết thêm)

### Script làm gì?

-   Tạo tất cả file `qmldir` (cần cho quickshell 0.2.0)
-   Disable `IdleInhibitor` (API không còn tồn tại)
-   Tạo backup trước khi sửa

### Files nào bị thay đổi?

-   `services/Idle.qml` → có backup `.backup`
-   `modules/sidebarRight/SidebarRightContent.qml` → có backup `.backup`
-   Thêm `qmldir` files (tự động tạo)

### Làm sao biết thành công?

Chạy test:

```bash
cd ii
quickshell -p .
```

Thấy "Configuration Loaded" = thành công ✅

---

## 🔄 Restore về gốc (nếu cần):

```bash
cd ii
cp *.backup *  # restore backups
find . -name "qmldir" -delete  # xóa qmldir
```

---

## ⚠️ Important

-   **KHÔNG** commit file `.backup` và `qmldir`
-   `.gitignore` đã được tạo sẵn
-   Khi upstream support 0.2.0 → không cần script này nữa
