import QtQuick
import Quickshell
import Quickshell.Services.Greetd
import "../../theme"
import "../../services"

// Login state shared by the greeter windows on every screen, driving greetd:
// createSession -> authMessage (respond with the password) -> readyToLaunch -> launch.
Scope {
    id: root

    property string password: ""
    property bool busy: false
    property bool failed: false

    // Session to start, from QS_LOGIN_SESSION (modules/nixos/greeter.nix).
    readonly property string session: Quickshell.env("QS_LOGIN_SESSION") || ""

    function submit(): void {
        if (busy || password === "")
            return;
        busy = true;
        failed = false;
        if (Greetd.state === GreetdState.Inactive)
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

        function onReadyToLaunch(): void {
            Greetd.launch([root.session]);
        }

        function onAuthFailure(message: string): void {
            root.fail();
        }

        function onError(error: string): void {
            console.warn("greetd:", error);
            Greetd.cancelSession();
            root.fail();
        }
    }

    Timer {
        id: failTimer

        interval: Theme.login.failDuration
        onTriggered: root.failed = false
    }
}
