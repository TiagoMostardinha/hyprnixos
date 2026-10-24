import QtQuick

IslandCard {
    id: card

    width: 400
    height: field.y + field.height + 12

    component LockBadge: Rectangle {
        width: 20
        height: 20
        radius: 10
        color: IslandTheme.fg

        LockGlyph {
            anchors.centerIn: parent
            color: IslandTheme.pill
        }
    }

    LockBadge {
        x: 12
        y: 12
    }

    IslandText {
        x: 40
        y: 22 - height / 2
        text: "Authentication required"
        font.pixelSize: IslandTheme.heading
        font.weight: Font.Medium
    }

    Rectangle {
        id: message

        x: 12
        y: 40
        width: card.width - 24
        height: details.height + 16
        radius: IslandTheme.radiusSection
        color: IslandTheme.card
        border.color: IslandTheme.card2
        border.width: 1

        Column {
            id: details

            x: 10
            y: 8
            width: parent.width - 20
            spacing: 2

            IslandText {
                width: parent.width
                text: "Authentication is needed to run `/usr/bin/true' as the super user"
                wrapMode: Text.WordWrap
                font.weight: Font.DemiBold
            }

            IslandText {
                text: "org.freedesktop.policykit.exec"
                tone: "secondary"
                font.pixelSize: IslandTheme.small
            }
        }
    }

    IslandText {
        x: 14
        line: message.y + message.height + 18
        text: "Password"
        tone: "muted"
        font.pixelSize: IslandTheme.small
    }

    Rectangle {
        id: field

        x: 12
        y: message.y + message.height + 24
        width: authenticate.x - x - 6
        height: 28
        radius: IslandTheme.radiusButton
        color: IslandTheme.pill
        border.color: IslandTheme.fg3
        border.width: 1

        LockGlyph {
            x: 8
            anchors.verticalCenter: parent.verticalCenter
            color: IslandTheme.fg2
        }

        Row {
            x: 26
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            IslandText {
                anchors.verticalCenter: parent.verticalCenter
                text: "••••••••••"
                font.letterSpacing: 1
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 1.5
                height: 15
                color: IslandTheme.fg
            }
        }
    }

    PillButton {
        id: authenticate

        x: card.width - 12 - width
        y: field.y
        width: 92
        height: field.height
        label: "Authenticate"
        emphasis: "primary"
    }
}
