import QtQuick

IslandCard {
    id: card

    required property real level
    default property alias glyph: row.glyph

    width: 270
    height: 44
    radius: height / 2

    LevelRow {
        id: row

        anchors.fill: parent
        level: card.level
    }
}
