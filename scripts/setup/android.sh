#!/usr/bin/env bash
# Manual Android SDK setup for NixOS 25.05

set -e

ANDROID_HOME="$HOME/Android/Sdk"
SDK_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-latest.zip"

echo "🚀 Setting up Android SDK for NixOS 25.05..."

# Create directories
mkdir -p "$ANDROID_HOME"
cd "$ANDROID_HOME"

# Download command line tools if not exists
if [ ! -f "cmdline-tools/latest/bin/sdkmanager" ]; then
    echo "📥 Downloading Android command line tools..."
    wget -O cmdline-tools.zip "$SDK_TOOLS_URL"
    unzip -q cmdline-tools.zip
    
    # Organize the tools properly
    mkdir -p cmdline-tools/latest
    mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
    rm -f cmdline-tools.zip
    
    echo "✅ Command line tools installed"
fi

# Set environment variables
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

echo "📋 Available SDK packages:"
sdkmanager --list | head -20

echo ""
echo "🔧 Installing essential packages..."

# Accept licenses
yes | sdkmanager --licenses 2>/dev/null || true

# Install essential packages
sdkmanager \
    "platform-tools" \
    "platforms;android-34" \
    "platforms;android-35" \
    "build-tools;34.0.0" \
    "build-tools;35.0.0" \
    "emulator" \
    "system-images;android-34;google_apis;x86_64" \
    "system-images;android-35;google_apis;x86_64"

echo ""
echo "📱 Creating default AVD..."
if [ ! -d "$HOME/.android/avd/NixOS_Pixel_API34.avd" ]; then
    echo "no" | avdmanager create avd \
        -n "NixOS_Pixel_API34" \
        -k "system-images;android-34;google_apis;x86_64" \
        -d "pixel_4"
fi

echo ""
echo "✅ Android SDK setup complete!"
echo "📍 ANDROID_HOME: $ANDROID_HOME"
echo "🔧 Available tools:"
echo "   - adb: $(which adb 2>/dev/null || echo 'Add $ANDROID_HOME/platform-tools to PATH')"
echo "   - sdkmanager: $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager"
echo "   - avdmanager: $ANDROID_HOME/cmdline-tools/latest/bin/avdmanager"
echo "   - emulator: $ANDROID_HOME/emulator/emulator"
echo ""
echo "🎯 Next steps:"
echo "   1. Add environment variables to your shell profile"
echo "   2. Open IntelliJ IDEA and configure Android SDK path"
echo "   3. Test emulator: $ANDROID_HOME/emulator/emulator -avd NixOS_Pixel_API34"