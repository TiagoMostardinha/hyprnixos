pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    readonly property var wired: Networking.devices.values.find(d => d.type === DeviceType.Wired && d.connected)
    readonly property var wifi: Networking.devices.values.find(d => d.type === DeviceType.Wifi && d.connected)?.networks.values.find(n => n.connected)
}
