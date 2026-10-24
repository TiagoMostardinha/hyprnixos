import QtQuick

Rectangle {
    readonly property string side: "center"
    readonly property int drop: 0
    readonly property int gap: 12

    width: 90
    height: 32
    radius: height / 2
    color: IslandTheme.pill

    Text {
        anchors.centerIn: parent
        text: "00:47"
        color: IslandTheme.fg
        font.family: IslandTheme.font
        font.pixelSize: 16
        font.weight: Font.Medium
    }
}
