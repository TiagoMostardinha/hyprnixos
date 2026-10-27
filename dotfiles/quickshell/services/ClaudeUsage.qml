pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Claude plan usage (percent used of the 5-hour session and of the week), from scripts/claude-usage.sh,
// checked every 30 minutes (the usage endpoint refuses frequent requests). -1 while unknown.
Singleton {
    id: root

    property int session: -1
    property int week: -1

    Process {
        id: fetch

        running: true
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

    Timer {
        running: true
        repeat: true
        interval: 30 * 60 * 1000
        onTriggered: fetch.running = true
    }
}
