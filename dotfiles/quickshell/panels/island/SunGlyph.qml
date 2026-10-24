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
        PathAngleArc { centerX: 8; centerY: 8; radiusX: 3.2; radiusY: 3.2; startAngle: 0; sweepAngle: 360 }
    }

    ShapePath {
        strokeColor: glyph.color
        strokeWidth: 1.4
        fillColor: "transparent"
        capStyle: ShapePath.RoundCap
        PathMultiline {
            paths: Array.from({ length: 8 }, (_, k) => {
                const a = k * Math.PI / 4;
                return [Qt.point(8 + 5 * Math.cos(a), 8 + 5 * Math.sin(a)), Qt.point(8 + 7 * Math.cos(a), 8 + 7 * Math.sin(a))];
            })
        }
    }
}
