pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking

// Current connection from NetworkManager.
Singleton {
    // The connected wired device, or undefined.
    readonly property var wired: Networking.devices.values.find(d => d.type === DeviceType.Wired && d.connected)
    // The connected wifi network, or undefined.
    readonly property var wifi: Networking.devices.values.find(d => d.type === DeviceType.Wifi && d.connected)?.networks.values.find(n => n.connected)
}
