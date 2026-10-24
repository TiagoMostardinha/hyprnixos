import QtQuick

IslandCard {
    id: card

    width: 430
    height: 267

    component LockBadge: Rectangle {
        width: 30
        height: 30
        radius: 15
        color: IslandTheme.fg

        LockGlyph {
            anchors.centerIn: parent
            color: IslandTheme.pill
        }
    }

    LockBadge {
        x: 14
        y: 15
    }

    IslandText {
        x: 57
        y: 30 - height / 2
        text: "Authentication required"
        font.pixelSize: 16
        font.weight: Font.Medium
    }

    Rectangle {
        x: 15
        y: 56
        width: card.width - 30
        height: 73
        radius: 14
        color: IslandTheme.card
        border.color: IslandTheme.card2
        border.width: 1

        Column {
            x: 11
            y: 9
            width: parent.width - 22
            spacing: 2

            IslandText {
                width: parent.width
                text: "Authentication is needed to run `/usr/bin/true' as the super user"
                wrapMode: Text.WordWrap
                font.pixelSize: 13
                font.weight: Font.DemiBold
            }

            IslandText {
                text: "org.freedesktop.policykit.exec"
                tone: "secondary"
                font.pixelSize: 11
            }
        }
    }

    IslandText {
        x: 15
        y: 148 - height / 2
        text: "Password"
        tone: "muted"
        font.pixelSize: 11
    }

    Rectangle {
        x: 15
        y: 169
        width: card.width - 30
        height: 40
        radius: height / 2
        color: IslandTheme.pill
        border.color: IslandTheme.fg3
        border.width: 1

        LockBadge {
            x: 5
            anchors.verticalCenter: parent.verticalCenter
        }

        Row {
            x: 47
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            IslandText {
                anchors.verticalCenter: parent.verticalCenter
                text: "••••••••••"
                font.pixelSize: 12
                font.letterSpacing: 1
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 1.5
                height: 18
                color: IslandTheme.fg
            }
        }
    }

    PillButton {
        x: 224
        y: 222
        width: 73
        label: "Cancel"
    }

    PillButton {
        x: 305
        y: 222
        width: 111
        label: "Authenticate"
        emphasis: "primary"
    }
}
