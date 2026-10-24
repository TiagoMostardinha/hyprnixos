import QtQuick

IslandCard {
    id: card

    readonly property int month: 8
    readonly property int today: 12
    readonly property var events: [17]
    readonly property date first: new Date(2026, 7, 30)

    readonly property int columnStart: 32
    readonly property int columnStep: 38
    readonly property int rowStart: 74
    readonly property int rowStep: 26

    width: 292
    height: 202

    Repeater {
        model: [
            { x: 26, glyph: "←" },
            { x: card.width - 26, glyph: "→" }
        ]

        PillButton {
            required property var modelData

            x: modelData.x - width / 2
            y: 24 - height / 2
            width: 24
            height: 24
            radius: height / 2
            emphasis: "quiet"
            label: modelData.glyph
            labelColor: IslandTheme.fg
            labelWeight: Font.Normal
        }
    }

    IslandText {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 24 - height / 2
        text: "September 2026"
        font.pixelSize: IslandTheme.title
        font.weight: Font.DemiBold
    }

    Repeater {
        model: ["S", "M", "T", "W", "T", "F", "S"]

        IslandText {
            required property string modelData
            required property int index

            x: card.columnStart + index * card.columnStep - width / 2
            y: 50 - height / 2
            text: modelData
            tone: "secondary"
            font.pixelSize: IslandTheme.small
        }
    }

    Repeater {
        model: 35

        Item {
            id: cell

            required property int index

            readonly property date date: new Date(card.first.getFullYear(), card.first.getMonth(), card.first.getDate() + index)
            readonly property bool inMonth: date.getMonth() === card.month
            readonly property bool isToday: inMonth && date.getDate() === card.today
            readonly property bool hasEvent: inMonth && card.events.includes(date.getDate())

            x: card.columnStart + (index % 7) * card.columnStep - width / 2
            y: card.rowStart + Math.floor(index / 7) * card.rowStep - height / 2
            width: 22
            height: 22

            Rectangle {
                visible: cell.isToday
                anchors.fill: parent
                radius: width / 2
                color: IslandTheme.fg
            }

            IslandText {
                anchors.centerIn: parent
                text: cell.date.getDate()
                color: cell.isToday ? IslandTheme.pill : cell.inMonth ? IslandTheme.fg : IslandTheme.fg3
                font.weight: cell.isToday ? Font.Bold : Font.Normal
            }

            Rectangle {
                visible: cell.hasEvent
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height - 1
                width: 3
                height: 3
                radius: 1.5
                color: IslandTheme.fg2
            }
        }
    }
}
