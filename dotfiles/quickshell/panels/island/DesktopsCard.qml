import QtQuick

IslandCard {
    id: card

    readonly property int count: 5
    readonly property int current: 2
    readonly property int pitch: 186

    width: 620
    height: 190

    IslandText {
        x: 24
        line: 36
        text: "Desktops"
        font.pixelSize: 15
        font.weight: Font.DemiBold
    }

    IslandText {
        x: card.width - 24 - width
        line: 36
        text: card.current + " / " + card.count
        tone: "secondary"
        font.pixelSize: 11
    }

    Item {
        x: 14
        y: 50
        width: card.width - 28
        height: 110
        clip: true

        Repeater {
            model: [-2, -1, 0, 1, 2]

            Rectangle {
                required property int modelData

                readonly property bool isCurrent: modelData === 0
                readonly property int workspace: (card.current - 1 + modelData + card.count) % card.count + 1

                x: parent.width / 2 + modelData * card.pitch - width / 2
                y: 8
                width: 170
                height: 96
                radius: 14
                color: isCurrent ? IslandTheme.card2 : IslandTheme.card
                border.color: IslandTheme.fg
                border.width: isCurrent ? 2 : 0

                IslandText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    line: 54
                    text: "workspace " + parent.workspace
                    tone: parent.isCurrent ? "primary" : "muted"
                    font.pixelSize: 11
                }
            }
        }
    }

    IslandText {
        x: 24
        line: 176
        text: "← →  rotates (wraps around)"
        tone: "muted"
        font.pixelSize: 10
    }

    IslandText {
        x: card.width - 24 - width
        line: 176
        text: "Enter to apply"
        tone: "muted"
        font.pixelSize: 10
    }
}
