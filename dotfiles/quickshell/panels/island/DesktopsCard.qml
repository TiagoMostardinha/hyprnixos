import QtQuick

IslandCard {
    id: card

    readonly property int count: 5
    readonly property int current: 2
    readonly property int pitch: 140

    width: 520
    height: 132

    IslandText {
        x: 16
        line: 24
        text: "Desktops"
        font.pixelSize: IslandTheme.heading
        font.weight: Font.DemiBold
    }

    IslandText {
        x: card.width - 16 - width
        line: 24
        text: card.current + " / " + card.count
        tone: "secondary"
        font.pixelSize: IslandTheme.small
    }

    Item {
        x: 10
        y: 34
        width: card.width - 20
        height: 74
        clip: true

        Repeater {
            model: [-2, -1, 0, 1, 2]

            Rectangle {
                required property int modelData

                readonly property bool isCurrent: modelData === 0
                readonly property int workspace: (card.current - 1 + modelData + card.count) % card.count + 1

                x: parent.width / 2 + modelData * card.pitch - width / 2
                y: 4
                width: 130
                height: 66
                radius: IslandTheme.radiusSection
                color: isCurrent ? IslandTheme.card2 : IslandTheme.card
                border.color: IslandTheme.fg
                border.width: isCurrent ? 2 : 0

                IslandText {
                    anchors.centerIn: parent
                    text: "workspace " + parent.workspace
                    tone: parent.isCurrent ? "primary" : "muted"
                    font.pixelSize: IslandTheme.small
                }
            }
        }
    }

    IslandText {
        x: 16
        line: 122
        text: "← →  rotates (wraps around)"
        tone: "muted"
        font.pixelSize: IslandTheme.tiny
    }

    IslandText {
        x: card.width - 16 - width
        line: 122
        text: "Enter to apply"
        tone: "muted"
        font.pixelSize: IslandTheme.tiny
    }
}
