import QtQuick

Rectangle {
    width: 28
    height: width
    radius: width / 2
    color: IslandTheme.pill

    MediaArt {
        anchors.centerIn: parent
        width: parent.width - 10
        height: width
        radius: 6
        iconSize: 14
    }
}
