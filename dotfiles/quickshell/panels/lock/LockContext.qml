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

    // While locked, a finger on the reader also unlocks (quickshell-fingerprint PAM service).
    property bool locked: false

    onLockedChanged: {
        if (locked)
            fingerprint.start();
        else
            fingerprint.abort();
    }

    PamContext {
        id: fingerprint

        config: "quickshell-fingerprint"

        onCompleted: result => {
            if (result === PamResult.Success)
                root.unlocked();
            else if (root.locked)
                retry.restart();
        }
    }

    // After a timeout or too many wrong fingers, listen again (with a pause, so a missing reader doesn't spin).
    Timer {
        id: retry

        interval: 2000
        onTriggered: if (root.locked)
            fingerprint.start()
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
