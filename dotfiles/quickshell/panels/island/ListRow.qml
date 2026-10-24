import QtQuick

Rectangle {
    id: row

    property string overline: ""
    property string title: ""
    property string subtitle: ""
    property string highlight: "none"
    property color fill: "transparent"

    property real textX: 42
    property real spacing: 0
    property int overlineSize: 10
    property int titleSize: 13
    property int titleWeight: Font.DemiBold
    property int subtitleSize: 10

    readonly property bool inverted: highlight === "strong"
    readonly property color ink: inverted ? IslandTheme.pill : IslandTheme.fg
    readonly property color inkMuted: inverted ? IslandTheme.card2 : IslandTheme.fg2

    color: inverted ? IslandTheme.fg : highlight === "subtle" ? IslandTheme.card2 : fill

    Rectangle {
        visible: row.highlight === "subtle"
        x: 2
        anchors.verticalCenter: parent.verticalCenter
        width: 3
        height: 22
        radius: 1.5
        color: IslandTheme.fg
    }

    Column {
        x: row.textX
        anchors.verticalCenter: parent.verticalCenter
        spacing: row.spacing

        IslandText {
            visible: text !== ""
            text: row.overline
            color: row.inkMuted
            font.pixelSize: row.overlineSize
        }

        IslandText {
            visible: text !== ""
            text: row.title
            color: row.ink
            font.pixelSize: row.titleSize
            font.weight: row.titleWeight
        }

        IslandText {
            visible: text !== ""
            text: row.subtitle
            color: row.inkMuted
            font.pixelSize: row.subtitleSize
        }
    }
}
