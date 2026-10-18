pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
    LockContext {
        id: lockContext

        onUnlocked: sessionLock.locked = false
    }

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
