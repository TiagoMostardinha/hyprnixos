import QtQuick
import QtQuick.Shapes

Shape {
    id: glyph

    property color color: IslandTheme.fg

    width: 16
    height: 16
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        strokeColor: glyph.color
        strokeWidth: 1.4
        fillColor: "transparent"
        joinStyle: ShapePath.RoundJoin
        capStyle: ShapePath.RoundCap
        PathSvg { path: "M 4 5 L 11.5 11 L 8 14 V 2 L 11.5 5 L 4 11" }
    }
}
