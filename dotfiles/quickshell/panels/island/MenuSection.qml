import QtQuick

// A small grey label over a menu card's rows, straight on the card. Each entry in `model` has a name,
// detail, icon, `on` (connected: white row) and optionally `locked` (lock on the right). Grey box on
// hover; clicking a row emits activated(entry).
Item {
    id: section

    property alias title: sectionTitle.text
    property alias model: rows.model

    signal activated(var entry)

    height: rowsColumn.y + rowsColumn.height

    IslandText {
        id: sectionTitle

        x: 4
        line: 12
        tone: "secondary"
        font.pixelSize: IslandTheme.small
    }

    Column {
        id: rowsColumn

        y: 20
        width: parent.width
        spacing: 4

        Repeater {
            id: rows

            ListRow {
                id: row

                required property var modelData

                width: parent.width
                height: 34
                radius: IslandTheme.radiusButton
                highlight: modelData.on ? "strong" : "none"
                textX: 34
                fill: rowArea.containsMouse ? IslandTheme.hover : "transparent"
                title: modelData.name
                titleSize: IslandTheme.body
                subtitle: modelData.detail
                subtitleSize: IslandTheme.tiny

                SymbolicIcon {
                    x: 10
                    anchors.verticalCenter: parent.verticalCenter
                    name: row.modelData.icon
                    color: row.inverted ? IslandTheme.pill : IslandTheme.fg
                }

                LockGlyph {
                    visible: row.modelData.locked ?? false
                    x: parent.width - 10 - width
                    anchors.verticalCenter: parent.verticalCenter
                    color: row.inverted ? IslandTheme.pill : IslandTheme.fg2
                }

                MouseArea {
                    id: rowArea

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: section.activated(row.modelData)
                }
            }
        }
    }
}
