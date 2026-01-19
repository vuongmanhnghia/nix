import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

/**
 * Hardware Audio Monitor for EasyEffects
 * Monitors actual hardware volume instead of virtual sink
 */
Singleton {
    id: root

    property real hardwareVolume: 0.0
    property bool hardwareMuted: false
    property real hardwareSourceVolume: 0.0
    property bool hardwareSourceMuted: false
    property bool ready: false

    // Refresh interval (milliseconds)
    readonly property int refreshInterval: 100

    Timer {
        id: refreshTimer
        interval: root.refreshInterval
        repeat: true
        running: true
        triggeredOnStart: true
        
        onTriggered: {
            sinkProcess.running = true;
            sourceProcess.running = true;
        }
    }

    // Monitor hardware sink (speakers)
    Process {
        id: sinkProcess
        command: ["bash", "-c", "~/Workspaces/config/nixos/home/shared/hypr/scripts/get-hardware-volume.sh --sink"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                try {
                    const result = JSON.parse(data);
                    root.hardwareVolume = result.volume ?? 0.0;
                    root.hardwareMuted = result.muted ?? false;
                    root.ready = true;
                } catch (e) {
                    console.error("HardwareAudio: Failed to parse sink data:", e, data);
                }
            }
        }
    }

    // Monitor hardware source (microphone)
    Process {
        id: sourceProcess
        command: ["bash", "-c", "~/Workspaces/config/nixos/home/shared/hypr/scripts/get-hardware-volume.sh --source"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                try {
                    const result = JSON.parse(data);
                    root.hardwareSourceVolume = result.volume ?? 0.0;
                    root.hardwareSourceMuted = result.muted ?? false;
                } catch (e) {
                    console.error("HardwareAudio: Failed to parse source data:", e, data);
                }
            }
        }
    }

    // Debug output (uncomment if needed)
    // onHardwareVolumeChanged: {
    //     console.log("Hardware Sink Volume:", hardwareVolume, "Muted:", hardwareMuted);
    // }

    // onHardwareSourceVolumeChanged: {
    //     console.log("Hardware Source Volume:", hardwareSourceVolume, "Muted:", hardwareSourceMuted);
    // }
}
