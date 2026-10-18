import QtQuick
import Quickshell
import "../theme"
import "../services"

// Battery (left) and network (right), icons only, from the icon theme
// (Colloid, set by the IconTheme pragma in shell.qml / greeter.qml).
Row {
    id: root

    // Base size in px: icons are 1.5 units, the gap 0.9.
    required property real unit

    readonly property real iconSize: unit * 1.5

    readonly property string batteryIcon: {
        const level = Math.round(Battery.percent / 10) * 10;
        if (Battery.charging)
            return level === 100 ? "battery-level-100-charged-symbolic" : `battery-level-${level}-charging-symbolic`;
        return `battery-level-${level}-symbolic`;
    }

    readonly property string networkIcon: {
        if (Network.type === "ethernet")
            return "network-wired-symbolic";
        if (Network.type === "wifi")
            return `network-wireless-signal-${["weak", "ok", "good", "excellent"][Network.wifiLevel - 1]}-symbolic`;
        return "network-offline-symbolic";
    }

    spacing: unit * 0.9

    Image {
        visible: Battery.available
        width: root.iconSize
        height: width
        sourceSize: Qt.size(width, height)
        source: Quickshell.iconPath(root.batteryIcon)
    }

    Image {
        width: root.iconSize
        height: width
        sourceSize: Qt.size(width, height)
        source: Quickshell.iconPath(root.networkIcon)
    }
}
