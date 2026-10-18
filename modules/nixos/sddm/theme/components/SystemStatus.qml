import QtQuick

Item {
    id: root

    property real unit: 20

    property int batteryPercent: -1
    property bool charging: false
    property string netType: ""
    property int wifiLevel: 4

    visible: batteryPercent >= 0 || netType !== ""
    implicitWidth: row.width
    implicitHeight: unit * 1.5

    function readFile(path, done) {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE)
                done(xhr.responseText || null)
        }
        try {
            xhr.open("GET", "file://" + path)
            xhr.send()
        } catch (e) {
            done(null)
        }
    }

    function refreshBattery() {
        readFile("/sys/class/power_supply/BAT0/capacity", function (cap) {
            if (cap === null) { root.batteryPercent = -1; return }
            root.batteryPercent = Math.max(0, Math.min(100, parseInt(cap)))
            readFile("/sys/class/power_supply/BAT0/status", function (status) {
                root.charging = status !== null && status.trim() === "Charging"
            })
        })
    }

    function refreshNetwork() {
        readFile("/proc/net/route", function (route) {
            if (route === null) { root.netType = ""; return }
            var defaults = {}, any = false
            route.split("\n").slice(1).forEach(function (line) {
                var f = line.trim().split(/\s+/)
                if (f[1] === "00000000" && f[7] === "00000000") { defaults[f[0]] = true; any = true }
            })
            readFile("/proc/net/wireless", function (wireless) {
                var lines = wireless ? wireless.split("\n").slice(2) : []
                for (var i = 0; i < lines.length; i++) {
                    var f = lines[i].trim().split(/\s+/)
                    if (!defaults[f[0].replace(":", "")]) continue
                    root.wifiLevel = Math.max(1, Math.min(4, Math.ceil(parseFloat(f[2]) / 70 * 4) || 1))
                    root.netType = "wifi"
                    return
                }
                root.netType = any ? "ethernet" : "none"
            })
        })
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: { root.refreshBattery(); root.refreshNetwork() }
    }

    function icon(name) {
        return Qt.resolvedUrl("../assets/icons/" + name + "-symbolic.svg")
    }

    readonly property int batteryLevel: Math.max(0, Math.floor(batteryPercent / 10) * 10)
    readonly property string networkIcon: netType === "wifi"
        ? "network-wireless-signal-" + ["weak", "ok", "good", "excellent"][wifiLevel - 1]
        : netType === "ethernet" ? "network-wired" : "network-offline"

    Row {
        id: row
        spacing: root.unit * 0.9
        height: root.unit * 1.5

        Image {
            visible: root.batteryPercent >= 0
            width: root.unit * 1.5
            height: width
            sourceSize: Qt.size(width, height)
            source: root.icon("battery-level-" + root.batteryLevel + (root.charging ? "-charging" : ""))
        }

        Image {
            visible: root.netType !== ""
            width: root.unit * 1.5
            height: width
            sourceSize: Qt.size(width, height)
            source: root.icon(root.networkIcon)
        }
    }
}
