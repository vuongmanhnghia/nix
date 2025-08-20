#!/run/current-system/sw/bin/bash

# Generate Themes & Colors

echo "Generating themes & colors..."

rm -rf ./generated
mkdir -p ./generated

echo "Generating colors.json..."
cp -r ./home/shared/matugen/templates/colors.json ./generated/colors.json

bash ./scripts/generate/hyprland.sh

echo "Generating hyprlock.conf..."
cp -r ./home/shared/matugen/templates/hyprland/hyprlock-colors.conf ./generated/hyprlock.conf

echo "Generating fuzzel_theme.ini..."
cp -r ./home/shared/matugen/templates/fuzzel/fuzzel_theme.ini ./generated/fuzzel_theme.ini

echo "Generating gtk-3.0.css..."
cp -r ./home/shared/matugen/templates/gtk/gtk-colors.css ./generated/gtk-3.0.css
cp -r ./home/shared/matugen/templates/gtk/gtk-colors.css ./generated/gtk-4.0.css

echo "Generating kde.txt..."
cp -r ./home/shared/matugen/templates/kde/color.txt ./generated/kde.txt

echo "Generating wallpaper.txt..."
cp -r ./home/shared/matugen/templates/wallpaper.txt ./generated/wallpaper.txt

bash ./scripts/generate/waybar.sh

bash ./scripts/generate/swaync.sh

bash ./scripts/generate/kitty.sh

bash ./scripts/generate/rofi.sh

bash ./scripts/generate/cava.sh

echo "Done!"