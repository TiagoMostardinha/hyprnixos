// Bound: the per-screen window (a delegate) may use greeterContext.
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../components"

// Login screen on every monitor. Keyboard input goes to whichever screen has
// focus; all screens show the same shared state.
Scope {
    GreeterContext {
        id: greeterContext
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property ShellScreen modelData

            screen: modelData
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "shell-greeter"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            LoginScreen {
                anchors.fill: parent
                password: greeterContext.password
                busy: greeterContext.busy
                failed: greeterContext.failed
                onEdited: text => greeterContext.password = text
                onSubmitted: greeterContext.submit()
            }
        }
    }
}
