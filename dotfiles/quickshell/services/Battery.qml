pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

// Laptop battery from UPower (aggregate display device; ignores peripherals
// such as the stylus battery).
Singleton {
    readonly property UPowerDevice device: UPower.displayDevice

    readonly property bool available: device.ready && device.isPresent && device.isLaptopBattery
    readonly property int percent: Math.round(device.percentage * 100)
    readonly property bool charging: device.state === UPowerDeviceState.Charging
}
