import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: root

    readonly property string card: "WifiBluetooth"

    readonly property int orbSize: 32
    readonly property real battery: 1.0

    readonly property Item shown: cardLoader.item
    readonly property bool leftCard: shown?.side === "left"
    readonly property bool solo: shown?.side === "solo"
    readonly property Item center: leftCard ? idleLoader.item : shown
    readonly property Item left: leftCard ? shown : leftOrb

    readonly property real leftExtent: solo ? center.width / 2 : center ? center.width / 2 + (leftCard ? shown.gap : center.gap) + left.width : 0
    readonly property real rightExtent: solo ? center.width / 2 : center ? center.width / 2 + center.gap + orbSize : 0

    screen: Quickshell.screens.find(s => s.name === "eDP-1") ?? null
    anchors.top: true
    margins.top: 10
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "island"

    implicitWidth: Math.max(1, 2 * Math.max(leftExtent, rightExtent))
    implicitHeight: Math.max(solo ? 1 : orbSize, center ? center.drop + center.height : 0, leftCard ? shown.drop + shown.height : 0)
    color: "transparent"

    mask: Region {
        Region { item: root.solo ? null : root.left }
        Region { item: root.center }
        Region { item: root.solo ? null : rightOrb }
    }

    Loader {
        id: cardLoader

        x: root.leftCard ? root.width / 2 - root.leftExtent : root.width / 2 - (item ? item.width : 0) / 2
        y: item ? item.drop : 0
        source: root.card + "Card.qml"
    }

    Loader {
        id: idleLoader

        active: root.leftCard
        x: root.width / 2 - width / 2
        source: "IdleCard.qml"
    }

    Rectangle {
        id: leftOrb

        visible: !root.leftCard && !root.solo
        x: root.width / 2 - root.leftExtent
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

    Rectangle {
        id: rightOrb

        visible: !root.solo
        x: root.width / 2 + root.rightExtent - width
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
