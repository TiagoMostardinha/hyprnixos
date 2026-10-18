pragma Singleton

import QtQuick
import Quickshell

// Current time, minute precision (no seconds are shown anywhere).
Singleton {
    readonly property date date: clock.date

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
