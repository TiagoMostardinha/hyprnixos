import QtQuick
import QtQuick.Shapes

Rectangle {
    id: card

    readonly property string side: "solo"
    readonly property int drop: 0
    readonly property int gap: 0

    readonly property real battery: 0.72

    width: 460
    height: 190
    radius: 26
    color: IslandTheme.pill

    component Label: Text {
        property real line

        y: line - baselineOffset
        font.family: IslandTheme.font
    }

    component IconBox: Rectangle {
        default property alias paths: glyph.data

        y: 146
        width: 28
        height: 28
        radius: 8
        color: IslandTheme.card2

        Shape {
            id: glyph

            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
        }
    }

    component Stroke: ShapePath {
        property alias d: svg.path

        strokeColor: IslandTheme.fg2
        strokeWidth: 1.6
        fillColor: "transparent"
        capStyle: ShapePath.RoundCap

        PathSvg { id: svg }
    }

    component Fill: ShapePath {
        property alias d: svg.path
        property color color: IslandTheme.fg2

        strokeColor: "transparent"
        fillColor: color

        PathSvg { id: svg }
    }

    Rectangle {
        x: 20
        y: 20
        width: 52
        height: 52
        radius: 26
        color: IslandTheme.card2
    }

    Row {
        x: 86
        y: 42 - user.baselineOffset
        spacing: 6

        Text {
            id: user

            text: "tiago"
            color: IslandTheme.fg
            font.family: IslandTheme.font
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        Text {
            anchors.baseline: user.baseline
            text: "(latitude-7340)"
            color: IslandTheme.fg2
            font.family: IslandTheme.font
            font.pixelSize: 12
        }
    }

    Label {
        x: 86
        line: 62
        text: "up 2 hours, 23 minutes"
        color: IslandTheme.fg3
        font.pixelSize: 11
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 24
        y: 44 - percent.baselineOffset
        spacing: 7

        Item {
            anchors.verticalCenter: percent.verticalCenter
            width: 25
            height: 12

            Rectangle {
                width: 22
                height: 12
                radius: 3.5
                color: "transparent"
                border.color: IslandTheme.fg
                border.width: 1.5

                Rectangle {
                    x: 2.5
                    anchors.verticalCenter: parent.verticalCenter
                    width: (parent.width - 5) * card.battery
                    height: parent.height - 5
                    radius: 1.5
                    color: IslandTheme.fg
                }
            }

            Rectangle {
                x: 23
                anchors.verticalCenter: parent.verticalCenter
                width: 2
                height: 5
                radius: 1
                color: IslandTheme.fg
            }
        }

        Text {
            id: percent

            text: Math.round(card.battery * 100) + "%"
            color: IslandTheme.fg
            font.family: IslandTheme.font
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }
    }

    Rectangle {
        x: 24
        y: 90
        width: 14
        height: 14
        radius: 4
        color: IslandTheme.fg
    }

    Label {
        x: 46
        line: 102
        text: "192.168.1.30"
        color: IslandTheme.fg
        font.pixelSize: 14
        font.weight: Font.DemiBold
    }

    Label {
        x: 24
        line: 124
        text: "eth0"
        color: IslandTheme.fg2
        font.pixelSize: 11
    }

    Rectangle {
        x: 60
        y: 113
        width: 64
        height: 16
        radius: 8
        color: IslandTheme.card2

        Rectangle {
            x: 10 - width / 2
            anchors.verticalCenter: parent.verticalCenter
            width: 7
            height: 7
            radius: 3.5
            color: IslandTheme.fg
        }

        Label {
            x: 18
            line: 12
            text: "tailscale"
            color: IslandTheme.fg2
            font.pixelSize: 9
        }
    }

    Label {
        x: card.width - 24 - width
        line: 102
        text: "↓ 407 MB"
        color: IslandTheme.fg
        font.pixelSize: 12
    }

    Label {
        x: card.width - 24 - width
        line: 122
        text: "↑ 46 MB"
        color: IslandTheme.fg2
        font.pixelSize: 12
    }

    Rectangle {
        x: 14
        y: 142
        width: card.width - 28
        height: 36
        radius: 14
        color: IslandTheme.card
    }

    IconBox {
        x: 24

        Stroke { strokeWidth: 1.5; d: "M 11 14 V 11 A 3 3 0 0 1 17 11 V 14" }
        Fill { d: "M 11 14 H 17 A 1.5 1.5 0 0 1 18.5 15.5 V 19.5 A 1.5 1.5 0 0 1 17 21 H 11 A 1.5 1.5 0 0 1 9.5 19.5 V 15.5 A 1.5 1.5 0 0 1 11 14 Z" }
    }

    IconBox {
        x: 58

        Fill { d: "M 8 15 A 6 6 0 1 0 20 15 A 6 6 0 1 0 8 15 Z" }
        Fill { color: IslandTheme.card2; d: "M 11.5 13 A 5.5 5.5 0 1 0 22.5 13 A 5.5 5.5 0 1 0 11.5 13 Z" }
    }

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        line: 165
        text: "01:51  Sat, 24 Oct 2026"
        color: IslandTheme.fg2
        font.pixelSize: 11
    }

    IconBox {
        x: card.width - 86

        Stroke { d: "M 19 15 A 5 5 0 1 1 16 10.5" }
        Stroke { d: "M 15 7.5 L 18 10.5 L 14 12.5" }
    }

    IconBox {
        x: card.width - 52

        Stroke { d: "M 17.5 11 A 5.5 5.5 0 1 1 10.5 11" }
        Stroke { d: "M 14 8 V 14" }
    }
}
