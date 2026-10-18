import QtQuick
import Quickshell
import Quickshell.Services.Pam
import "../../theme"

// Lock state shared by the surfaces on every screen.
Scope {
    id: root

    signal unlocked

    property string password: ""
    property bool failed: false
    readonly property bool busy: pam.active

    function submit(): void {
        if (!pam.active)
            pam.start();
    }

    PamContext {
        id: pam

        // /etc/pam.d/quickshell (modules/nixos/desktop.nix)
        config: "quickshell"

        onPamMessage: {
            if (responseRequired)
                respond(root.password);
        }

        onCompleted: result => {
            root.password = "";
            if (result === PamResult.Success) {
                root.unlocked();
            } else {
                root.failed = true;
                failTimer.restart();
            }
        }
    }

    Timer {
        id: failTimer

        interval: Theme.failDuration
        onTriggered: root.failed = false
    }
}
