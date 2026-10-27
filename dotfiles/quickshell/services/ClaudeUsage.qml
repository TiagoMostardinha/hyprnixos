pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Claude plan usage (percent used of the 5-hour session and of the week), from scripts/claude-usage.sh,
// checked 5 minutes after startup, then every 30 (the usage endpoint refuses frequent requests). -1 while unknown.
Singleton {
    id: root

    property int session: -1
    property int week: -1

    Process {
        id: fetch

        command: ["sh", Quickshell.shellDir + "/scripts/claude-usage.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                const [session, week] = text.trim().split(" ").map(Number);
                const ok = text.trim() !== "" && !isNaN(session) && !isNaN(week);
                root.session = ok ? session : -1;
                root.week = ok ? week : -1;
            }
        }
    }

    // First check 5 minutes after startup (so the network is up after boot), then every 30 minutes.
    Timer {
        running: true
        repeat: true
        interval: 5 * 60 * 1000
        onTriggered: {
            fetch.running = true;
            interval = 30 * 60 * 1000;
        }
    }
}
