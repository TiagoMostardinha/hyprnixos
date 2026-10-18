pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking

// Current connection from NetworkManager. Wired wins over wifi.
Singleton {
    id: root

    // "ethernet" | "wifi" | "none"
    readonly property string type: wired !== null ? "ethernet" : wifi !== null ? "wifi" : "none"
    // Wifi bars, 1..4.
    readonly property int wifiLevel: wifi === null ? 0 : Math.max(1, Math.min(4, Math.ceil(wifi.signalStrength * 4)))

    readonly property var wired: {
        for (const device of Networking.devices.values)
            if (device.type === DeviceType.Wired && device.connected)
                return device;
        return null;
    }

    // The connected WifiNetwork, or null.
    readonly property var wifi: {
        for (const device of Networking.devices.values) {
            if (device.type !== DeviceType.Wifi || !device.connected)
                continue;
            for (const network of device.networks.values)
                if (network.connected)
                    return network;
        }
        return null;
    }
}
