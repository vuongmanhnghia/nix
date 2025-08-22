#!/usr/bin/env bash

echo "🐱 Kitty Theme Reload Test"
echo "========================="

# Check if kitty is running
if ! pidof kitty >/dev/null 2>&1; then
    echo "❌ Kitty is not running. Please start kitty first."
    exit 1
fi

echo "✅ Kitty is running"

# Auto-detect socket
echo "🔌 Auto-detecting socket..."
SOCKET_PATH=""
for socket in /tmp/kitty-socket*; do
    if [ -S "$socket" ]; then
        SOCKET_PATH="$socket"
        echo "✅ Found socket: $socket"
        break
    fi
done

if [ -z "$SOCKET_PATH" ]; then
    echo "⚠️  No socket found, trying auto-detection"
    SOCKET_METHOD=""
else
    SOCKET_METHOD="--to unix:$SOCKET_PATH"
fi

# Check if remote control is enabled
echo "🔧 Testing remote control..."
if kitten @ $SOCKET_METHOD ls >/dev/null 2>&1; then
    echo "✅ Remote control is enabled"
else
    echo "❌ Remote control is disabled or not working"
    echo "💡 Make sure 'allow_remote_control = true' is set in kitty.conf"
    echo "💡 Or try: kill -SIGUSR1 \$(pidof kitty)"
    
    # Try fallback without socket
    if kitten @ ls >/dev/null 2>&1; then
        echo "✅ Remote control works without socket"
        SOCKET_METHOD=""
    else
        exit 1
    fi
fi

# Test current colors
echo "🎨 Current kitty colors:"
kitten @ $SOCKET_METHOD get-colors 2>/dev/null | head -5 || echo "Could not get current colors"

echo ""

# Test config reload
echo "🔄 Testing config reload..."
if kitten @ $SOCKET_METHOD load-config 2>/dev/null; then
    echo "✅ Config reloaded successfully via remote control"
else
    echo "⚠️  Remote control failed, trying signal..."
    if kill -SIGUSR1 $(pidof kitty) 2>/dev/null; then
        echo "✅ Config reloaded via SIGUSR1 signal"
    else
        echo "❌ Both methods failed"
        exit 1
    fi
fi

echo ""
echo "🎯 Test completed! Kitty should have reloaded its theme."
echo "💡 If colors didn't change, check that the kitty.conf file includes the generated colors." 