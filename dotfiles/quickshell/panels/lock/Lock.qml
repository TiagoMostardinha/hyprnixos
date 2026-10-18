// Bound: the per-screen LockSurface (a nested component) may use lockContext.
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Session lock. `loginctl lock-session` -> hypridle lock_cmd -> qs ipc call lock lock
Scope {
    LockContext {
        id: lockContext

        onUnlocked: sessionLock.locked = false
    }

    // Creates one LockSurface per screen while locked.
    WlSessionLock {
        id: sessionLock

        LockSurface {
            context: lockContext
        }
    }

    IpcHandler {
        target: "lock"

        function lock(): void {
            sessionLock.locked = true;
        }
    }
}
