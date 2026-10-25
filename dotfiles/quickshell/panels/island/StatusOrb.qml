import QtQuick
import QtQuick.Shapes

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

    SymbolicIcon {
        anchors.centerIn: parent
        name: orb.networkIcon
        size: 12
    }
}
