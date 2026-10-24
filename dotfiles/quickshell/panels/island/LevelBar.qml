import QtQuick

Rectangle {
    property real level

    height: 6
    radius: height / 2
    color: IslandTheme.card2

    Rectangle {
        width: Math.max(parent.height, parent.width * parent.level)
        height: parent.height
        radius: parent.radius
        color: IslandTheme.fg
    }
}
