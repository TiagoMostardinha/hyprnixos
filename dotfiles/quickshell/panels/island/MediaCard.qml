import QtQuick
import QtQuick.Shapes

Rectangle {
    id: card

    readonly property string side: "left"
    readonly property int drop: 6
    readonly property int gap: 12

    readonly property real progress: 0.7

    width: 380
    height: 160
    radius: 30
    color: IslandTheme.pill

    component Label: Text {
        property real line

        x: 160
        y: line - baselineOffset
        font.family: IslandTheme.font
    }

    component Glyph: Shape {
        id: glyph

        property var points: []
        property real barX: -1

        width: 9
        height: 9
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: IslandTheme.fg
            strokeColor: "transparent"
            PathPolyline { path: glyph.points }
        }

        Rectangle {
            visible: glyph.barX >= 0
            x: glyph.barX
            width: 1.6
            height: glyph.height
            radius: 0.5
            color: IslandTheme.fg
        }
    }

    Rectangle {
        x: 16
        y: 16
        width: 128
        height: 128
        radius: 18
        color: IslandTheme.card2
    }

    Label {
        line: 38
        text: "Wallflower"
        color: IslandTheme.fg
        font.pixelSize: 16
        font.weight: Font.DemiBold
    }

    Label {
        line: 56
        text: "Dominic Fike"
        color: IslandTheme.fg2
        font.pixelSize: 12
    }

    Label {
        line: 74
        text: "How To Quit Smoking"
        color: IslandTheme.fg3
        font.pixelSize: 11
    }

    Label {
        line: 92
        text: "Spotify"
        color: IslandTheme.fg3
        font.pixelSize: 11
    }

    Rectangle {
        x: 160
        y: 104
        width: 200
        height: 5
        radius: 2.5
        color: IslandTheme.card2

        Rectangle {
            width: parent.width * card.progress
            height: parent.height
            radius: parent.radius
            color: IslandTheme.fg
        }
    }

    Label {
        line: 122
        text: "2:06"
        color: IslandTheme.fg2
        font.pixelSize: 9
    }

    Label {
        x: 360 - width
        line: 122
        text: "2:58"
        color: IslandTheme.fg2
        font.pixelSize: 9
    }

    Glyph {
        x: 231.7
        y: 133.5
        points: [Qt.point(8.8, 0), Qt.point(1.6, 4.5), Qt.point(8.8, 9)]
        barX: 0
    }

    Rectangle {
        x: 257
        y: 125
        width: 26
        height: 26
        radius: 13
        color: IslandTheme.card2

        Glyph {
            x: 11
            y: 8
            width: 8
            height: 10
            points: [Qt.point(0, 0), Qt.point(8, 5), Qt.point(0, 10)]
        }
    }

    Glyph {
        x: 299.5
        y: 133.5
        points: [Qt.point(0, 0), Qt.point(7.2, 4.5), Qt.point(0, 9)]
        barX: 7.2
    }
}
