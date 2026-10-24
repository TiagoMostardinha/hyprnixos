import QtQuick
import QtQuick.Shapes

Shape {
    id: glyph

    property color color: IslandTheme.fg
    property string stroke: ""
    property string fill: ""
    property real strokeWidth: 1.5

    width: 16
    height: 16
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        strokeColor: glyph.stroke ? glyph.color : "transparent"
        strokeWidth: glyph.strokeWidth
        fillColor: "transparent"
        capStyle: ShapePath.RoundCap
        joinStyle: ShapePath.RoundJoin
        PathSvg { path: glyph.stroke }
    }

    ShapePath {
        strokeColor: "transparent"
        fillColor: glyph.fill ? glyph.color : "transparent"
        PathSvg { path: glyph.fill }
    }
}
