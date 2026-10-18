pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    readonly property UPowerDevice device: UPower.displayDevice

    readonly property bool available: device.isLaptopBattery
    readonly property int percent: Math.round(device.percentage * 100)
    readonly property bool charging: device.state === UPowerDeviceState.Charging
}
