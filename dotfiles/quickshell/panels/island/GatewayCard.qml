import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "../../services"

IslandCard {
    id: card

    side: "solo"
    drop: 0

    readonly property real battery: Battery.available ? Battery.percent / 100 : 1

    // Main route: the interface and address used to reach the internet, refreshed while open.
    property string device: ""
    property string address: ""
    property bool tailscale: false
    // Download / upload speed: change in the interface's byte counters between readings, per second.
    property real downRate: 0
    property real upRate: 0
    property var samples: ({})

    function sample(key, bytes) {
        const now = Date.now();
        const last = samples[key];
        samples[key] = { bytes, now };
        if (!last || now <= last.now || bytes < last.bytes)
            return 0;
        return (bytes - last.bytes) / ((now - last.now) / 1000);
    }

    function speed(rate) {
        if (rate >= 1e6)
            return (rate / 1e6).toFixed(1) + " MB/s";
        if (rate >= 1e3)
            return Math.round(rate / 1e3) + " KB/s";
        return Math.round(rate) + " B/s";
    }

    function refresh() {
        route.running = true;
        rx.reload();
        tx.reload();
        links.running = true;
    }

    Component.onCompleted: refresh()

    Timer {
        running: true
        repeat: true
        interval: 2000
        onTriggered: card.refresh()
    }

    Process {
        id: route

        command: ["ip", "-j", "route", "get", "1.1.1.1"]
        stdout: StdioCollector {
            onStreamFinished: {
                const info = JSON.parse(text || "[]")[0] ?? {};
                card.device = info.dev ?? "";
                card.address = info.prefsrc ?? "";
            }
        }
    }

    FileView {
        id: rx
        path: card.device ? `/sys/class/net/${card.device}/statistics/rx_bytes` : ""
        onLoaded: card.downRate = card.sample("rx", parseFloat(text()))
    }

    FileView {
        id: tx
        path: card.device ? `/sys/class/net/${card.device}/statistics/tx_bytes` : ""
        onLoaded: card.upRate = card.sample("tx", parseFloat(text()))
    }

    // Tailscale is on while its backend is "Running" (the tailscale0 interface stays even when off).
    Process {
        id: links

        command: ["tailscale", "status", "--json"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    card.tailscale = JSON.parse(text).BackendState === "Running";
                } catch (error) {
                    card.tailscale = false;
                }
            }
        }
    }

    // Clicking the tailscale pill turns it on or off (allowed for the operator user set in core.nix).
    Process {
        id: toggle

        command: ["tailscale", card.tailscale ? "down" : "up"]
        onExited: links.running = true
    }

    // Runs a session action and closes the card.
    function run(command) {
        Quickshell.execDetached(command);
        card.open("Idle");
    }

    width: 420
    height: 146

    // Bottom buttons: invert on hover. Risky ones (reboot, power off) arm on the first click, staying
    // inverted, and only act on a second click within 3 seconds.
    component IconBox: Rectangle {
        id: box

        property bool confirm: false
        property bool armed: false
        readonly property bool inverted: armed || boxArea.containsMouse

        signal activated

        y: 110
        width: 22
        height: 22
        radius: IslandTheme.radiusSmall
        color: inverted ? IslandTheme.fg : IslandTheme.card2

        Timer {
            running: box.armed
            interval: 3000
            onTriggered: box.armed = false
        }

        MouseArea {
            id: boxArea

            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (box.confirm && !box.armed)
                    box.armed = true;
                else
                    box.activated();
            }
        }
    }

    component BoxGlyph: PathGlyph {
        anchors.centerIn: parent
        color: parent.inverted ? IslandTheme.pill : IslandTheme.fg2
        strokeWidth: 1.4
    }

    ClippingRectangle {
        x: 12
        y: 12
        width: 40
        height: 40
        radius: 20
        color: IslandTheme.card2

        Image {
            anchors.fill: parent
            source: User.avatar
            sourceSize: Qt.size(width * 2, height * 2)
            fillMode: Image.PreserveAspectCrop
        }
    }

    Row {
        x: 62
        y: 28 - user.baselineOffset
        spacing: 6

        IslandText {
            id: user

            text: User.name
            font.pixelSize: IslandTheme.heading
            font.weight: Font.DemiBold
        }

        IslandText {
            anchors.baseline: user.baseline
            text: "(" + System.hostname + ")"
            tone: "secondary"
            font.pixelSize: IslandTheme.small
        }
    }

    IslandText {
        x: 62
        line: 44
        text: System.uptimeText
        tone: "muted"
        font.pixelSize: IslandTheme.small
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 14
        y: 30 - percent.baselineOffset
        spacing: 6

        BatteryGlyph {
            anchors.verticalCenter: percent.verticalCenter
            level: card.battery
        }

        IslandText {
            id: percent

            text: Math.round(card.battery * 100) + "%"
            font.pixelSize: IslandTheme.heading
            font.weight: Font.DemiBold
        }
    }

    // Green while there is a route to the internet, grey when offline.
    Rectangle {
        x: 14
        y: 66
        width: 10
        height: 10
        radius: 3
        color: card.address ? IslandTheme.online : IslandTheme.fg3
    }

    IslandText {
        x: 30
        line: 75
        text: card.address || "offline"
        font.pixelSize: IslandTheme.title
        font.weight: Font.DemiBold
    }

    IslandText {
        id: deviceLabel

        x: 14
        line: 93
        text: card.device || "—"
        tone: "secondary"
        font.pixelSize: IslandTheme.small
    }

    Rectangle {
        x: deviceLabel.x + deviceLabel.width + 8
        y: 83
        width: 56
        height: 14
        radius: 7
        color: pillArea.containsMouse ? IslandTheme.line : IslandTheme.card2

        Rectangle {
            x: 8 - width / 2
            anchors.verticalCenter: parent.verticalCenter
            width: 6
            height: 6
            radius: 3
            color: card.tailscale ? IslandTheme.online : IslandTheme.fg3
        }

        MouseArea {
            id: pillArea

            anchors.fill: parent
            hoverEnabled: true
            enabled: !toggle.running
            onClicked: toggle.running = true
        }

        IslandText {
            x: 15
            line: 10.5
            text: "tailscale"
            tone: "secondary"
            font.pixelSize: IslandTheme.tiny
        }
    }

    IslandText {
        x: card.width - 14 - width
        line: 75
        text: "↓ " + card.speed(card.downRate)
    }

    IslandText {
        x: card.width - 14 - width
        line: 93
        text: "↑ " + card.speed(card.upRate)
        tone: "secondary"
    }

    Rectangle {
        x: 10
        y: 106
        width: card.width - 20
        height: 30
        radius: IslandTheme.radiusSection
        color: IslandTheme.card
    }

    IconBox {
        x: 14
        onActivated: card.run(["loginctl", "lock-session"])

        LockGlyph {
            anchors.centerIn: parent
            color: parent.inverted ? IslandTheme.pill : IslandTheme.fg2
        }
    }

    IconBox {
        x: 40
        onActivated: card.run(["systemctl", "suspend"])

        BoxGlyph {
            fill: "M 7.162 3.058 A 6 6 0 1 0 13.164 12.056 A 5.5 5.5 0 0 1 7.162 3.058 Z"
        }
    }

    // Claude plan usage: the Claude Code mark, then the 5-hour session and the week, "—" while unknown.
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 125 - usage.baselineOffset
        spacing: 6

        // The Claude mark, lined up with the digits.
        ClaudeGlyph {
            // About as tall as the digits (7.5 px) and standing on their baseline.
            y: usage.baselineOffset - height
            color: IslandTheme.fg2
        }

        IslandText {
            id: usage

            text: "now " + (ClaudeUsage.session < 0 ? "—" : ClaudeUsage.session + "%") + "  ·  week " + (ClaudeUsage.week < 0 ? "—" : ClaudeUsage.week + "%")
            tone: "secondary"
            font.pixelSize: IslandTheme.small
        }
    }

    IconBox {
        x: card.width - 62
        confirm: true
        onActivated: card.run(["systemctl", "reboot"])

        BoxGlyph {
            stroke: "M 13 9 A 5 5 0 1 1 10 4.5 M 9 1.5 L 12 4.5 L 8 6.5"
        }
    }

    IconBox {
        x: card.width - 36
        confirm: true
        onActivated: card.run(["systemctl", "poweroff"])

        BoxGlyph {
            stroke: "M 11.5 5 A 5.5 5.5 0 1 1 4.5 5 M 8 2 V 8"
        }
    }
}
