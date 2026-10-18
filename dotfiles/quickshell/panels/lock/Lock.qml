// Bound: the per-screen LockSurface (a nested component) may use lockContext.
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../../services"

// Session lock. Triggered by `loginctl lock-session` -> hypridle lock_cmd ->
//   qs ipc call lock lock
Scope {
    id: root

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
            if (sessionLock.locked)
                return;
            lockContext.reset();
            CapsLock.refresh();
            sessionLock.locked = true;
        }
    }
}
