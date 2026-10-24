import QtQuick

IslandCard {
    id: card

    side: "solo"
    drop: 0
    gap: 0

    readonly property real battery: 0.72

    width: 460
    height: 190
    radius: 26

    component IconBox: Rectangle {
        y: 146
        width: 28
        height: 28
        radius: 8
        color: IslandTheme.card2
    }

    component BoxGlyph: PathGlyph {
        anchors.centerIn: parent
        color: IslandTheme.fg2
        strokeWidth: 1.6
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

        IslandText {
            id: user

            text: "tiago"
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        IslandText {
            anchors.baseline: user.baseline
            text: "(latitude-7340)"
            tone: "secondary"
            font.pixelSize: 12
        }
    }

    IslandText {
        x: 86
        line: 62
        text: "up 2 hours, 23 minutes"
        tone: "muted"
        font.pixelSize: 11
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 24
        y: 44 - percent.baselineOffset
        spacing: 7

        BatteryGlyph {
            anchors.verticalCenter: percent.verticalCenter
            level: card.battery
        }

        IslandText {
            id: percent

            text: Math.round(card.battery * 100) + "%"
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

    IslandText {
        x: 46
        line: 102
        text: "192.168.1.30"
        font.pixelSize: 14
        font.weight: Font.DemiBold
    }

    IslandText {
        x: 24
        line: 124
        text: "eth0"
        tone: "secondary"
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

        IslandText {
            x: 18
            line: 12
            text: "tailscale"
            tone: "secondary"
            font.pixelSize: 9
        }
    }

    IslandText {
        x: card.width - 24 - width
        line: 102
        text: "↓ 407 MB"
        font.pixelSize: 12
    }

    IslandText {
        x: card.width - 24 - width
        line: 122
        text: "↑ 46 MB"
        tone: "secondary"
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

        LockGlyph {
            anchors.centerIn: parent
            color: IslandTheme.fg2
        }
    }

    IconBox {
        x: 58

        BoxGlyph {
            fill: "M 7.162 3.058 A 6 6 0 1 0 13.164 12.056 A 5.5 5.5 0 0 1 7.162 3.058 Z"
        }
    }

    IslandText {
        anchors.horizontalCenter: parent.horizontalCenter
        line: 165
        text: "01:51  Sat, 24 Oct 2026"
        tone: "secondary"
        font.pixelSize: 11
    }

    IconBox {
        x: card.width - 86

        BoxGlyph {
            stroke: "M 13 9 A 5 5 0 1 1 10 4.5 M 9 1.5 L 12 4.5 L 8 6.5"
        }
    }

    IconBox {
        x: card.width - 52

        BoxGlyph {
            stroke: "M 11.5 5 A 5.5 5.5 0 1 1 4.5 5 M 8 2 V 8"
        }
    }
}
