import QtQuick

Rectangle {
    id: card

    readonly property string side: "center"
    readonly property int drop: 6
    readonly property int gap: 20

    readonly property int month: 8
    readonly property int today: 12
    readonly property var events: [17]
    readonly property date first: new Date(2026, 7, 30)

    readonly property int columnStart: 35
    readonly property int columnStep: 44
    readonly property int rowStart: 90
    readonly property int rowStep: 32

    width: 336
    height: 280
    radius: 30
    color: IslandTheme.pill

    Repeater {
        model: [
            { x: 28, glyph: "←" },
            { x: card.width - 28, glyph: "→" }
        ]

        Rectangle {
            required property var modelData

            x: modelData.x - width / 2
            y: 30 - height / 2
            width: 28
            height: 28
            radius: 14
            color: IslandTheme.card

            Text {
                anchors.centerIn: parent
                text: parent.modelData.glyph
                color: IslandTheme.fg
                font.family: IslandTheme.font
                font.pixelSize: 13
            }
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 30 - height / 2
        text: "September 2026"
        color: IslandTheme.fg
        font.family: IslandTheme.font
        font.pixelSize: 14
        font.weight: Font.DemiBold
    }

    Repeater {
        model: ["S", "M", "T", "W", "T", "F", "S"]

        Text {
            required property string modelData
            required property int index

            x: card.columnStart + index * card.columnStep - width / 2
            y: 60 - height / 2
            text: modelData
            color: IslandTheme.fg2
            font.family: IslandTheme.font
            font.pixelSize: 11
        }
    }

    Repeater {
        model: 42

        Item {
            id: cell

            required property int index

            readonly property date date: new Date(card.first.getFullYear(), card.first.getMonth(), card.first.getDate() + index)
            readonly property bool inMonth: date.getMonth() === card.month
            readonly property bool isToday: inMonth && date.getDate() === card.today
            readonly property bool hasEvent: inMonth && card.events.includes(date.getDate())

            x: card.columnStart + (index % 7) * card.columnStep - width / 2
            y: card.rowStart + Math.floor(index / 7) * card.rowStep - height / 2
            width: 28
            height: 28

            Rectangle {
                visible: cell.isToday
                anchors.fill: parent
                radius: width / 2
                color: IslandTheme.fg
            }

            Text {
                anchors.centerIn: parent
                text: cell.date.getDate()
                color: cell.isToday ? IslandTheme.pill : cell.inMonth ? IslandTheme.fg : IslandTheme.fg3
                font.family: IslandTheme.font
                font.pixelSize: 13
                font.weight: cell.isToday ? Font.Bold : Font.Normal
            }

            Rectangle {
                visible: cell.hasEvent
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height - 3
                width: 4
                height: 4
                radius: 2
                color: IslandTheme.fg2
            }
        }
    }
}
