import QtQuick
import "components"

// Login screen, split into two groups:
// ClockGroup (top) and AuthGroup (bottom). Sizes are fractions of the
// screen height so it looks the same on any resolution.
//
// `sddm`, `userModel`, `sessionModel`, `keyboard` and `config`
// are context properties provided by the SDDM greeter.
Item {
    id: root

    readonly property string fontFamily: config.fontFamily || "Inter"

    property bool busy: false      // password is being checked
    property bool failed: false    // last attempt was wrong
    property int sessionIndex: sessionModel.lastIndex
    property date now: new Date()

    // Single-user laptop: the last user.
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

    // The session is always Hyprland under uwsm (modules/desktop/sddm.nix), no picker.
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

    // The red state lasts two seconds.
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

    // The wallpaper, as it is.
    Rectangle { anchors.fill: parent; color: "#111111" }
    Image {
        anchors.fill: parent
        source: Qt.resolvedUrl(config.background || "assets/wallpaper.jpg")
        sourceSize.width: width   // decode at screen size, not the full 4928 px
        fillMode: Image.PreserveAspectCrop
    }

    ClockGroup {
        anchors.fill: parent
        sh: root.height
        fontFamily: root.fontFamily
        now: root.now
    }

    // Shown on every screen: SDDM's "primary screen" flag is unreliable with two monitors.
    // Keyboard input goes to whichever screen has focus.
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
