import qs
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Wayland
pragma Singleton

/**
 * A nice wrapper for date and time strings.
 */
Singleton {
    id: root

    property bool inhibit: false

    Connections {
        target: Persistent
        function onReadyChanged() {
            if (!Persistent.isNewHyprlandInstance) {
                root.inhibit = Persistent.states.idle.inhibit
            } else {
                Persistent.states.idle.inhibit = root.inhibit
            }
        }
    }

    function toggleInhibit() {
        root.inhibit = !root.inhibit
        Persistent.states.idle.inhibit = root.inhibit
    }

    // NOTE: IdleInhibitor has been temporarily disabled for quickshell 0.2.0 compatibility
    // TODO: Find replacement or proper implementation in quickshell 0.2.0
    // IdleInhibitor {
    //     id: idleInhibitor
    //     window: PanelWindow { // Inhibitor requires a "visible" surface
    //         // Actually not lol
    //         implicitWidth: 0
    //         implicitHeight: 0
    //         color: "transparent"
    //         // Just in case...
    //         anchors {
    //             right: true
    //             bottom: true
    //         }
    //         // Make it not interactable
    //         mask: Region {
    //             item: null
    //         }
    //     }
    // }    

}
