import QtQuick

IslandCard {
    drop: 0
    gap: 12

    width: 90
    height: 32
    radius: height / 2

    IslandText {
        anchors.centerIn: parent
        text: "00:47"
        font.pixelSize: 16
        font.weight: Font.Medium
    }
}
