import QtQuick
import Quickshell
import Quickshell.Services.Pam
import "../../theme"

Scope {
    id: root

    signal unlocked

    property string password: ""
    property bool failed: false
    property string submitted: ""
    readonly property bool busy: pam.active

    function submit(): void {
        if (pam.active || password === "")
            return;
        submitted = password;
        password = "";
        pam.start();
    }

    PamContext {
        id: pam

        config: "quickshell"

        onPamMessage: {
            if (responseRequired) {
                respond(root.submitted);
                root.submitted = "";
            }
        }

        onCompleted: result => {
            root.submitted = "";
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
