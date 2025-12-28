# Quickshell 0.2.0 Migration Guide

## Quick Fix Script

Chạy script này sau mỗi lần update từ repo gốc:

```bash
cd /home/nagih/Workspaces/Config/nixos/dotfiles/quickshell
./fix-quickshell-0.2.sh
```

## Các thay đổi bắt buộc

### 1. Tự động tạo qmldir files

Script sẽ tự động tạo tất cả file `qmldir` cần thiết cho quickshell 0.2.0

### 2. Fix IdleInhibitor (API không còn tồn tại)

-   **File**: `ii/services/Idle.qml` (line 14, 33-47)
-   **File**: `ii/modules/sidebarRight/SidebarRightContent.qml` (line 140)
-   **Thay đổi**: Comment out hoặc disable IdleInhibitor

## Kiểm tra

```bash
cd ii
quickshell -p .
```

Nếu thấy "Configuration Loaded" → thành công!

## Notes

-   Warnings về EGL/icons là bình thường
-   IdleInhibitor cần tìm replacement trong tương lai
