import QtQuick

Rectangle {
    width: 32
    height: 32
    radius: 16
    color: IslandTheme.pill

    Rectangle {
        anchors.centerIn: parent
        width: 22
        height: 22
        radius: 7
        color: IslandTheme.card2
    }
}
