import QtQuick
import Quickshell.Wayland
import "../../theme"
import "../../services"

// Lock screen for one monitor: wallpaper, clock, date, password field.
WlSessionLockSurface {
    id: root

    required property LockContext context

    color: Theme.background

    Image {
        anchors.fill: parent
        source: Theme.lockWallpaper
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.scrim
    }

    Column {
        anchors.centerIn: parent
        spacing: Theme.spacingLarge

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(Time.date, "HH:mm")
            color: Theme.foreground
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeClock
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(Time.date, "dddd, d MMMM")
            color: Theme.foreground
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeLarge
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Theme.inputWidth
            height: Theme.inputHeight
            radius: Theme.radius
            color: Theme.surface
            border.width: Theme.borderWidth
            border.color: root.context.error !== "" ? Theme.error : Theme.accent

            TextInput {
                id: input

                anchors.fill: parent
                anchors.leftMargin: Theme.spacing
                anchors.rightMargin: Theme.spacing
                verticalAlignment: TextInput.AlignVCenter
                focus: true
                enabled: !root.context.authenticating
                echoMode: TextInput.Password
                passwordCharacter: "•"
                color: Theme.foreground
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize

                onTextChanged: root.context.password = text
                onAccepted: root.context.submit()

                // Mirror the shared password (typed on another screen, or cleared).
                Connections {
                    target: root.context

                    function onPasswordChanged() {
                        input.text = root.context.password;
                    }
                }

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    visible: input.text === ""
                    text: root.context.authenticating ? "Checking…" : "Password"
                    color: Theme.foregroundMuted
                    font: input.font
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.context.error !== ""
            text: root.context.error
            color: Theme.error
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
        }
    }
}
