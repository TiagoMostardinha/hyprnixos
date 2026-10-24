import QtQuick

Rectangle {
    id: row

    property string overline: ""
    property string title: ""
    property string subtitle: ""
    property string highlight: "none"
    property color fill: "transparent"

    property real textX: 36
    property real spacing: 0
    property int overlineSize: IslandTheme.tiny
    property int titleSize: IslandTheme.title
    property int titleWeight: Font.DemiBold
    property int subtitleSize: IslandTheme.small

    readonly property bool inverted: highlight === "strong"
    readonly property color ink: inverted ? IslandTheme.pill : IslandTheme.fg
    readonly property color inkMuted: inverted ? IslandTheme.card2 : IslandTheme.fg2

    radius: IslandTheme.radiusSection
    color: inverted ? IslandTheme.fg : highlight === "subtle" ? IslandTheme.card2 : fill

    Rectangle {
        visible: row.highlight === "subtle"
        x: 2
        anchors.verticalCenter: parent.verticalCenter
        width: 3
        height: parent.height / 2
        radius: 1.5
        color: IslandTheme.fg
    }

    Column {
        x: row.textX
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - row.textX - 8
        spacing: row.spacing

        IslandText {
            visible: text !== ""
            width: parent.width
            elide: Text.ElideRight
            text: row.overline
            color: row.inkMuted
            font.pixelSize: row.overlineSize
        }

        IslandText {
            visible: text !== ""
            width: parent.width
            elide: Text.ElideRight
            text: row.title
            color: row.ink
            font.pixelSize: row.titleSize
            font.weight: row.titleWeight
        }

        IslandText {
            visible: text !== ""
            width: parent.width
            elide: Text.ElideRight
            text: row.subtitle
            color: row.inkMuted
            font.pixelSize: row.subtitleSize
        }
    }
}
