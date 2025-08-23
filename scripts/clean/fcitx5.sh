#!/run/current-system/sw/bin/bash

echo "Cleaning up Fcitx5..."

# Remove all Fcitx5 cache files
rm -rf ~/.config/fcitx5/
rm -rf ~/.cache/fcitx5/
rm -rf ~/.local/share/fcitx5/

echo "Fcitx5 cleanup complete."
