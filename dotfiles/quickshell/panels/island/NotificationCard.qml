import QtQuick

IslandCard {
    width: 449
    height: 68

    ListRow {
        anchors.fill: parent
        textX: 59
        overline: "notify-send"
        overlineSize: 12
        title: "hello"
        titleSize: 14
        subtitle: "hi"
        subtitleSize: 12

        Rectangle {
            x: 11
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 36
            radius: 18
            color: IslandTheme.card

            IslandText {
                anchors.centerIn: parent
                text: "N"
                font.pixelSize: 13
                font.weight: Font.DemiBold
            }
        }
    }
}
