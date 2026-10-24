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
        strokeWidth: 1.5
        fillColor: "transparent"
        PathSvg { path: "M 5 7.5 V 5 A 3 3 0 0 1 11 5 V 7.5" }
    }

    ShapePath {
        strokeColor: "transparent"
        fillColor: glyph.color
        PathRectangle { x: 3.5; y: 7.5; width: 9; height: 7; radius: 1.5 }
    }
}
