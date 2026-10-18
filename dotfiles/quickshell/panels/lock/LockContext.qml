import QtQuick
import Quickshell
import Quickshell.Services.Pam

// Lock state shared by the surfaces on every screen.
Scope {
    id: root

    signal unlocked

    property string password: ""
    property string error: ""
    readonly property bool authenticating: pam.active

    function reset(): void {
        password = "";
        error = "";
    }

    function submit(): void {
        if (pam.active || password === "")
            return;
        error = "";
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
                root.error = result === PamResult.Failed ? "Wrong password" : "Authentication error";
            }
        }
    }
}
