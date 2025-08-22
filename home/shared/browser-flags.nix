# 🌐 BROWSER FLAGS CONFIGURATION
# Optimize browsers for Wayland and performance
{ config, pkgs, ... }:

{
  # Chrome/Chromium flags for Wayland optimization
  home.file.".config/chrome-flags.conf".text = ''
    --password-store=gnome-libsecret
    --ozone-platform-hint=wayland
    --gtk-version=4
    --ignore-gpu-blocklist
    --enable-features=TouchpadOverscrollHistoryNavigation
    --enable-wayland-ime
  '';

  # VS Code flags for Wayland optimization
  home.file.".config/code-flags.conf".text = ''
    --password-store=gnome-libsecret
    --ozone-platform-hint=wayland
    --gtk-version=4
    --ignore-gpu-blocklist
    --enable-features=TouchpadOverscrollHistoryNavigation
    --enable-wayland-ime
  '';

  # Thorium browser flags
  home.file.".config/thorium-flags.conf".text = ''
    --password-store=gnome-libsecret
    --ozone-platform-hint=wayland
    --gtk-version=4
    --ignore-gpu-blocklist
    --enable-features=TouchpadOverscrollHistoryNavigation
  '';
} 