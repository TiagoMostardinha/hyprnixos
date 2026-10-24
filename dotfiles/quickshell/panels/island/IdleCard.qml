import QtQuick

IslandCard {
    drop: 0
    gap: 10

    width: 84
    height: 28
    radius: height / 2

    IslandText {
        anchors.centerIn: parent
        text: "00:47"
        font.pixelSize: IslandTheme.large
        font.weight: Font.Medium
    }
}
