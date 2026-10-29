import QtQuick
import QtQuick.Effects
import "../theme"
import "../services"

Item {
    id: root

    required property string password
    required property bool busy
    required property bool failed

    signal edited(string text)
    signal submitted

    Image {
        anchors.fill: parent
        source: Theme.wallpaper
        sourceSize.width: width
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: false
            blurEnabled: true
            blur: 1
            blurMax: Theme.wallpaperBlur
        }
    }

    DateClock {
        anchors.fill: parent
    }

    TextInput {
        opacity: 0
        focus: true
        echoMode: TextInput.Password
        readOnly: root.busy
        text: root.password
        onTextEdited: root.edited(text)
        onAccepted: root.submitted()
    }

    Avatar {
        width: root.height * Theme.avatarSize
        height: width
        x: (root.width - width) / 2
        y: root.height * Theme.avatarY - height / 2
        source: User.avatar
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * Theme.nameY - height / 2
        text: User.realName
        color: Theme.text
        font.family: Theme.fontFamily
        font.weight: Font.Bold
        font.pixelSize: root.height * Theme.nameSize
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * Theme.promptY - height / 2
        visible: root.password.length === 0
        text: root.busy ? "Checking…" : root.failed ? "Wrong password" : "Touch sensor or enter password"
        color: root.failed ? Theme.error : Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: root.height * Theme.promptSize
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * Theme.promptY - height / 2
        spacing: root.height * Theme.dotSpacing

        Repeater {
            model: root.password.length

            Rectangle {
                width: root.height * Theme.dotSize
                height: width
                radius: width / 2
                color: Theme.text
            }
        }
    }

    StatusIcons {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * Theme.statusY - height / 2
        size: root.height * Theme.statusSize
        spacing: root.height * Theme.statusSpacing
    }
}
