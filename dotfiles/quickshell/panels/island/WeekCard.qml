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

    width: 254
    height: 116
    radius: 28

    IslandText {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 18
        text: "00:47"
        font.pixelSize: 26
        font.weight: Font.Medium
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 62
        width: 32
        height: 40
        radius: 9
        color: IslandTheme.card
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 64

        Repeater {
            model: card.week

            Column {
                required property var modelData
                required property int index

                readonly property int distance: Math.abs(index - card.today)
                readonly property bool isToday: distance === 0

                width: 28
                spacing: 2
                opacity: [1, 0.75, 0.45, 0.2][distance]

                IslandText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: parent.modelData.label
                    tone: parent.isToday ? "secondary" : "muted"
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                }

                IslandText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 20
                    verticalAlignment: Text.AlignVCenter
                    text: parent.modelData.day
                    tone: parent.isToday ? "primary" : "secondary"
                    font.pixelSize: parent.isToday ? 18 : 13
                    font.weight: parent.isToday ? Font.DemiBold : Font.Medium
                }
            }
        }
    }
}
