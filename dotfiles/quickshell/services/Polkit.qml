pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Polkit

// The session's polkit agent: apps asking for admin rights land here, and the island shows the prompt.
Singleton {
    readonly property bool active: agent.isActive
    readonly property var flow: agent.flow

    // Polkit retries wrong passwords forever without saying anything, so attempts are counted here
    // and the request is cancelled after the last one.
    readonly property int maxAttempts: 3
    property int failures: 0
    readonly property int attemptsLeft: maxAttempts - failures

    onFlowChanged: failures = 0

    PolkitAgent {
        id: agent
    }

    Connections {
        target: agent.flow

        function onAuthenticationFailed() {
            failures += 1;
        }

        // Cancelling right on the failure is too early: polkit then starts the next round anyway.
        // Cancel when it asks for the next password instead.
        function onIsResponseRequiredChanged() {
            if (agent.flow.isResponseRequired && failures >= maxAttempts)
                agent.flow.cancelAuthenticationRequest();
        }
    }
}
