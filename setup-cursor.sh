#!/bin/bash

# Create symlinks for apple cursor themes
mkdir -p ~/.icons
ln -sf /nix/store/6ib5v62nvj95kc9b1ggi8qk9d2y6ccil-apple_cursor-2.0.1/share/icons/macOS ~/.icons/
ln -sf /nix/store/6ib5v62nvj95kc9b1ggi8qk9d2y6ccil-apple_cursor-2.0.1/share/icons/macOS-White ~/.icons/

# Set cursor theme
hyprctl setcursor macOS 24

# Thông báo
echo "Cursor theme đã được set thành macOS (apple-cursor)!"
echo "Nếu bạn muốn thay đổi vĩnh viễn, hãy đảm bảo lệnh này được thêm vào autostart.nix" 