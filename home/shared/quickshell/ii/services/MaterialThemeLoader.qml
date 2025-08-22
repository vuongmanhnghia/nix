pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Optimized Material Theme Loader with performance improvements.
 */
Singleton {
    id: root
    property string filePath: Directories.generatedMaterialThemePath
    property string lastFileContent: ""
    property bool isReloading: false

    function reapplyTheme() {
        if (root.isReloading) return // Prevent concurrent reloads
        
        root.isReloading = true
        themeFileView.reload()
        
        // Use debounced timer to avoid rapid successive calls
        reloadTimer.restart()
    }

    function applyColors(fileContent) {
        if (!fileContent || fileContent.trim() === "") {
            root.isReloading = false
            return
        }
        
        // Skip if content hasn't changed (caching)
        if (fileContent === root.lastFileContent) {
            root.isReloading = false
            return
        }
        
        try {
            const json = JSON.parse(fileContent)
            
            // Batch update colors for better performance
            let colorUpdates = {}
            
            for (const key in json) {
                if (json.hasOwnProperty(key)) {
                    const camelCaseKey = key.replace(/_([a-z])/g, (g) => g[1].toUpperCase())
                    const m3Key = `m3${camelCaseKey}`
                    colorUpdates[m3Key] = json[key]
                }
            }
            
            // Apply all colors at once
            for (const key in colorUpdates) {
                Appearance.m3colors[key] = colorUpdates[key]
            }
            
            // Calculate dark mode
            Appearance.m3colors.darkmode = (Appearance.m3colors.m3background.hslLightness < 0.5)
            
            // Cache successful content
            root.lastFileContent = fileContent
            
        } catch (e) {
            console.error("[MaterialThemeLoader] Error parsing theme file:", e)
        }
        
        root.isReloading = false
    }

    // Debounced timer to prevent rapid successive reloads
    Timer {
        id: reloadTimer
        interval: 150 // Slightly longer for stability
        repeat: false
        running: false
        onTriggered: {
            root.applyColors(themeFileView.text())
        }
    }

    // Optimized IPC Handler
    IpcHandler {
        target: "reloadTheme"
        
        function reloadTheme() {
            if (!root.isReloading) {
                root.reapplyTheme()
            }
        }
    }

    FileView { 
        id: themeFileView
        path: Qt.resolvedUrl(root.filePath)
        watchChanges: true
        
        onFileChanged: {
            // Debounce file changes to avoid rapid firing
            if (!root.isReloading) {
                this.reload()
                reloadTimer.restart()
            }
        }
        
        Component.onCompleted: {
            // Apply initial colors with small delay to ensure UI is ready
            Qt.callLater(() => root.applyColors(this.text()))
        }
    }
}
