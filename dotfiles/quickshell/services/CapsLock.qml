pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Caps Lock state of the main keyboard. Quickshell has no API for it, so it is
// read from Hyprland on demand: call refresh() after the Caps Lock key.
Singleton {
    id: root

    property bool on: false

    function refresh(): void {
        query.running = true;
    }

    Component.onCompleted: refresh()

    Process {
        id: query

        command: ["hyprctl", "devices", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const main = JSON.parse(text).keyboards.find(k => k.main);
                    root.on = main !== undefined && main.capsLock;
                } catch (e) {
                    root.on = false;
                }
            }
        }
    }
}
