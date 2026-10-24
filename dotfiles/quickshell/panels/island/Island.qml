import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: root

    readonly property color pill: "#050505"
    readonly property color card: "#161616"
    readonly property color line: "#2c2c2c"
    readonly property color fg: "#ffffff"
    readonly property color fg2: "#9a9a9a"
    readonly property color fg3: "#5a5a5a"

    readonly property int pillWidth: 90
    readonly property int pillHeight: 32
    readonly property int panelWidth: 254
    readonly property int panelHeight: 116
    readonly property int panelDrop: 6
    readonly property int orbSize: 32
    readonly property int gap: 12
    readonly property int panelGap: 20
    readonly property real battery: 1.0

    readonly property var week: [
        { label: "W", day: 9 },
        { label: "T", day: 10 },
        { label: "F", day: 11 },
        { label: "SAT", day: 12 },
        { label: "S", day: 13 },
        { label: "M", day: 14 },
        { label: "T", day: 15 }
    ]
    readonly property int today: 3

    readonly property bool expanded: true

    screen: Quickshell.screens.find(s => s.name === "eDP-1") ?? null
    anchors.top: true
    margins.top: 10
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "island"

    implicitWidth: (expanded ? panelWidth + 2 * panelGap : pillWidth + 2 * gap) + 2 * orbSize
    implicitHeight: expanded ? panelDrop + panelHeight : pillHeight
    color: "transparent"

    Rectangle {
        y: 0
        width: root.orbSize
        height: width
        radius: width / 2
        color: root.pill

        Rectangle {
            anchors.centerIn: parent
            width: 22
            height: width
            radius: 7
            color: "#222222"
        }
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.expanded ? root.panelDrop : 0
        width: root.expanded ? root.panelWidth : root.pillWidth
        height: root.expanded ? root.panelHeight : root.pillHeight
        radius: root.expanded ? 28 : height / 2
        color: root.pill

        Text {
            visible: !root.expanded
            anchors.centerIn: parent
            text: "00:47"
            color: root.fg
            font.family: "Inter"
            font.pixelSize: 16
            font.weight: Font.Medium
        }

        Text {
            visible: root.expanded
            anchors.horizontalCenter: parent.horizontalCenter
            y: 18
            text: "00:47"
            color: root.fg
            font.family: "Inter"
            font.pixelSize: 26
            font.weight: Font.Medium
        }

        Rectangle {
            visible: root.expanded
            anchors.horizontalCenter: parent.horizontalCenter
            y: 62
            width: 32
            height: 40
            radius: 9
            color: root.card
        }

        Row {
            visible: root.expanded
            anchors.horizontalCenter: parent.horizontalCenter
            y: 64

            Repeater {
                model: root.week

                Column {
                    required property var modelData
                    required property int index

                    readonly property int distance: Math.abs(index - root.today)
                    readonly property bool isToday: distance === 0

                    width: 28
                    spacing: 2
                    opacity: [1, 0.75, 0.45, 0.2][distance]

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: parent.modelData.label
                        color: parent.isToday ? root.fg2 : root.fg3
                        font.family: "Inter"
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 20
                        verticalAlignment: Text.AlignVCenter
                        text: parent.modelData.day
                        color: parent.isToday ? root.fg : root.fg2
                        font.family: "Inter"
                        font.pixelSize: parent.isToday ? 18 : 13
                        font.weight: parent.isToday ? Font.DemiBold : Font.Medium
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.right: parent.right
        y: 0
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
