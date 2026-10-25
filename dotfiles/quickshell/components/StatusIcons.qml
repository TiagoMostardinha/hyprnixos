import QtQuick
import Quickshell
import "../services"

Row {
    id: root

    required property real size

    readonly property int batteryLevel: Math.floor(Battery.percent / 10) * 10
    readonly property string batteryIcon: Battery.charging ? `battery-level-${batteryLevel}-charging-symbolic` : `battery-level-${batteryLevel}-symbolic`

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
        source: Quickshell.iconPath(Network.icon)
    }
}
