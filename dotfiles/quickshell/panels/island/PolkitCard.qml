import QtQuick
import "../../services"

IslandCard {
    id: card

    width: 400
    height: field.y + field.height + 12

    function submit() {
        if (!Polkit.flow?.isResponseRequired)
            return;
        Polkit.flow.submit(password.text);
        password.text = "";
    }

    Component.onCompleted: password.forceActiveFocus()

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
                text: Polkit.flow?.message ?? ""
                wrapMode: Text.WordWrap
                font.weight: Font.DemiBold
            }

            IslandText {
                text: Polkit.flow?.actionId ?? ""
                tone: "secondary"
                font.pixelSize: IslandTheme.small
            }
        }
    }

    IslandText {
        x: 14
        line: message.y + message.height + 18
        // After a wrong password the label turns into a warning with the attempts left.
        text: Polkit.failures > 0 ? `Wrong password, ${Polkit.attemptsLeft} ${Polkit.attemptsLeft === 1 ? "attempt" : "attempts"} left` : "Password"
        tone: Polkit.failures > 0 ? "primary" : "muted"
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
        border.color: Polkit.failures > 0 ? IslandTheme.fg : IslandTheme.fg3
        border.width: 1

        LockGlyph {
            x: 8
            anchors.verticalCenter: parent.verticalCenter
            color: IslandTheme.fg2
        }

        IslandText {
            visible: password.text === ""
            x: 26
            anchors.verticalCenter: parent.verticalCenter
            text: "Enter your password"
            tone: "muted"
        }

        TextInput {
            id: password

            x: 26
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - x - 8
            clip: true
            color: IslandTheme.fg
            font.family: IslandTheme.font
            font.pixelSize: IslandTheme.body
            font.letterSpacing: 1
            echoMode: Polkit.flow?.responseVisible ? TextInput.Normal : TextInput.Password
            passwordCharacter: "•"

            cursorDelegate: Rectangle {
                width: 1.5
                color: IslandTheme.fg
            }

            Keys.onReturnPressed: card.submit()
            Keys.onEnterPressed: card.submit()
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
        onClicked: card.submit()
    }
}
