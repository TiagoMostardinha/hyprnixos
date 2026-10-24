import QtQuick
import QtQuick.Shapes

Shape {
    id: glyph

    property color color: IslandTheme.fg
    property string stroke: ""
    property string fill: ""
    property real strokeWidth: 1.3
    property size view: Qt.size(16, 16)

    readonly property size zoom: Qt.size(width / view.width, height / view.height)

    width: IslandTheme.icon
    height: IslandTheme.icon
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        scale: glyph.zoom
        strokeColor: glyph.stroke ? glyph.color : "transparent"
        strokeWidth: glyph.strokeWidth
        fillColor: "transparent"
        capStyle: ShapePath.RoundCap
        joinStyle: ShapePath.RoundJoin
        PathSvg { path: glyph.stroke }
    }

    ShapePath {
        scale: glyph.zoom
        strokeColor: "transparent"
        fillColor: glyph.fill ? glyph.color : "transparent"
        PathSvg { path: glyph.fill }
    }
}
