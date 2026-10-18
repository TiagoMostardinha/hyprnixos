import QtQuick
import "../theme"
import "../services"

// The login look, shared by the greeter and the lock screen: wallpaper,
// date + clock on top, avatar + name + password prompt + status at the bottom.
// The owner keeps the state (password, busy, failed) so several screens can
// share it; this item only shows it and reports input.
Item {
    id: root

    required property string password
    required property bool busy
    required property bool failed

    signal edited(string text)
    signal submitted

    readonly property real h: height

    Rectangle {
        anchors.fill: parent
        color: Theme.login.background
    }

    Image {
        anchors.fill: parent
        source: Theme.wallpaper
        sourceSize.width: width // decode at screen size, not full resolution
        fillMode: Image.PreserveAspectCrop
    }

    DateClock {
        anchors.fill: parent
    }

    // Invisible input that owns the keyboard; the dots are drawn below.
    TextInput {
        id: input

        opacity: 0
        focus: true
        enabled: !root.busy
        echoMode: TextInput.Password
        onTextChanged: if (text !== root.password) root.edited(text)
        onAccepted: if (text.length > 0) root.submitted()
        Keys.onReleased: event => {
            if (event.key === Qt.Key_CapsLock)
                CapsLock.refresh();
        }
        Component.onCompleted: forceActiveFocus()
    }

    // Follow the shared password (typed on another screen, or cleared).
    onPasswordChanged: if (input.text !== password) input.text = password
    onBusyChanged: if (!busy) input.forceActiveFocus()

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.h * Theme.login.capsY - height / 2
        visible: CapsLock.on
        text: "Caps Lock is on"
        color: Theme.login.hint
        font.family: Theme.fontFamily
        font.pixelSize: root.h * Theme.login.promptSize
    }

    Avatar {
        width: root.h * Theme.login.avatarSize
        height: width
        x: (root.width - width) / 2
        y: root.h * Theme.login.avatarY - height / 2
        source: User.avatar
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.h * Theme.login.nameY - height / 2
        text: User.realName
        color: Theme.login.text
        font.family: Theme.fontFamily
        font.weight: Font.Bold
        font.pixelSize: root.h * Theme.login.nameSize
    }

    // One prompt line that turns into dots while typing. Clicking it focuses
    // the input on this screen.
    MouseArea {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.h * Theme.login.promptY - height / 2
        width: root.width * Theme.login.promptWidth
        height: root.h * Theme.login.promptSize * 2
        onClicked: input.forceActiveFocus()

        Text {
            anchors.centerIn: parent
            visible: root.password.length === 0
            text: root.busy ? "Checking…" : root.failed ? "Wrong password" : "Enter Password"
            color: root.failed ? Theme.login.error : Theme.login.muted
            font.family: Theme.fontFamily
            font.pixelSize: root.h * Theme.login.promptSize
        }

        Row {
            anchors.centerIn: parent
            spacing: root.h * Theme.login.dotSpacing

            Repeater {
                model: root.password.length

                Rectangle {
                    width: root.h * Theme.login.dotSize
                    height: width
                    radius: width / 2
                    color: Theme.login.text
                }
            }
        }
    }

    StatusIcons {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.h * Theme.login.statusY - height / 2
        unit: root.h * Theme.login.statusUnit
    }
}
