import QtQuick

IslandCard {
    id: card

    required property real level
    default property alias glyph: row.glyph
    readonly property alias active: row.active

    signal moved(real level)

    width: 230
    height: 30
    radius: height / 2

    LevelRow {
        id: row

        anchors.fill: parent
        level: card.level
        interactive: true
        onMoved: level => card.moved(level)
    }
}
