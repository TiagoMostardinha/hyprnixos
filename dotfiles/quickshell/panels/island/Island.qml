import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: root

    readonly property string card: "Calendar"

    readonly property int orbSize: 32
    readonly property real battery: 1.0

    readonly property Item current: loader.item

    screen: Quickshell.screens.find(s => s.name === "eDP-1") ?? null
    anchors.top: true
    margins.top: 10
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "island"

    implicitWidth: current ? current.width + 2 * (current.gap + orbSize) : 1
    implicitHeight: current ? Math.max(orbSize, current.drop + current.height) : 1
    color: "transparent"

    Rectangle {
        width: root.orbSize
        height: width
        radius: width / 2
        color: IslandTheme.pill

        Rectangle {
            anchors.centerIn: parent
            width: 22
            height: width
            radius: 7
            color: IslandTheme.card2
        }
    }

    Loader {
        id: loader

        anchors.horizontalCenter: parent.horizontalCenter
        y: item ? item.drop : 0
        source: root.card + "Card.qml"
    }

    Rectangle {
        anchors.right: parent.right
        width: root.orbSize
        height: width
        radius: width / 2
        color: IslandTheme.pill

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeColor: IslandTheme.line
                strokeWidth: 2
                fillColor: "transparent"
                PathAngleArc { centerX: 16; centerY: 16; radiusX: 12.5; radiusY: 12.5; startAngle: 0; sweepAngle: 360 }
            }

            ShapePath {
                strokeColor: IslandTheme.fg
                strokeWidth: 2
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                PathAngleArc { centerX: 16; centerY: 16; radiusX: 12.5; radiusY: 12.5; startAngle: -90; sweepAngle: root.battery * 360 }
            }
        }

        IconImage {
            id: wifiIcon
            anchors.centerIn: parent
            implicitSize: 14
            source: Quickshell.iconPath("network-wireless-signal-excellent-symbolic")
            visible: false
            layer.enabled: true
        }

        Rectangle {
            anchors.fill: wifiIcon
            color: IslandTheme.fg
            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: wifiIcon
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1.0
            }
        }
    }
}
