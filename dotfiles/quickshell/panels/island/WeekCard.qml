import QtQuick

IslandCard {
    id: card

    readonly property var week: [
        { label: "W", day: 9 },
        { label: "T", day: 10 },
        { label: "F", day: 11 },
        { label: "SAT", day: 12 },
        { label: "S", day: 13 },
        { label: "M", day: 14 },
        { label: "T", day: 15 }
    ]
    readonly property int today: 3

    width: 210
    height: 84

    IslandText {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 10
        text: "00:47"
        font.pixelSize: IslandTheme.display
        font.weight: Font.Medium
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 40
        width: 28
        height: 34
        radius: IslandTheme.radiusSmall
        color: IslandTheme.card
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 42

        Repeater {
            model: card.week

            Column {
                required property var modelData
                required property int index

                readonly property int distance: Math.abs(index - card.today)
                readonly property bool isToday: distance === 0

                width: 26
                opacity: [1, 0.75, 0.45, 0.2][distance]

                IslandText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: parent.modelData.label
                    tone: parent.isToday ? "secondary" : "muted"
                    font.pixelSize: IslandTheme.tiny
                    font.weight: Font.DemiBold
                }

                IslandText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 18
                    verticalAlignment: Text.AlignVCenter
                    text: parent.modelData.day
                    tone: parent.isToday ? "primary" : "secondary"
                    font.pixelSize: parent.isToday ? IslandTheme.large : IslandTheme.body
                    font.weight: parent.isToday ? Font.DemiBold : Font.Medium
                }
            }
        }
    }
}
