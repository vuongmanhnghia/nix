#!/usr/bin/env bash

# Debug script to test theme generation and reload
set -e

echo "🎨 Theme Debug Script"
echo "===================="

# Environment variables
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
MATUGEN_CONFIG="$XDG_CONFIG_HOME/matugen/config.toml"
QUICKSHELL_COLORS="$XDG_STATE_HOME/quickshell/user/generated/colors.json"
NIXOS_COLORS="/home/nagih/Workspaces/Config/nixos/generated/colors.json"
KITTY_COLORS="/home/nagih/Workspaces/Config/nixos/generated/kitty.conf"

# Check if files exist
echo "📁 Checking file paths..."
echo "Matugen config: $MATUGEN_CONFIG"
[ -f "$MATUGEN_CONFIG" ] && echo "✅ Found" || echo "❌ Missing"

echo "Quickshell colors: $QUICKSHELL_COLORS"
[ -f "$QUICKSHELL_COLORS" ] && echo "✅ Found" || echo "❌ Missing"

echo "NixOS colors: $NIXOS_COLORS"
[ -f "$NIXOS_COLORS" ] && echo "✅ Found" || echo "❌ Missing"

echo "Kitty colors: $KITTY_COLORS"
[ -f "$KITTY_COLORS" ] && echo "✅ Found" || echo "❌ Missing"

echo ""

# Check kitty status
echo "🐱 Checking kitty status..."
if pidof kitty >/dev/null 2>&1; then
    echo "✅ Kitty is running"
    
    # Test remote control
    if kitten @ ls >/dev/null 2>&1; then
        echo "✅ Kitty remote control is enabled"
        
        # Test reload
        echo "🔄 Testing kitty reload..."
        if kitten @ load-config 2>/dev/null; then
            echo "✅ Kitty config reloaded via remote control"
        else
            echo "⚠️  Remote control reload failed"
        fi
    else
        echo "⚠️  Kitty remote control is disabled"
        echo "💡 Add 'allow_remote_control = true' to kitty.conf"
    fi
else
    echo "❌ Kitty is not running"
fi

echo ""

# Check quickshell process
echo "🚀 Checking quickshell status..."
if pgrep -f "quickshell.*ii" > /dev/null; then
    echo "✅ Quickshell is running"
    
    # Enable debug mode
    echo "🔧 Enabling MaterialThemeLoader debug mode..."
    quickshell -i ~/.config/quickshell/ii --socket=/tmp/quickshell/ii-socket --ipc debugMode true 2>/dev/null || \
        echo "⚠️  Could not enable debug mode"
    
    # Test theme reload
    echo "🔄 Testing theme reload..."
    quickshell -i ~/.config/quickshell/ii --socket=/tmp/quickshell/ii-socket --ipc reloadTheme 2>/dev/null && \
        echo "✅ Theme reload command sent" || \
        echo "❌ Could not send reload command"
else
    echo "❌ Quickshell is not running"
fi

echo ""

# Check matugen
echo "🎨 Testing matugen..."
if command -v matugen >/dev/null 2>&1; then
    echo "✅ Matugen is available"
    
    # Test with a sample color
    echo "🧪 Testing color generation..."
    TEST_COLOR="#3498db"
    matugen color "$TEST_COLOR" --mode dark 2>/dev/null && \
        echo "✅ Matugen color generation works" || \
        echo "❌ Matugen test failed"
else
    echo "❌ Matugen not found"
fi

echo ""

# Show color file contents if available
if [ -f "$QUICKSHELL_COLORS" ]; then
    echo "📋 Current quickshell colors (first 5 lines):"
    head -5 "$QUICKSHELL_COLORS"
    echo "..."
    echo ""
fi

if [ -f "$NIXOS_COLORS" ]; then
    echo "📋 Current NixOS colors (first 5 lines):"
    head -5 "$NIXOS_COLORS"
    echo "..."
    echo ""
fi

if [ -f "$KITTY_COLORS" ]; then
    echo "📋 Current kitty colors (first 5 lines):"
    head -5 "$KITTY_COLORS"
    echo "..."
    echo ""
fi

# Test file watching
echo "🔍 File watching test..."
if [ -f "$QUICKSHELL_COLORS" ]; then
    echo "Original file modification time:"
    stat -f "%Sm" "$QUICKSHELL_COLORS" 2>/dev/null || stat -c "%y" "$QUICKSHELL_COLORS" 2>/dev/null || echo "Could not get file time"
    
    # Touch the file to trigger watch
    echo "Triggering file change..."
    touch "$QUICKSHELL_COLORS"
    
    sleep 1
    echo "New file modification time:"
    stat -f "%Sm" "$QUICKSHELL_COLORS" 2>/dev/null || stat -c "%y" "$QUICKSHELL_COLORS" 2>/dev/null || echo "Could not get file time"
fi

echo ""
echo "🎯 Recommendations:"
echo "1. Run 'journalctl -f -u home-manager-nagih.service' to see home-manager logs"
echo "2. Run quickshell with debug output: 'quickshell -i ~/.config/quickshell/ii --verbose'"
echo "3. Test wallpaper change: '~/.config/quickshell/ii/scripts/colors/switchwall.sh --image /path/to/image'"
echo "4. Check symlinks: 'ls -la ~/.local/state/quickshell/user/generated/'"
echo "5. Test kitty reload specifically: '~/.config/scripts/test-kitty-reload.sh'"
echo ""
echo "✨ Debug complete!" 