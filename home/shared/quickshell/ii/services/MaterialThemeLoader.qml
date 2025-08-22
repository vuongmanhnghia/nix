pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Enhanced Material Theme Loader with complete persistence system.
 */
Singleton {
    id: root
    property string filePath: Directories.generatedMaterialThemePath
    property string persistentThemePath: `${Directories.state}/user/theme_state.json`
    property string lastFileContent: ""
    property bool isReloading: false
    property bool isInitialized: false

    // Theme persistence data
    property var persistentThemeData: ({})

    function saveThemeState(colors) {
        console.log("[MaterialThemeLoader] Saving theme state...")
        persistentThemeData = {
            "timestamp": Date.now(),
            "colors": colors,
            "darkmode": colors.darkmode || false,
            "wallpaperPath": Config.options?.background?.wallpaperPath || "",
            "version": "1.0"
        }
        
        // Write to persistent file
        themeStateFileView.writeText(JSON.stringify(persistentThemeData, null, 2))
    }

    function loadThemeState() {
        console.log("[MaterialThemeLoader] Loading persistent theme state...")
        
        try {
            const stateContent = themeStateFileView.text()
            if (stateContent && stateContent.trim() !== "") {
                const savedState = JSON.parse(stateContent)
                
                if (savedState.colors && savedState.version) {
                    console.log("[MaterialThemeLoader] Applying saved theme state")
                    applyColorsFromData(savedState.colors)
                    persistentThemeData = savedState
                    return true
                }
            }
        } catch (e) {
            console.warn("[MaterialThemeLoader] Could not load persistent theme state:", e)
        }
        
        return false
    }

    function applyColorsFromData(colorsData) {
        console.log("[MaterialThemeLoader] Applying colors from data...")
        
        try {
            // Apply all colors at once
            for (const key in colorsData) {
                if (colorsData.hasOwnProperty(key)) {
                    if (key === "darkmode") {
                        Appearance.m3colors.darkmode = (colorsData[key] === true || colorsData[key] === "True")
                    } else {
                        // Convert key to proper m3 format (lowercase to match Appearance.qml)
                        let m3Key = key
                        if (!key.startsWith("m3")) {
                            // Convert snake_case to camelCase, then add m3 prefix, keep lowercase
                            const camelCase = key.replace(/_([a-z])/g, (g) => g[1].toUpperCase())
                            m3Key = `m3${camelCase}`
                        }
                        
                        // Only set if the property exists in Appearance.m3colors
                        if (Appearance.m3colors.hasOwnProperty(m3Key)) {
                            Appearance.m3colors[m3Key] = colorsData[key]
                        } else {
                            console.warn(`[MaterialThemeLoader] Property ${m3Key} does not exist, skipping`)
                        }
                    }
                }
            }
            
            console.log("[MaterialThemeLoader] Theme colors applied successfully")
            
        } catch (e) {
            console.error("[MaterialThemeLoader] Error applying colors from data:", e)
        }
    }

    function reapplyTheme() {
        if (root.isReloading) return // Prevent concurrent reloads
        
        console.log("[MaterialThemeLoader] Reapplying theme...")
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
            console.log("[MaterialThemeLoader] Applying new colors from file...")
            
            // Convert and prepare colors
            let colorUpdates = {}
            
            for (const key in json) {
                if (json.hasOwnProperty(key)) {
                    if (key === "darkmode") {
                        // Handle darkmode separately
                        continue
                    } else {
                        // Convert snake_case to camelCase first, then add m3 prefix (lowercase)
                        const camelCase = key.replace(/_([a-z])/g, (g) => g[1].toUpperCase())
                        const m3Key = `m3${camelCase}`
                        
                        // Only add if the property exists
                        if (Appearance.m3colors.hasOwnProperty(m3Key)) {
                            colorUpdates[m3Key] = json[key]
                        } else {
                            console.warn(`[MaterialThemeLoader] Property ${m3Key} does not exist, skipping`)
                        }
                    }
                }
            }
            
            // Apply all colors at once
            for (const key in colorUpdates) {
                Appearance.m3colors[key] = colorUpdates[key]
            }
            
            // Calculate dark mode
            const isDark = (json.darkmode === "True" || json.darkmode === true || 
                          (Appearance.m3colors.m3background && Appearance.m3colors.m3background.hslLightness < 0.5))
            Appearance.m3colors.darkmode = isDark
            
            // Save to persistent storage
            const fullColorData = Object.assign({}, json, {darkmode: isDark})
            saveThemeState(fullColorData)
            
            // Cache successful content
            root.lastFileContent = fileContent
            
            console.log("[MaterialThemeLoader] Theme applied and saved successfully")
            
        } catch (e) {
            console.error("[MaterialThemeLoader] Error parsing theme file:", e)
        }
        
        root.isReloading = false
    }

    // Initialize theme system
    function initializeTheme() {
        if (root.isInitialized) return
        
        console.log("[MaterialThemeLoader] Initializing theme system...")
        
        // Try to load persistent theme first
        const hasPersistedTheme = loadThemeState()
        
        if (!hasPersistedTheme) {
            // Fallback to current colors file if available
            console.log("[MaterialThemeLoader] No persistent theme, trying colors file...")
            const currentContent = themeFileView.text()
            if (currentContent && currentContent.trim() !== "") {
                applyColors(currentContent)
            }
        }
        
        root.isInitialized = true
        console.log("[MaterialThemeLoader] Theme system initialized")
    }

    // Debounced timer to prevent rapid successive reloads
    Timer {
        id: reloadTimer
        interval: 150
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
                console.log("[MaterialThemeLoader] IPC reload theme requested")
                root.reapplyTheme()
            }
        }
    }

    // Persistent theme state file
    FileView {
        id: themeStateFileView
        path: Qt.resolvedUrl(root.persistentThemePath)
        watchChanges: false // We control writes
    }

    // Main theme colors file watcher
    FileView { 
        id: themeFileView
        path: Qt.resolvedUrl(root.filePath)
        watchChanges: true
        
        onFileChanged: {
            // Debounce file changes to avoid rapid firing
            if (!root.isReloading) {
                console.log("[MaterialThemeLoader] Theme file changed, reloading...")
                this.reload()
                reloadTimer.restart()
            }
        }
        
        Component.onCompleted: {
            // Initialize theme system after a short delay to ensure all singletons are ready
            Qt.callLater(() => {
                initializeTimer.start()
            })
        }
    }

    // Initialization timer to ensure proper startup order
    Timer {
        id: initializeTimer
        interval: 200
        repeat: false
        onTriggered: {
            root.initializeTheme()
        }
    }
}

