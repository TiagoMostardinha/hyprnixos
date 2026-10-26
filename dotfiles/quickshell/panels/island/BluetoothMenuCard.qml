import QtQuick
import Quickshell
import "../../services"

// The Bluetooth menu (right click on Bluetooth in the control center): a header that turns Bluetooth on
// or off, the saved devices (click to connect or disconnect), and a row into the Bluetooth settings app.
IslandCard {
    id: card

    drop: 0

    readonly property int pad: 12
    readonly property int inner: 340

    readonly property var devices: BluetoothDevices.saved.map(device => ({
        name: device.name || device.deviceName,
        detail: device.connected ? "Connected" : device.address === BluetoothDevices.connecting ? "Connecting…" : device.address === BluetoothDevices.failed ? "Couldn't connect" : "Not connected",
        on: device.connected,
        icon: device.icon ? device.icon + "-symbolic" : "bluetooth-active-symbolic",
        device
    }))

    width: inner + 2 * pad
    height: settings.y + settings.height + pad - 4

    // Clicking the title turns Bluetooth on or off.
    MenuTitle {
        x: card.pad + 4
        y: card.pad
        text: "Bluetooth"
        on: BluetoothDevices.enabled
        onClicked: BluetoothDevices.toggle()
    }

    // Left out, along with its divider, when nothing is paired.
    MenuSection {
        id: saved

        visible: card.devices.length > 0
        x: card.pad
        y: card.pad + 22 + 10
        width: card.inner
        title: "My devices"
        model: card.devices
        onActivated: entry => BluetoothDevices.activate(entry.device)
    }

    MenuDivider {
        id: savedLine

        visible: saved.visible
        x: card.pad
        y: saved.y + saved.height + 8
        width: card.inner
    }

    // Pairing new devices and everything else lives in the Bluetooth app.
    MenuLink {
        id: settings

        x: card.pad
        y: savedLine.visible ? savedLine.y + 4 : card.pad + 22 + 6
        width: card.inner
        text: "Bluetooth settings"
        onClicked: {
            Quickshell.execDetached(["blueman-manager"]);
            card.open("Idle");
        }
    }
}
