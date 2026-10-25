pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    readonly property string device: "/sys/class/backlight/intel_backlight"
    readonly property int max: parseInt(maxFile.text())
    readonly property int raw: parseInt(current.text())

    // Matches the brightness keys (brightnessctl -e4 -n2): steps follow a 4th-power curve with a floor
    // of raw 2, so the level is taken on that curve and stretched so the floor reads 0 and full reads 1.
    readonly property real exponent: 4
    readonly property int floor: 2
    readonly property real level: {
        if (max <= 0)
            return 0;
        const curve = value => Math.pow(value / max, 1 / exponent);
        return Math.max(0, Math.min(1, (curve(raw) - curve(floor)) / (1 - curve(floor))));
    }

    // Inverse of level: writes go through brightnessctl, one at a time, always ending on the latest request.
    property int pending: -1

    function set(level) {
        const curveFloor = Math.pow(floor / max, 1 / exponent);
        pending = Math.round(max * Math.pow(curveFloor + level * (1 - curveFloor), exponent));
        if (!writer.running)
            write();
    }

    function write() {
        writer.command = ["brightnessctl", "-q", "set", String(pending)];
        pending = -1;
        writer.running = true;
    }

    Process {
        id: writer
        onExited: if (pending >= 0)
            write()
    }

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
