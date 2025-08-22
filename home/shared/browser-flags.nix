# 🌐 BROWSER FLAGS CONFIGURATION
# Optimize browsers for Wayland and performance
{ config, pkgs, ... }:

{
  # Chrome/Chromium flags for Wayland optimization
  xdg.configFile."chrome-flags.conf".text = ''
    --password-store=gnome-libsecret
    --ozone-platform-hint=wayland
    --gtk-version=4
    --ignore-gpu-blocklist
    --enable-features=TouchpadOverscrollHistoryNavigation
    --enable-wayland-ime
  '';

  # VS Code flags for Wayland optimization
  xdg.configFile."code-flags.conf".text = ''
    --password-store=gnome-libsecret
    --ozone-platform-hint=wayland
    --gtk-version=4
    --ignore-gpu-blocklist
    --enable-features=TouchpadOverscrollHistoryNavigation
    --enable-wayland-ime
  '';

  # Thorium browser flags
  xdg.configFile."thorium-flags.conf".text = ''
    --password-store=gnome-libsecret
    --ozone-platform-hint=wayland
    --gtk-version=4
    --ignore-gpu-blocklist
    --enable-features=TouchpadOverscrollHistoryNavigation
  '';
} 