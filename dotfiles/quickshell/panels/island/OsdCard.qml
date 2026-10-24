import QtQuick

Rectangle {
    id: card

    readonly property string side: "center"
    readonly property int drop: 6
    readonly property int gap: 20

    required property real level
    default property alias glyph: glyphSlot.data

    width: 270
    height: 44
    radius: height / 2
    color: IslandTheme.pill

    Item {
        id: glyphSlot

        x: 12
        anchors.verticalCenter: parent.verticalCenter
        width: 16
        height: 16
    }

    LevelBar {
        x: 41
        anchors.verticalCenter: parent.verticalCenter
        width: 181
        level: card.level
    }

    Text {
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        text: Math.round(card.level * 100) + "%"
        color: IslandTheme.fg2
        font.family: IslandTheme.font
        font.pixelSize: 12
    }
}
