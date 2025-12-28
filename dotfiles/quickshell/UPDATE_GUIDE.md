# Quickshell Update Workflow

## Khi cập nhật từ repo gốc

```bash
cd /home/nagih/Workspaces/Config/nixos/dotfiles/quickshell

# 1. Pull update từ repo gốc
git pull upstream main  # hoặc command update của bạn

# 2. Áp dụng fixes cho quickshell 0.2.0
./fix-quickshell-0.2.sh

# 3. Test
cd ii
quickshell -p .
```

## Khôi phục về bản gốc (nếu cần)

```bash
cd ii
# Khôi phục từ backup
cp services/Idle.qml.backup services/Idle.qml
cp modules/sidebarRight/SidebarRightContent.qml.backup modules/sidebarRight/SidebarRightContent.qml

# Xóa qmldir files
find . -name "qmldir" -delete
```

## Tóm tắt thay đổi

### Files được tạo tự động (có thể xóa và tạo lại):

-   Tất cả file `qmldir` trong các thư mục modules

### Files bị sửa đổi (có backup .backup):

-   `services/Idle.qml`: Disable IdleInhibitor (API deprecated)
-   `modules/sidebarRight/SidebarRightContent.qml`: Comment IdleInhibitor usage

### Lý do thay đổi:

Quickshell 0.2.0 có breaking changes:

1. Yêu cầu `qmldir` files cho module system
2. `IdleInhibitor` API không còn tồn tại

### Tương lai:

Khi repo gốc cập nhật hỗ trợ quickshell 0.2.0, có thể không cần script này nữa.
