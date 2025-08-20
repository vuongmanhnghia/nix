#!/bin/bash

echo "🚀 QUICKSHELL GRADUAL SETUP"
echo "============================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "\n${BLUE}$1${NC}"
    echo "$(printf '=%.0s' {1..40})"
}

print_step "STEP 1: Create Basic Panel"
cat > /tmp/quickshell_step1.qml << 'EOF'
import QtQuick
import Quickshell

ShellRoot {
    PanelWindow {
        id: panel
        anchors {
            left: true
            right: true
            top: true
        }
        
        height: 30
        color: "rgba(0, 0, 0, 0.8)"
        
        Text {
            anchors.centerIn: parent
            text: "QuickShell Step 1 - Basic Panel - " + new Date().toLocaleTimeString()
            color: "white"
            font.pixelSize: 12
            
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: parent.text = "QuickShell Step 1 - Basic Panel - " + new Date().toLocaleTimeString()
            }
        }
    }
}
EOF

echo "Testing Step 1 - Basic Panel..."
if timeout 5s quickshell -p /tmp/quickshell_step1.qml -v > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Step 1 PASSED - Basic panel works${NC}"
else
    echo -e "${RED}✗ Step 1 FAILED - Basic panel doesn't work${NC}"
    echo "Check your QuickShell installation"
    exit 1
fi

print_step "STEP 2: Add Simple Background"
cat > /tmp/quickshell_step2.qml << 'EOF'
import QtQuick
import Quickshell

ShellRoot {
    // Background window
    PanelWindow {
        id: background
        anchors {
            left: true
            right: true
            top: true
            bottom: true
        }
        
        layer: "background"
        color: "rgba(20, 20, 30, 0.3)"
        
        Text {
            anchors.centerIn: parent
            text: "Background Layer"
            color: "rgba(255, 255, 255, 0.5)"
            font.pixelSize: 48
        }
    }
    
    // Top panel
    PanelWindow {
        id: panel
        anchors {
            left: true
            right: true
            top: true
        }
        
        height: 35
        color: "rgba(0, 0, 0, 0.9)"
        
        Row {
            anchors.centerIn: parent
            spacing: 20
            
            Text {
                text: "QuickShell Step 2"
                color: "white"
                font.pixelSize: 14
            }
            
            Text {
                text: new Date().toLocaleTimeString()
                color: "#88ff88"
                font.pixelSize: 12
                
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: parent.text = new Date().toLocaleTimeString()
                }
            }
        }
    }
}
EOF

echo "Testing Step 2 - Panel + Background..."
if timeout 5s quickshell -p /tmp/quickshell_step2.qml -v > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Step 2 PASSED - Panel + Background works${NC}"
else
    echo -e "${RED}✗ Step 2 FAILED - Panel + Background doesn't work${NC}"
fi

print_step "STEP 3: Test ii Config with Minimal Modules"
# Create a minimal version of ii config
mkdir -p /tmp/quickshell_test_ii
cat > /tmp/quickshell_test_ii/shell.qml << 'EOF'
//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import QtQuick.Window
import Quickshell

ShellRoot {
    // Disable all complex modules
    property bool enableBar: false
    property bool enableBackground: true
    property bool enableCheatsheet: false
    property bool enableDock: false
    property bool enableLock: false
    property bool enableMediaControls: false
    property bool enableNotificationPopup: false
    property bool enableOnScreenDisplayBrightness: false
    property bool enableOnScreenDisplayVolume: false
    property bool enableOnScreenKeyboard: false
    property bool enableOverview: false
    property bool enableReloadPopup: false
    property bool enableScreenCorners: false
    property bool enableSession: false
    property bool enableSidebarLeft: false
    property bool enableSidebarRight: false
    property bool enableVerticalBar: false

    // Simple test panel
    PanelWindow {
        id: testPanel
        anchors {
            left: true
            right: true
            top: true
        }
        
        height: 40
        color: "rgba(30, 30, 50, 0.9)"
        
        Text {
            anchors.centerIn: parent
            text: "QuickShell II Config (Minimal) - " + new Date().toLocaleTimeString()
            color: "white"
            font.pixelSize: 14
            
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: parent.text = "QuickShell II Config (Minimal) - " + new Date().toLocaleTimeString()
            }
        }
    }
}
EOF

echo "Testing Step 3 - ii Config Minimal..."
if timeout 5s quickshell -p /tmp/quickshell_test_ii -v > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Step 3 PASSED - ii config minimal works${NC}"
else
    echo -e "${RED}✗ Step 3 FAILED - ii config minimal doesn't work${NC}"
fi

print_step "FINAL RECOMMENDATIONS"
echo -e "${YELLOW}Based on the test results:${NC}"
echo ""
echo "1. If Step 1-2 passed: QuickShell basic functionality works"
echo "2. If Step 3 failed: The ii config has dependency issues"
echo ""
echo -e "${BLUE}SOLUTIONS:${NC}"
echo "• Use the working configs from /tmp/quickshell_step1.qml or /tmp/quickshell_step2.qml"
echo "• Gradually enable modules in the ii config one by one"
echo "• Check missing system dependencies for complex services"
echo ""
echo -e "${GREEN}To start with a working config:${NC}"
echo "  quickshell -p /tmp/quickshell_step2.qml"
echo ""
echo -e "${YELLOW}To debug the original ii config:${NC}"
echo "  quickshell -c ii -vv --log-times 2>&1 | less"

# Cleanup on exit
trap 'rm -f /tmp/quickshell_step*.qml; rm -rf /tmp/quickshell_test_ii' EXIT

echo -e "\n${GREEN}✨ Gradual setup completed!${NC}" 