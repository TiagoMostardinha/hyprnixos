import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets

// A symbolic icon from the icon theme (Colloid), recoloured to fit the island.
Item {
    id: root

    property string name
    property color color: IslandTheme.fg
    property real size: IslandTheme.icon

    width: size
    height: size

    IconImage {
        id: icon

        anchors.fill: parent
        implicitSize: root.size
        source: root.name ? Quickshell.iconPath(root.name) : ""
        visible: false
        layer.enabled: true
    }

    Rectangle {
        anchors.fill: parent
        color: root.color
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: icon
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }
    }
}
