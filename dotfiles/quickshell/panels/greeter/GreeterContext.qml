import QtQuick
import Quickshell
import Quickshell.Services.Greetd
import "../../theme"
import "../../services"

// Login state shared by the greeter windows on every screen, driving greetd:
// createSession -> authMessage (answer with the password) -> readyToLaunch -> launch.
Scope {
    id: root

    property string password: ""
    property bool busy: false
    property bool failed: false

    function submit(): void {
        if (busy)
            return;
        busy = true;
        failed = false;
        Greetd.createSession(User.name);
    }

    function fail(): void {
        busy = false;
        failed = true;
        password = "";
        failTimer.restart();
    }

    Connections {
        target: Greetd

        function onAuthMessage(message: string, error: bool, responseRequired: bool, echoResponse: bool): void {
            if (responseRequired)
                Greetd.respond(root.password);
        }

        // QS_LOGIN_SESSION: the session command, set in modules/nixos/greeter.nix.
        function onReadyToLaunch(): void {
            Greetd.launch([Quickshell.env("QS_LOGIN_SESSION")]);
        }

        function onAuthFailure(message: string): void {
            root.fail();
        }

        function onError(error: string): void {
            Greetd.cancelSession();
            root.fail();
        }
    }

    Timer {
        id: failTimer

        interval: Theme.failDuration
        onTriggered: root.failed = false
    }
}
