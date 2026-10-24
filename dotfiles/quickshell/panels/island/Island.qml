import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: root

    readonly property color pill: "#050505"
    readonly property color card: "#222222"
    readonly property color line: "#2c2c2c"
    readonly property color fg: "#ffffff"

    readonly property int pillWidth: 90
    readonly property int pillHeight: 32
    readonly property int orbSize: 32
    readonly property int gap: 12
    readonly property real battery: 1.0

    screen: Quickshell.screens.find(s => s.name === "eDP-1") ?? null
    anchors.top: true
    margins.top: 10
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "island"

    implicitWidth: pillWidth + 2 * (gap + orbSize)
    implicitHeight: pillHeight
    color: "transparent"

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: root.orbSize
        height: width
        radius: width / 2
        color: root.pill

        Rectangle {
            anchors.centerIn: parent
            width: 22
            height: width
            radius: 7
            color: root.card
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: root.pillWidth
        height: root.pillHeight
        radius: height / 2
        color: root.pill

        Text {
            anchors.centerIn: parent
            text: "00:47"
            color: root.fg
            font.family: "Inter"
            font.pixelSize: 16
            font.weight: Font.Medium
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: root.orbSize
        height: width
        radius: width / 2
        color: root.pill

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeColor: root.line
                strokeWidth: 2
                fillColor: "transparent"
                PathAngleArc { centerX: 16; centerY: 16; radiusX: 12.5; radiusY: 12.5; startAngle: 0; sweepAngle: 360 }
            }

            ShapePath {
                strokeColor: root.fg
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
            color: root.fg
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
