import QtQuick
import Quickshell
import "../services"

// Battery and network icons from the icon theme (Colloid, see the IconTheme pragma).
Row {
    id: root

    required property real size

    // Rounded down: Colloid has no battery-level-100-charging icon.
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
