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

    function reset(): void {
        password = "";
        failed = false;
    }

    function submit(): void {
        if (pam.active || password === "")
            return;
        failed = false;
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
            if (result === PamResult.Success) {
                root.reset();
                root.unlocked();
            } else {
                root.password = "";
                root.failed = true;
                failTimer.restart();
            }
        }
    }

    Timer {
        id: failTimer

        interval: Theme.login.failDuration
        onTriggered: root.failed = false
    }
}
