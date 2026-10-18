import QtQuick

// Battery (left) and network (right), icons only.
//
// The greeter has no system APIs, so the data is read from the kernel with
// XMLHttpRequest on file:// URLs. Qt only allows that when QML_XHR_ALLOW_FILE_READ=1
// is set in the greeter's environment (see modules/desktop/sddm/theme.nix). Without it every read
// fails and this item hides itself, so the login screen is never affected.
Item {
    id: root

    property real unit: 20            // base size in px; icons are 1.5x

    property int batteryPercent: -1   // -1: no battery or unreadable
    property bool charging: false
    property string netType: ""       // "wifi" | "ethernet" | "none" ("" = unreadable)
    property int wifiLevel: 4         // 1..4 bars, only used when netType is "wifi"

    visible: batteryPercent >= 0 || netType !== ""
    implicitWidth: row.width
    implicitHeight: unit * 1.5

    // Reads a small text file; calls done(text), or done(null) on failure.
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

    // Connection = the interface holding the default route (/proc/net/route). If it is
    // listed in /proc/net/wireless (column 3: link quality 0..70) it is wifi, otherwise
    // ethernet. No default route means no connection.
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

    // Microsoft Fluent System Icons (MIT), see assets/icons.
    function icon(name) {
        return Qt.resolvedUrl("../assets/icons/" + name + ".svg")
    }

    Row {
        id: row
        spacing: root.unit * 0.9
        height: root.unit * 1.5

        Image {
            visible: root.batteryPercent >= 0
            width: root.unit * 1.5
            height: width
            sourceSize: Qt.size(width, height)
            source: root.icon((root.charging ? "battery-charge-" : "battery-") + Math.round(root.batteryPercent / 10))
        }

        // Wifi is four stacked layers (dot + three arcs); layers above the signal are dimmed.
        Item {
            visible: root.netType === "wifi"
            width: root.unit * 1.5
            height: width
            Repeater {
                model: 4
                Image {
                    anchors.fill: parent
                    sourceSize: Qt.size(width, height)
                    opacity: index < root.wifiLevel ? 1 : 0.3
                    source: root.icon("wifi-" + (index + 1))
                }
            }
        }

        Image {
            visible: root.netType === "ethernet" || root.netType === "none"
            width: root.unit * 1.5
            height: width
            sourceSize: Qt.size(width, height)
            source: root.icon(root.netType === "none" ? "none" : "ethernet")
        }
    }
}
