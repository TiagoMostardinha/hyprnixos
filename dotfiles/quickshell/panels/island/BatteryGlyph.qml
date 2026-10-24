import QtQuick

Item {
    id: glyph

    property real level
    property color color: IslandTheme.fg

    width: 21
    height: 10

    Rectangle {
        width: 19
        height: parent.height
        radius: 3
        color: "transparent"
        border.color: glyph.color
        border.width: 1.3

        Rectangle {
            x: 2.3
            anchors.verticalCenter: parent.verticalCenter
            width: (parent.width - 4.6) * glyph.level
            height: parent.height - 4.6
            radius: 1.2
            color: glyph.color
        }
    }

    Rectangle {
        x: 19.5
        anchors.verticalCenter: parent.verticalCenter
        width: 1.5
        height: 4
        radius: 0.75
        color: glyph.color
    }
}
