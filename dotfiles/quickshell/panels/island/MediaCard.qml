import QtQuick

IslandCard {
    id: card

    side: "left"
    gap: 10

    width: 340
    height: 108

    Rectangle {
        x: 12
        y: 12
        width: 84
        height: 84
        radius: IslandTheme.radiusSmall
        color: IslandTheme.card2
    }

    IslandText {
        x: 108
        line: 27
        width: card.width - x - 12
        elide: Text.ElideRight
        text: "Wallflower"
        font.pixelSize: IslandTheme.title
        font.weight: Font.DemiBold
    }

    IslandText {
        x: 108
        line: 42
        width: card.width - x - 12
        elide: Text.ElideRight
        text: "Dominic Fike"
        tone: "secondary"
    }

    IslandText {
        x: 108
        line: 56
        width: controls.x - x - 8
        elide: Text.ElideRight
        text: "How To Quit Smoking"
        tone: "muted"
        font.pixelSize: IslandTheme.small
    }

    IslandText {
        x: 108
        line: 70
        width: controls.x - x - 8
        elide: Text.ElideRight
        text: "Spotify"
        tone: "muted"
        font.pixelSize: IslandTheme.small
    }

    Row {
        id: controls

        anchors.right: parent.right
        anchors.rightMargin: 12
        y: bar.y - height - 4
        spacing: 8

        PathGlyph {
            anchors.verticalCenter: parent.verticalCenter
            width: 8
            height: 8
            view: Qt.size(8, 8)
            fill: "M 7.8 0 L 1.4 4 L 7.8 8 Z M 0 0 H 1.4 V 8 H 0 Z"
        }

        PillButton {
            width: 20
            height: 20
            radius: height / 2

            PathGlyph {
                x: 7
                y: 5.5
                width: 7
                height: 9
                view: Qt.size(7, 9)
                fill: "M 0 0 L 7 4.5 L 0 9 Z"
            }
        }

        PathGlyph {
            anchors.verticalCenter: parent.verticalCenter
            width: 8
            height: 8
            view: Qt.size(8, 8)
            fill: "M 0 0 L 6.4 4 L 0 8 Z M 6.4 0 H 7.8 V 8 H 6.4 Z"
        }
    }

    LevelBar {
        id: bar

        x: 108
        y: 78
        width: card.width - x - 12
        height: 4
        level: 0.7
    }

    IslandText {
        x: 108
        line: 94
        text: "2:06"
        tone: "secondary"
        font.pixelSize: IslandTheme.tiny
    }

    IslandText {
        x: card.width - 12 - width
        line: 94
        text: "2:58"
        tone: "secondary"
        font.pixelSize: IslandTheme.tiny
    }
}
