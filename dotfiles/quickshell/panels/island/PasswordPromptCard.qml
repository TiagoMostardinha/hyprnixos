import QtQuick

// The password prompt used on the island: lock badge and title, a message box (message + detail),
// a status line above the field (turns white on error), the password field and an action button.
// Polkit fills it in.
IslandCard {
    id: card

    property string title
    property string message
    property string detail
    property string status: "Password"
    property bool error: false
    property bool visibleText: false
    property string buttonLabel
    property bool locked: false

    signal submitted(string password)

    function submit() {
        if (locked)
            return;
        submitted(field.text);
        if (!locked)
            field.text = "";
    }

    onLockedChanged: if (!locked)
        field.text = ""

    width: 400
    height: field.y + field.height + 12

    Component.onCompleted: field.focusInput()

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
        width: card.width - x - 12
        elide: Text.ElideRight
        text: card.title
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
                text: card.message
                wrapMode: Text.WordWrap
                font.weight: Font.DemiBold
            }

            IslandText {
                text: card.detail
                tone: "secondary"
                font.pixelSize: IslandTheme.small
            }
        }
    }

    IslandText {
        x: 14
        line: message.y + message.height + 18
        text: card.status
        tone: card.error ? "primary" : "muted"
        font.pixelSize: IslandTheme.small
    }

    PasswordField {
        id: field

        x: 12
        y: message.y + message.height + 24
        width: action.x - x - 6
        error: card.error
        visibleText: card.visibleText
        readOnly: card.locked
        onAccepted: card.submit()
    }

    PillButton {
        id: action

        x: card.width - 12 - width
        y: field.y
        width: 92
        height: field.height
        label: card.buttonLabel
        emphasis: "primary"
        onClicked: card.submit()
    }
}
