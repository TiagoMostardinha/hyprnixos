import QtQuick
import Quickshell.Wayland
import "../../components"

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
