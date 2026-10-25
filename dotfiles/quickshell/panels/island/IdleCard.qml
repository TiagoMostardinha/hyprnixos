import QtQuick
import "../../services"

IslandCard {
    drop: 0
    gap: 10

    width: 84
    height: 28
    radius: height / 2

    IslandText {
        anchors.centerIn: parent
        text: Qt.formatTime(Time.date, "hh:mm")
        font.pixelSize: IslandTheme.large
        font.weight: Font.Medium
    }
}
