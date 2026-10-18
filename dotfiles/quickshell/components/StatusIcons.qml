import QtQuick
import Quickshell
import "../services"

Row {
    id: root

    required property real size

    readonly property int batteryLevel: Math.floor(Battery.percent / 10) * 10
    readonly property string batteryIcon: Battery.charging ? `battery-level-${batteryLevel}-charging-symbolic` : `battery-level-${batteryLevel}-symbolic`

    readonly property string networkIcon: {
        if (Network.wired)
            return "network-wired-symbolic";
        if (Network.wifi)
            return `network-wireless-signal-${["weak", "ok", "good", "excellent"][Math.max(0, Math.ceil(Network.wifi.signalStrength * 4) - 1)]}-symbolic`;
        return "network-offline-symbolic";
    }

    Image {
        visible: Battery.available
        width: root.size
        height: width
        sourceSize: Qt.size(width, height)
        source: Quickshell.iconPath(root.batteryIcon)
    }

    Image {
        width: root.size
        height: width
        sourceSize: Qt.size(width, height)
        source: Quickshell.iconPath(root.networkIcon)
    }
}
