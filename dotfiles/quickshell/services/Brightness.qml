pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    readonly property string device: "/sys/class/backlight/intel_backlight"
    readonly property real level: max > 0 ? parseInt(current.text()) / max : 0
    readonly property int max: parseInt(maxFile.text())

    FileView {
        id: current
        path: device + "/brightness"
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }

    FileView {
        id: maxFile
        path: device + "/max_brightness"
        blockLoading: true
    }
}
