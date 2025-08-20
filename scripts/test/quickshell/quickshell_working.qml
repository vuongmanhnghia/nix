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
        
        Rectangle {
            anchors.fill: parent
            color: "rgba(0, 0, 0, 0.8)"
            
            Text {
                anchors.centerIn: parent
                text: "QuickShell Working! - " + new Date().toLocaleTimeString()
                color: "white"
                font.pixelSize: 12
                
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: parent.text = "QuickShell Working! - " + new Date().toLocaleTimeString()
                }
            }
        }
    }
} 