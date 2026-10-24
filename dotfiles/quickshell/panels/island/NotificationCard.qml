import QtQuick

Rectangle {
    id: card

    readonly property string side: "center"
    readonly property int drop: 6
    readonly property int gap: 20

    width: 449
    height: 68
    radius: 30
    color: IslandTheme.pill

    Rectangle {
        x: 11
        anchors.verticalCenter: parent.verticalCenter
        width: 36
        height: 36
        radius: 18
        color: IslandTheme.card

        Text {
            anchors.centerIn: parent
            text: "N"
            color: IslandTheme.fg
            font.family: IslandTheme.font
            font.pixelSize: 13
            font.weight: Font.DemiBold
        }
    }

    Column {
        x: 59
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Text {
            text: "notify-send"
            color: IslandTheme.fg2
            font.family: IslandTheme.font
            font.pixelSize: 12
        }

        Text {
            text: "hello"
            color: IslandTheme.fg
            font.family: IslandTheme.font
            font.pixelSize: 14
            font.weight: Font.DemiBold
        }

        Text {
            text: "hi"
            color: IslandTheme.fg2
            font.family: IslandTheme.font
            font.pixelSize: 12
        }
    }
}
