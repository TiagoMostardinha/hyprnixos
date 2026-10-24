import QtQuick
import QtQuick.Shapes

OsdCard {
    level: 0.48

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: IslandTheme.fg
            strokeColor: "transparent"
            PathSvg { path: "M 2 5.5 H 5 L 9 2 V 14 L 5 10.5 H 2 Z" }
        }

        ShapePath {
            strokeColor: IslandTheme.fg
            strokeWidth: 1.4
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            PathSvg { path: "M 11.5 5 A 4 4 0 0 1 11.5 11" }
        }
    }
}
