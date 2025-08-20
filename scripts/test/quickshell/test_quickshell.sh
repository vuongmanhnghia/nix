#!/bin/bash

echo "🧪 TESTING QUICKSHELL STARTUP"
echo "=============================="

# Set environment variables
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QML_IMPORT_PATH=/nix/store/*/qml
export QML2_IMPORT_PATH=/nix/store/*/qml

echo "Environment variables set:"
echo "  QT_QPA_PLATFORM=$QT_QPA_PLATFORM"
echo "  QT_WAYLAND_DISABLE_WINDOWDECORATION=$QT_WAYLAND_DISABLE_WINDOWDECORATION"

echo ""
echo "🔍 Checking QuickShell config structure..."
ls -la ~/.config/quickshell/

echo ""
echo "🔍 Checking ii config..."
ls -la ~/.config/quickshell/ii/

echo ""
echo "🚀 Starting QuickShell with debug info..."
echo "Press Ctrl+C to stop"
echo ""

# Try to start QuickShell with maximum verbosity
quickshell -c ii -vv --log-times 2>&1 