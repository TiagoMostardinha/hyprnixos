import QtQuick

IslandCard {
    side: "left"
    gap: 12

    width: 380
    height: 160

    Rectangle {
        x: 16
        y: 16
        width: 128
        height: 128
        radius: 18
        color: IslandTheme.card2
    }

    IslandText {
        x: 160
        line: 38
        text: "Wallflower"
        font.pixelSize: 16
        font.weight: Font.DemiBold
    }

    IslandText {
        x: 160
        line: 56
        text: "Dominic Fike"
        tone: "secondary"
        font.pixelSize: 12
    }

    IslandText {
        x: 160
        line: 74
        text: "How To Quit Smoking"
        tone: "muted"
        font.pixelSize: 11
    }

    IslandText {
        x: 160
        line: 92
        text: "Spotify"
        tone: "muted"
        font.pixelSize: 11
    }

    LevelBar {
        x: 160
        y: 104
        width: 200
        height: 5
        level: 0.7
    }

    IslandText {
        x: 160
        line: 122
        text: "2:06"
        tone: "secondary"
        font.pixelSize: 9
    }

    IslandText {
        x: 360 - width
        line: 122
        text: "2:58"
        tone: "secondary"
        font.pixelSize: 9
    }

    PathGlyph {
        x: 231.7
        y: 133.5
        width: 9
        height: 9
        fill: "M 8.8 0 L 1.6 4.5 L 8.8 9 Z M 0 0 H 1.6 V 9 H 0 Z"
    }

    PillButton {
        x: 257
        y: 125
        width: 26
        height: 26

        PathGlyph {
            x: 11
            y: 8
            width: 8
            height: 10
            fill: "M 0 0 L 8 5 L 0 10 Z"
        }
    }

    PathGlyph {
        x: 299.5
        y: 133.5
        width: 9
        height: 9
        fill: "M 0 0 L 7.2 4.5 L 0 9 Z M 7.2 0 H 8.8 V 9 H 7.2 Z"
    }
}
