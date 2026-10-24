import QtQuick

IslandCard {
    id: card

    side: "solo"
    drop: 0
    gap: 0

    readonly property real battery: 0.72

    width: 420
    height: 146

    component IconBox: Rectangle {
        y: 110
        width: 22
        height: 22
        radius: IslandTheme.radiusSmall
        color: IslandTheme.card2
    }

    component BoxGlyph: PathGlyph {
        anchors.centerIn: parent
        color: IslandTheme.fg2
        strokeWidth: 1.4
    }

    Rectangle {
        x: 12
        y: 12
        width: 40
        height: 40
        radius: 20
        color: IslandTheme.card2
    }

    Row {
        x: 62
        y: 28 - user.baselineOffset
        spacing: 6

        IslandText {
            id: user

            text: "tiago"
            font.pixelSize: IslandTheme.heading
            font.weight: Font.DemiBold
        }

        IslandText {
            anchors.baseline: user.baseline
            text: "(latitude-7340)"
            tone: "secondary"
            font.pixelSize: IslandTheme.small
        }
    }

    IslandText {
        x: 62
        line: 44
        text: "up 2 hours, 23 minutes"
        tone: "muted"
        font.pixelSize: IslandTheme.small
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 14
        y: 30 - percent.baselineOffset
        spacing: 6

        BatteryGlyph {
            anchors.verticalCenter: percent.verticalCenter
            level: card.battery
        }

        IslandText {
            id: percent

            text: Math.round(card.battery * 100) + "%"
            font.pixelSize: IslandTheme.heading
            font.weight: Font.DemiBold
        }
    }

    Rectangle {
        x: 14
        y: 66
        width: 10
        height: 10
        radius: 3
        color: IslandTheme.fg
    }

    IslandText {
        x: 30
        line: 75
        text: "192.168.1.30"
        font.pixelSize: IslandTheme.title
        font.weight: Font.DemiBold
    }

    IslandText {
        x: 14
        line: 93
        text: "eth0"
        tone: "secondary"
        font.pixelSize: IslandTheme.small
    }

    Rectangle {
        x: 44
        y: 83
        width: 56
        height: 14
        radius: 7
        color: IslandTheme.card2

        Rectangle {
            x: 8 - width / 2
            anchors.verticalCenter: parent.verticalCenter
            width: 6
            height: 6
            radius: 3
            color: IslandTheme.fg
        }

        IslandText {
            x: 15
            line: 10.5
            text: "tailscale"
            tone: "secondary"
            font.pixelSize: IslandTheme.tiny
        }
    }

    IslandText {
        x: card.width - 14 - width
        line: 75
        text: "↓ 407 MB"
    }

    IslandText {
        x: card.width - 14 - width
        line: 93
        text: "↑ 46 MB"
        tone: "secondary"
    }

    Rectangle {
        x: 10
        y: 106
        width: card.width - 20
        height: 30
        radius: IslandTheme.radiusSection
        color: IslandTheme.card
    }

    IconBox {
        x: 14

        LockGlyph {
            anchors.centerIn: parent
            color: IslandTheme.fg2
        }
    }

    IconBox {
        x: 40

        BoxGlyph {
            fill: "M 7.162 3.058 A 6 6 0 1 0 13.164 12.056 A 5.5 5.5 0 0 1 7.162 3.058 Z"
        }
    }

    IslandText {
        anchors.horizontalCenter: parent.horizontalCenter
        line: 125
        text: "01:51  Sat, 24 Oct 2026"
        tone: "secondary"
        font.pixelSize: IslandTheme.small
    }

    IconBox {
        x: card.width - 62

        BoxGlyph {
            stroke: "M 13 9 A 5 5 0 1 1 10 4.5 M 9 1.5 L 12 4.5 L 8 6.5"
        }
    }

    IconBox {
        x: card.width - 36

        BoxGlyph {
            stroke: "M 11.5 5 A 5.5 5.5 0 1 1 4.5 5 M 8 2 V 8"
        }
    }
}
