import QtQuick

IslandCard {
    id: card

    required property real level
    default property alias glyph: row.glyph

    width: 230
    height: 30
    radius: height / 2

    LevelRow {
        id: row

        anchors.fill: parent
        level: card.level
    }
}
