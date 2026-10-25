import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: orb

    property real battery: 1.0
    property string networkIcon: "network-offline-symbolic"

    readonly property real ring: width / 2 - 3.5

    width: 28
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
            PathAngleArc { centerX: orb.width / 2; centerY: orb.height / 2; radiusX: orb.ring; radiusY: orb.ring; startAngle: 0; sweepAngle: 360 }
        }

        ShapePath {
            strokeColor: IslandTheme.fg
            strokeWidth: 2
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            PathAngleArc { centerX: orb.width / 2; centerY: orb.height / 2; radiusX: orb.ring; radiusY: orb.ring; startAngle: -90; sweepAngle: orb.battery * 180 }
            PathAngleArc { moveToStart: true; centerX: orb.width / 2; centerY: orb.height / 2; radiusX: orb.ring; radiusY: orb.ring; startAngle: -90; sweepAngle: -orb.battery * 180 }
        }
    }

    IconImage {
        id: icon

        anchors.centerIn: parent
        implicitSize: 12
        source: Quickshell.iconPath(orb.networkIcon)
        visible: false
        layer.enabled: true
    }

    Rectangle {
        anchors.fill: icon
        color: IslandTheme.fg
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: icon
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }
    }
}
