import QtQuick
import "components"

Item {
    id: root

    readonly property string fontFamily: config.fontFamily || "Inter"

    property bool busy: false
    property bool failed: false
    property int sessionIndex: sessionModel.lastIndex
    property date now: new Date()

    QtObject {
        id: user
        property string name: ""
        property string realName: ""
        property url icon: ""
    }
    Repeater {
        model: userModel
        Item {
            Component.onCompleted: {
                if (index === userModel.lastIndex) {
                    user.name = model.name
                    user.realName = model.realName || model.name
                    user.icon = model.icon
                }
            }
        }
    }

    Repeater {
        model: sessionModel
        Item {
            Component.onCompleted: {
                if (String(model.file).indexOf("hyprland-uwsm") !== -1)
                    root.sessionIndex = index
            }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            root.busy = false
            root.failed = true
            auth.clear()
            failTimer.restart()
        }
    }

    Timer {
        id: failTimer
        interval: 2000
        onTriggered: root.failed = false
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    Rectangle { anchors.fill: parent; color: "#111111" }
    Image {
        anchors.fill: parent
        source: Qt.resolvedUrl(config.background || "assets/wallpaper.jpg")
        sourceSize.width: width
        fillMode: Image.PreserveAspectCrop
    }

    ClockGroup {
        anchors.fill: parent
        sh: root.height
        fontFamily: root.fontFamily
        now: root.now
    }

    AuthGroup {
        id: auth
        anchors.fill: parent
        sh: root.height
        fontFamily: root.fontFamily
        name: user.realName
        icon: user.icon
        fallbackIcon: Qt.resolvedUrl(config.fallbackAvatar || "assets/avatar.jpg")
        busy: root.busy
        failed: root.failed
        onSubmit: function (password) {
            root.failed = false
            root.busy = true
            sddm.login(user.name, password, root.sessionIndex)
        }
    }
}
