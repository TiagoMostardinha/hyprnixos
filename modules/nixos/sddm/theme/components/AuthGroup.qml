import QtQuick

Item {
    id: root

    property real sh
    property string fontFamily
    property string name
    property url icon
    property url fallbackIcon
    property bool busy: false
    property bool failed: false

    signal submit(string password)

    function clear() {
        pw.text = ""
        pw.forceActiveFocus()
    }

    TextInput {
        id: pw
        opacity: 0
        echoMode: TextInput.Password
        focus: true
        enabled: !root.busy
        onAccepted: if (text.length > 0) root.submit(text)
        Component.onCompleted: forceActiveFocus()
    }

    Avatar {
        width: sh * 0.048
        height: width
        x: (root.width - width) / 2
        y: sh * 0.86 - height / 2
        source: root.icon
        fallback: root.fallbackIcon
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: sh * 0.908 - height / 2
        text: root.name
        color: "white"
        font.family: fontFamily
        font.weight: Font.Bold
        font.pixelSize: sh * 0.0133
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: sh * 0.935 - height / 2
        visible: pw.text.length === 0
        text: root.failed ? "Wrong password" : "Touch ID or Enter Password"
        color: root.failed ? "#ff8a8a" : Qt.rgba(1, 1, 1, 0.6)
        font.family: fontFamily
        font.pixelSize: sh * 0.011
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        y: sh * 0.935 - height / 2
        spacing: sh * 0.005
        Repeater {
            model: pw.text.length
            Rectangle {
                width: sh * 0.007
                height: width
                radius: width / 2
                color: "white"
            }
        }
    }

    SystemStatus {
        anchors.horizontalCenter: parent.horizontalCenter
        y: sh * 0.968 - height / 2
        unit: sh * 0.0115
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: sh * 0.825 - height / 2
        visible: keyboard.capsLock
        text: "Caps Lock is on"
        color: Qt.rgba(1, 1, 1, 0.5)
        font.family: fontFamily
        font.pixelSize: sh * 0.011
    }
}
