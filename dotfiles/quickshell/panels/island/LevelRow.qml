import QtQuick

Item {
    id: row

    property real level
    property real glyphX: 10
    property real barX: 30
    property real barWidth: 154
    property real barHeight: 5
    property real textMargin: 12
    property int textSize: IslandTheme.small
    default property alias glyph: slot.data

    Item {
        id: slot

        x: row.glyphX
        anchors.verticalCenter: parent.verticalCenter
        width: IslandTheme.icon
        height: IslandTheme.icon
    }

    LevelBar {
        x: row.barX
        anchors.verticalCenter: parent.verticalCenter
        width: row.barWidth
        height: row.barHeight
        level: row.level
    }

    IslandText {
        anchors.right: parent.right
        anchors.rightMargin: row.textMargin
        anchors.verticalCenter: parent.verticalCenter
        text: Math.round(row.level * 100) + "%"
        tone: "secondary"
        font.pixelSize: row.textSize
    }
}
