#!/usr/bin/env bash

echo "==================================="
echo "Discord Screen Share Debug Script"
echo "==================================="
echo ""

# 1. Check if PipeWire is running
echo "📹 [1/10] Checking PipeWire status..."
if systemctl --user is-active --quiet pipewire; then
    echo "✅ PipeWire is running"
else
    echo "❌ PipeWire is NOT running"
fi

if systemctl --user is-active --quiet wireplumber; then
    echo "✅ WirePlumber is running"
else
    echo "❌ WirePlumber is NOT running"
fi
echo ""

# 2. Check XDG Desktop Portal
echo "🔌 [2/10] Checking XDG Desktop Portal..."
if systemctl --user is-active --quiet xdg-desktop-portal; then
    echo "✅ xdg-desktop-portal is running"
else
    echo "❌ xdg-desktop-portal is NOT running"
fi

if systemctl --user is-active --quiet xdg-desktop-portal-hyprland; then
    echo "✅ xdg-desktop-portal-hyprland is running"
else
    echo "❌ xdg-desktop-portal-hyprland is NOT running"
fi
echo ""

# 3. Check portal configuration
echo "⚙️  [3/10] Checking portal configuration..."
if [ -f "$HOME/.config/xdg-desktop-portal/portals.conf" ] || [ -f "/etc/xdg-desktop-portal/portals.conf" ]; then
    echo "Portal config exists:"
    cat "$HOME/.config/xdg-desktop-portal/portals.conf" 2>/dev/null || cat "/etc/xdg-desktop-portal/portals.conf" 2>/dev/null
else
    echo "⚠️  No portal configuration found"
fi
echo ""

# 4. Check environment variables
echo "🌍 [4/10] Checking environment variables..."
echo "XDG_CURRENT_DESKTOP: ${XDG_CURRENT_DESKTOP:-not set}"
echo "XDG_SESSION_TYPE: ${XDG_SESSION_TYPE:-not set}"
echo "WAYLAND_DISPLAY: ${WAYLAND_DISPLAY:-not set}"
echo "NIXOS_OZONE_WL: ${NIXOS_OZONE_WL:-not set}"
echo ""

# 5. Check PipeWire nodes
echo "🎬 [5/10] Checking PipeWire video nodes..."
if command -v pw-cli &> /dev/null; then
    echo "Available video sources:"
    pw-cli list-objects | grep -A 5 "media.class.*Video"
else
    echo "⚠️  pw-cli not found"
fi
echo ""

# 6. Test portal implementation
echo "🧪 [6/10] Testing portal screencast implementation..."
if command -v gdbus &> /dev/null; then
    gdbus introspect --session --dest org.freedesktop.portal.Desktop --object-path /org/freedesktop/portal/desktop 2>&1 | grep -i screencast
else
    echo "⚠️  gdbus not found"
fi
echo ""

# 7. Check for conflicts
echo "🔍 [7/10] Checking for conflicting processes..."
CONFLICTS=$(ps aux | grep -E "xdg-desktop-portal|easyeffects" | grep -v grep)
if [ -n "$CONFLICTS" ]; then
    echo "$CONFLICTS"
else
    echo "✅ No obvious conflicts"
fi
echo ""

# 8. Check Discord process
echo "💬 [8/10] Checking Discord process..."
DISCORD_PID=$(pgrep -f discord)
if [ -n "$DISCORD_PID" ]; then
    echo "✅ Discord is running (PID: $DISCORD_PID)"
    echo "Discord command line:"
    ps -p $DISCORD_PID -o args=
else
    echo "⚠️  Discord is not running"
fi
echo ""

# 9. Check recent errors in journal
echo "📋 [9/10] Recent errors from journal (last 2 minutes)..."
journalctl --user --since "2 minutes ago" | grep -iE "error|fail|portal|pipewire|discord" | tail -20
echo ""

# 10. Recommendations
echo "💡 [10/10] Recommendations:"
echo "-----------------------------------"

ISSUES=0

if ! systemctl --user is-active --quiet pipewire; then
    echo "❌ Start PipeWire: systemctl --user start pipewire wireplumber"
    ((ISSUES++))
fi

if ! systemctl --user is-active --quiet xdg-desktop-portal-hyprland; then
    echo "❌ Start portal: systemctl --user start xdg-desktop-portal-hyprland"
    ((ISSUES++))
fi

if [ "$XDG_CURRENT_DESKTOP" != "Hyprland" ]; then
    echo "⚠️  XDG_CURRENT_DESKTOP should be 'Hyprland', currently: ${XDG_CURRENT_DESKTOP:-not set}"
    ((ISSUES++))
fi

if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
    echo "⚠️  XDG_SESSION_TYPE should be 'wayland', currently: ${XDG_SESSION_TYPE:-not set}"
    ((ISSUES++))
fi

if [ -z "$WAYLAND_DISPLAY" ]; then
    echo "⚠️  WAYLAND_DISPLAY is not set"
    ((ISSUES++))
fi

if systemctl --user is-active --quiet easyeffects; then
    echo "❌ Stop EasyEffects: systemctl --user stop easyeffects"
    ((ISSUES++))
fi

if [ $ISSUES -eq 0 ]; then
    echo "✅ No obvious issues found. Try these manual tests:"
    echo "   1. Run: discord-screenshare (or discord with flags)"
    echo "   2. Try to share screen"
    echo "   3. Monitor: journalctl --user -f | grep -iE 'portal|pipewire|discord'"
fi

echo ""
echo "==================================="
echo "Debug complete!"
echo "==================================="