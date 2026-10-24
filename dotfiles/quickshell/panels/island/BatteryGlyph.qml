import QtQuick

Item {
    id: glyph

    property real level
    property color color: IslandTheme.fg

    width: 25
    height: 12

    Rectangle {
        width: 22
        height: 12
        radius: 3.5
        color: "transparent"
        border.color: glyph.color
        border.width: 1.5

        Rectangle {
            x: 2.5
            anchors.verticalCenter: parent.verticalCenter
            width: (parent.width - 5) * glyph.level
            height: parent.height - 5
            radius: 1.5
            color: glyph.color
        }
    }

    Rectangle {
        x: 23
        anchors.verticalCenter: parent.verticalCenter
        width: 2
        height: 5
        radius: 1
        color: glyph.color
    }
}
