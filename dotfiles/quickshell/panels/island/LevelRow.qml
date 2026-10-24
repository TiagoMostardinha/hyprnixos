import QtQuick

Item {
    id: row

    property real level
    property real glyphX: 12
    property real barX: 41
    property real barWidth: 181
    property real barHeight: 6
    property real textMargin: 16
    property int textSize: 12
    default property alias glyph: slot.data

    Item {
        id: slot

        x: row.glyphX
        anchors.verticalCenter: parent.verticalCenter
        width: 16
        height: 16
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
