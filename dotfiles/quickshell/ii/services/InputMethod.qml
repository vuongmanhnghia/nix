pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common

/**
 * Service để quản lý input method và icon tương ứng
 */
Singleton {
    id: root
    
    property string currentInputMethod: ""
    property string currentInputMethodIcon: ""
    property bool isActive: false
    
    // Mapping input method names to icons
    property var inputMethodIcons: ({
        "unikey": "ai-openai-symbolic",
        "keyboard-us": "keyboard-us-symbolic",
        "keyboard": "keyboard-us-symbolic",
        "default": "keyboard-us-symbolic"
    })
    
    // Mapping input method names to display names
    property var inputMethodNames: ({
        "unikey": "Unikey (Vietnamese)",
        "keyboard-us": "US Keyboard",
        "keyboard": "US Keyboard",
        "default": "US Keyboard"
    })
    
    function getIconForInputMethod(methodName) {
        return inputMethodIcons[methodName] || inputMethodIcons["default"]
    }
    
    function getDisplayNameForInputMethod(methodName) {
        return inputMethodNames[methodName] || methodName
    }
    
    function switchToInputMethod(methodName) {
        Quickshell.execDetached(["fcitx5-remote", "-s", methodName])
        // Refresh after switching
        Qt.setTimeout(() => {
            updateCurrentInputMethod()
        }, 100)
    }
    
    function updateCurrentInputMethod() {
        inputMethodProc.running = true
    }
    
    // Process to get current input method
    Process {
        id: inputMethodProc
        running: true
        command: ["fcitx5-remote", "-n"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                const method = text.trim()
                root.currentInputMethod = method
                root.currentInputMethodIcon = root.getIconForInputMethod(method)
            }
        }
    }
    
    // Timer to refresh input method status
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            root.updateCurrentInputMethod()
        }
    }
    
    // Initialize
    Component.onCompleted: {
        root.updateCurrentInputMethod()
    }
}

