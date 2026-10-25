pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    readonly property var wired: Networking.devices.values.find(d => d.type === DeviceType.Wired && d.connected)
    readonly property var wifi: Networking.devices.values.find(d => d.type === DeviceType.Wifi && d.connected)?.networks.values.find(n => n.connected)

    readonly property string icon: {
        if (wired)
            return "network-wired-symbolic";
        if (wifi)
            return `network-wireless-signal-${["weak", "ok", "good", "excellent"][Math.max(0, Math.ceil(wifi.signalStrength * 4) - 1)]}-symbolic`;
        return "network-offline-symbolic";
    }
}
