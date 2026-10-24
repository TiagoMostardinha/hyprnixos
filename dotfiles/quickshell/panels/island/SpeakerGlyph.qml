import QtQuick
import QtQuick.Shapes

Shape {
    id: glyph

    property color color: IslandTheme.fg

    width: 16
    height: 16
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        fillColor: glyph.color
        strokeColor: "transparent"
        PathSvg { path: "M 2 5.5 H 5 L 9 2 V 14 L 5 10.5 H 2 Z" }
    }

    ShapePath {
        strokeColor: glyph.color
        strokeWidth: 1.4
        fillColor: "transparent"
        capStyle: ShapePath.RoundCap
        PathSvg { path: "M 11.5 5 A 4 4 0 0 1 11.5 11" }
    }
}
