import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: orb

    property real battery: 1.0
    property string networkIcon: "network-wireless-signal-excellent-symbolic"

    width: 32
    height: 32
    radius: 16
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
            PathAngleArc { centerX: 16; centerY: 16; radiusX: 12.5; radiusY: 12.5; startAngle: -90; sweepAngle: orb.battery * 360 }
        }
    }

    IconImage {
        id: icon

        anchors.centerIn: parent
        implicitSize: 14
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
