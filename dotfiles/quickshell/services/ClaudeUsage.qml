pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Claude plan usage (percent used of the 5-hour session and of the week), saved by Claude Code's status line
// (scripts/claude-statusline.sh) to ~/.local/state/quickshell/claude-usage.json while you use claude in a
// terminal. -1 while unknown, or once that window has reset since.
Singleton {
    id: root

    readonly property int session: percent(usage.five_hour)
    readonly property int week: percent(usage.seven_day)

    readonly property var usage: {
        try {
            return JSON.parse(file.text() || "{}") ?? {};
        } catch (error) {
            return {};
        }
    }
    property real now: Date.now() / 1000

    function percent(window) {
        return window?.resets_at > now ? Math.round(window.used_percentage) : -1;
    }

    FileView {
        id: file

        path: (Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state") + "/quickshell/claude-usage.json"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
    }

    // Rechecks the reset times each minute, so a window that has reset shows as unknown.
    Timer {
        running: true
        repeat: true
        interval: 60 * 1000
        onTriggered: root.now = Date.now() / 1000
    }
}
