import QtQuick

IslandCard {
    width: 360
    height: 48

    ListRow {
        anchors.fill: parent
        textX: 40
        overline: "notify-send"
        title: "hello"
        subtitle: "hi"

        Rectangle {
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 24
            height: 24
            radius: 12
            color: IslandTheme.card

            IslandText {
                anchors.centerIn: parent
                text: "N"
                font.weight: Font.DemiBold
            }
        }
    }
}
