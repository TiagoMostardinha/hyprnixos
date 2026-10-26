pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool enabled: adapter?.enabled ?? false

    // Saved (paired) devices: connected first, then by name.
    readonly property var saved: (adapter?.devices.values ?? []).filter(device => device.paired || device.bonded).sort((a, b) => (b.connected - a.connected) || a.name.localeCompare(b.name))

    function toggle() {
        if (adapter)
            adapter.enabled = !adapter.enabled;
    }

    // Left click on a device: disconnect it if connected, otherwise connect. With Bluetooth off, it turns
    // Bluetooth on first and connects once the adapter is up.
    function activate(device) {
        if (device.connected)
            device.disconnect();
        else if (enabled)
            tryConnect(device);
        else {
            pending = device;
            adapter.enabled = true;
        }
    }

    // While a device connects, `connecting` holds its address. It fails if it drops back to disconnected
    // or still isn't connected after 15 seconds; the row then says so for a few seconds.
    property string connecting: ""
    property var attempt: null

    function tryConnect(device) {
        failed = "";
        connecting = device.address;
        attempt = device;
        attemptTimeout.restart();
        device.connect();
    }

    function connectDone(ok) {
        if (!connecting)
            return;
        if (!ok)
            markFailed(connecting);
        connecting = "";
        attempt = null;
        attemptTimeout.stop();
    }

    Connections {
        target: attempt

        function onConnectedChanged() {
            if (attempt.connected)
                connectDone(true);
        }

        function onStateChanged() {
            if (attempt.state === BluetoothDeviceState.Disconnected)
                connectDone(false);
        }
    }

    Timer {
        id: attemptTimeout

        interval: 15000
        onTriggered: connectDone(false)
    }

    property string failed: ""

    function markFailed(address) {
        failed = address;
        failedTimer.restart();
    }

    Timer {
        id: failedTimer

        interval: 4000
        onTriggered: failed = ""
    }

    // The device clicked while Bluetooth was off: connected a moment after the adapter comes up.
    property var pending: null

    onEnabledChanged: if (enabled && pending)
        pendingDelay.restart()

    Timer {
        id: pendingDelay

        interval: 1000
        onTriggered: {
            if (pending && !pending.connected)
                tryConnect(pending);
            pending = null;
        }
    }
}
