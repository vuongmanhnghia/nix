# 🔧 Quick Fix cho Quickshell 0.2.0

## TL;DR - Chạy ngay sau khi update

```bash
./fix-quickshell-0.2.sh
```

## Vấn đề

Quickshell 0.2.0 có breaking changes:

-   ❌ Thiếu `qmldir` files → Module không load được
-   ❌ `IdleInhibitor` API không còn tồn tại

## Giải pháp

Script `fix-quickshell-0.2.sh` sẽ:

1. ✅ Tự động tạo tất cả `qmldir` files
2. ✅ Disable `IdleInhibitor` (với backup)
3. ✅ Không ảnh hưởng logic code chính

## Usage

### Sau mỗi lần update từ repo gốc:

```bash
git pull upstream main
./fix-quickshell-0.2.sh
cd ii && quickshell -p .
```

### Khôi phục về gốc (nếu cần):

```bash
cd ii
cp services/Idle.qml.backup services/Idle.qml
cp modules/sidebarRight/SidebarRightContent.qml.backup modules/sidebarRight/SidebarRightContent.qml
find . -name "qmldir" -delete
```

## Files thay đổi

**Tự động tạo** (có thể xóa/tạo lại):

-   `qmldir` trong tất cả module folders

**Tự động sửa** (có backup):

-   `services/Idle.qml`
-   `modules/sidebarRight/SidebarRightContent.qml`

## Note

⚠️ Khi repo gốc hỗ trợ quickshell 0.2.0, script này sẽ không cần nữa!
