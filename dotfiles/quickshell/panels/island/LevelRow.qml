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

    // When interactive, scrolling over the row or dragging along it asks for a new level.
    property bool interactive: false
    readonly property bool active: area.containsMouse || area.pressed
    signal moved(real level)

    function clamp(value) {
        return Math.max(0, Math.min(1, value));
    }

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

    MouseArea {
        id: area

        anchors.fill: parent
        enabled: row.interactive
        hoverEnabled: true
        preventStealing: true
        onPressed: mouse => row.moved(row.clamp((mouse.x - row.barX) / row.barWidth))
        onPositionChanged: mouse => {
            if (pressed)
                row.moved(row.clamp((mouse.x - row.barX) / row.barWidth));
        }
        onWheel: wheel => row.moved(row.clamp(row.level + wheel.angleDelta.y / 120 * 0.05))
    }
}
