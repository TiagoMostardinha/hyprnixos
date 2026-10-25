pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    readonly property string hostname: hostFile.text().trim()
    readonly property real uptime: parseFloat(uptimeFile.text().split(" ")[0]) || 0

    // Like `uptime -p`: "up 2 hours, 23 minutes".
    readonly property string uptimeText: {
        const minutes = Math.floor(uptime / 60);
        const parts = [[Math.floor(minutes / 1440), "day"], [Math.floor(minutes / 60) % 24, "hour"], [minutes % 60, "minute"]]
            .filter(([count]) => count > 0)
            .map(([count, unit]) => `${count} ${unit}${count === 1 ? "" : "s"}`);
        return "up " + (parts.length ? parts.join(", ") : "less than a minute");
    }

    FileView {
        id: hostFile
        path: "/etc/hostname"
        blockLoading: true
    }

    FileView {
        id: uptimeFile
        path: "/proc/uptime"
        blockLoading: true
    }

    Timer {
        running: true
        repeat: true
        interval: 30000
        onTriggered: uptimeFile.reload()
    }
}
