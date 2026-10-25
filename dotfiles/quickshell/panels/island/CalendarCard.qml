import QtQuick
import "../../services"

IslandCard {
    id: card

    // Months away from the current one; the arrows step it.
    property int shift: 0
    readonly property date shown: new Date(Time.date.getFullYear(), Time.date.getMonth() + shift, 1)
    readonly property int year: shown.getFullYear()
    readonly property int month: shown.getMonth()
    readonly property int today: shift === 0 ? Time.date.getDate() : 0
    readonly property var events: []
    // The grid starts on the Sunday on or before the 1st and always shows six weeks, enough for any month.
    readonly property int lead: new Date(year, month, 1).getDay()
    readonly property date first: new Date(year, month, 1 - lead)
    readonly property int rows: 6

    readonly property int columnStart: 32
    readonly property int columnStep: 38
    readonly property int rowStart: 74
    readonly property int rowStep: 26

    width: 292
    height: rowStart + (rows - 1) * rowStep + 24

    Repeater {
        model: [
            { x: 26, glyph: "←", step: -1 },
            { x: card.width - 26, glyph: "→", step: 1 }
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
            onClicked: card.shift += modelData.step
        }
    }

    IslandText {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 24 - height / 2
        text: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"][card.month] + " " + card.year
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
        model: card.rows * 7

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
                visible: cell.isToday || hover.containsMouse
                anchors.centerIn: parent
                width: 22
                height: 24
                radius: IslandTheme.radiusSmall
                opacity: cell.isToday ? 1 : 0.6
                color: cell.isToday ? IslandTheme.fg : IslandTheme.card
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

            MouseArea {
                id: hover

                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }
}
