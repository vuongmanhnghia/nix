#!/run/current-system/sw/bin/bash

# Generate Themes & Colors

echo "Generating themes & colors..."

cp -r ./home/shared/matugen/templates/colors.json ./generated/colors.json
cp -r ./home/shared/matugen/templates/hyprland/colors.conf ./generated/hyprland.conf
cp -r ./home/shared/matugen/templates/hyprland/hyprlock-colors.conf ./generated/hyprlock.conf
cp -r ./home/shared/matugen/templates/fuzzel/fuzzel_theme.ini ./generated/fuzzel_theme.ini
cp -r ./home/shared/matugen/templates/gtk/gtk-colors.css ./generated/gtk-3.0.css
cp -r ./home/shared/matugen/templates/gtk/gtk-colors.css ./generated/gtk-4.0.css
cp -r ./home/shared/matugen/templates/kde/color.txt ./generated/kde.txt
cp -r ./home/shared/matugen/templates/wallpaper.txt ./generated/wallpaper.txt

cp -r ./home/shared/matugen/templates/colors.css ./generated/waybar.css
cp -r ./home/shared/matugen/templates/colors.css ./generated/swaync.css
cp -r ./home/shared/matugen/templates/kitty.conf ./generated/kitty.conf
cp -r ./home/shared/matugen/templates/rofi.rasi ./generated/rofi.rasi
cp -r ./home/shared/matugen/templates/cava.config ./generated/cava.config
echo "Done!"