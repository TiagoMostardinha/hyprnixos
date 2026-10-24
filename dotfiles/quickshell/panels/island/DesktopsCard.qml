import QtQuick

Rectangle {
    id: card

    readonly property string side: "center"
    readonly property int drop: 6
    readonly property int gap: 20

    readonly property int count: 5
    readonly property int current: 2
    readonly property int pitch: 186

    width: 620
    height: 190
    radius: 30
    color: IslandTheme.pill

    component Label: Text {
        property real line

        y: line - baselineOffset
        font.family: IslandTheme.font
    }

    Label {
        x: 24
        line: 36
        text: "Desktops"
        color: IslandTheme.fg
        font.pixelSize: 15
        font.weight: Font.DemiBold
    }

    Label {
        x: card.width - 24 - width
        line: 36
        text: card.current + " / " + card.count
        color: IslandTheme.fg2
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

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    line: 54
                    text: "workspace " + parent.workspace
                    color: parent.isCurrent ? IslandTheme.fg : IslandTheme.fg3
                    font.pixelSize: 11
                }
            }
        }
    }

    Label {
        x: 24
        line: 176
        text: "← →  rotates (wraps around)"
        color: IslandTheme.fg3
        font.pixelSize: 10
    }

    Label {
        x: card.width - 24 - width
        line: 176
        text: "Enter to apply"
        color: IslandTheme.fg3
        font.pixelSize: 10
    }
}
