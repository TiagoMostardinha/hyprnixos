import QtQuick
import Quickshell.Wayland
import "../../components"

// Lock screen for one monitor: the same look as the login greeter.
WlSessionLockSurface {
    id: root

    required property LockContext context

    LoginScreen {
        anchors.fill: parent
        password: root.context.password
        busy: root.context.busy
        failed: root.context.failed
        onEdited: text => root.context.password = text
        onSubmitted: root.context.submit()
    }
}
