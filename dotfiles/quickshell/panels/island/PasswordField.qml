import QtQuick

// A password box: lock glyph, placeholder, dotted input; Enter emits accepted(). Used by the polkit
// prompt.
Rectangle {
    id: field

    property alias text: input.text
    property alias readOnly: input.readOnly
    property bool visibleText: false
    property bool error: false
    property string placeholder: "Enter your password"

    signal accepted

    function focusInput() {
        input.forceActiveFocus();
    }

    height: 28
    radius: IslandTheme.radiusButton
    color: IslandTheme.pill
    border.color: error ? IslandTheme.fg : IslandTheme.fg3
    border.width: 1

    LockGlyph {
        x: 8
        anchors.verticalCenter: parent.verticalCenter
        color: IslandTheme.fg2
    }

    IslandText {
        visible: input.text === ""
        x: 26
        anchors.verticalCenter: parent.verticalCenter
        text: field.placeholder
        tone: "muted"
    }

    TextInput {
        id: input

        x: 26
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - x - 8
        clip: true
        color: IslandTheme.fg
        font.family: IslandTheme.font
        font.pixelSize: IslandTheme.body
        font.letterSpacing: 1
        echoMode: field.visibleText ? TextInput.Normal : TextInput.Password
        passwordCharacter: "•"

        cursorDelegate: Rectangle {
            width: 1.5
            color: IslandTheme.fg
        }

        Keys.onReturnPressed: field.accepted()
        Keys.onEnterPressed: field.accepted()
    }
}
