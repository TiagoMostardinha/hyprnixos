pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking

Singleton {
    readonly property var wired: Networking.devices.values.find(d => d.type === DeviceType.Wired && d.connected)
    readonly property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var wifi: Networking.devices.values.find(d => d.type === DeviceType.Wifi && d.connected)?.networks.values.find(n => n.connected)
    readonly property bool wifiEnabled: Networking.wifiEnabled

    // Networks in range, one per name (hidden ones left out): the connected one first, then strongest first.
    readonly property var nearby: {
        const best = {};
        for (const network of wifiDevice?.networks.values ?? []) {
            if (!network.name)
                continue;
            const seen = best[network.name];
            if (!seen || network.connected || (!seen.connected && network.signalStrength > seen.signalStrength))
                best[network.name] = network;
        }
        return Object.values(best).sort((a, b) => (b.connected - a.connected) || (b.signalStrength - a.signalStrength));
    }

    // How the Wi-Fi menu sorts networks, from ~/.local/state/quickshell/preferred-networks.json: a list of
    // { ssid, kind } where kind is 0 (doesn't matter), 1 (known network) or 2 (personal hotspot).
    // Missing, broken or unlisted entries count as 0.
    readonly property var kinds: {
        const map = {};
        try {
            for (const entry of JSON.parse(preferences.text() || "[]"))
                if (typeof entry?.ssid === "string" && [1, 2].includes(entry.kind))
                    map[entry.ssid] = entry.kind;
        } catch (error) {}
        return map;
    }

    function kind(network) {
        return kinds[network.name] ?? 0;
    }

    FileView {
        id: preferences

        path: (Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state") + "/quickshell/preferred-networks.json"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
    }

    // The saved Wi-Fi network used most recently before the current one, from NetworkManager's
    // last-connected timestamps. Rechecked whenever the Wi-Fi connection changes.
    property string lastSsid: ""

    onWifiChanged: {
        lastConnected.running = true;
        savedSecurity.running = true;
        if (connecting && wifi?.name === connecting)
            connectSucceeded();
    }

    // Saved Wi-Fi networks that need a password, by name, so ones out of range can still show their lock.
    property var secured: ({})

    Process {
        id: savedSecurity

        running: true
        command: ["sh", "-c", "for u in $(nmcli -t -f UUID,TYPE connection show | awk -F: '$2==\"802-11-wireless\"{print $1}'); do nmcli -g 802-11-wireless.ssid,802-11-wireless-security.key-mgmt connection show \"$u\" | paste -sd '\\t'; done"]
        stdout: StdioCollector {
            onStreamFinished: {
                const map = {};
                for (const line of text.split("\n")) {
                    const [ssid, keyMgmt] = line.split("\t");
                    if (ssid)
                        map[ssid] = !!keyMgmt && keyMgmt !== "none" && keyMgmt !== "owe";
                }
                secured = map;
            }
        }
    }

    Process {
        id: lastConnected

        running: true
        command: ["sh", "-c", "nmcli -t -f TIMESTAMP,UUID,TYPE,ACTIVE connection show | awk -F: '$3==\"802-11-wireless\" && $4==\"no\"' | sort -t: -k1,1nr | head -1 | cut -d: -f2 | xargs -r nmcli -g 802-11-wireless.ssid connection show"]
        stdout: StdioCollector {
            onStreamFinished: lastSsid = text.trim()
        }
    }

    // Left click on a network: disconnect it if connected, connect if it's saved or open. Returns false
    // for a new network that needs a password, which is set up in the network settings app instead.
    function activate(network) {
        if (network.connected)
            network.disconnect();
        else if (network.known || !needsPassword(network))
            tryConnect(network.name, network);
        else
            return false;
        return true;
    }

    // Connecting to a network, in range (`network` given) or a saved one out of range (by name). While it
    // tries, `connecting` holds its name. If it fails (NetworkManager says so, or it still isn't connected
    // after 15 seconds), the row says so and the network you were on before is brought back.
    property string connecting: ""
    property string previous: ""
    property var attempt: null

    function tryConnect(name, network) {
        if (!connecting)
            previous = wifi && wifi.name !== name ? wifi.name : "";
        failed = "";
        connecting = name;
        attempt = network ?? null;
        attemptTimeout.restart();
        if (network)
            network.connect();
        else {
            savedUp.name = name;
            savedUp.running = true;
        }
    }

    function connectSucceeded() {
        connecting = "";
        previous = "";
        attempt = null;
        attemptTimeout.stop();
    }

    function connectFailed() {
        if (!connecting)
            return;
        markFailed(connecting);
        connecting = "";
        attempt = null;
        attemptTimeout.stop();
        const back = nearby.find(n => n.name === previous);
        previous = "";
        if (back && !back.connected)
            back.connect();
    }

    Connections {
        target: attempt

        function onConnectionFailed(reason) {
            connectFailed();
        }
    }

    Process {
        id: savedUp

        property string name: ""

        command: ["nmcli", "--wait", "15", "connection", "up", "id", name]
        onExited: code => {
            if (code !== 0 && connecting === name)
                connectFailed();
        }
    }

    Timer {
        id: attemptTimeout

        interval: 15000
        onTriggered: connectFailed()
    }

    // The network that just failed to connect; the row says so for a few seconds.
    property string failed: ""

    function markFailed(name) {
        failed = name;
        failedTimer.restart();
    }

    Timer {
        id: failedTimer

        interval: 4000
        onTriggered: failed = ""
    }

    // Clicking a network while Wi-Fi is off turns Wi-Fi on, then connects to it once a scan finds it
    // (given up after 20 seconds if it never shows).
    property string pending: ""

    function turnOnAndConnect(name) {
        pending = name;
        pendingTimeout.restart();
        Networking.wifiEnabled = true;
    }

    onNearbyChanged: {
        const network = pending ? nearby.find(n => n.name === pending) : null;
        if (!network)
            return;
        pending = "";
        if (!network.connected)
            activate(network);
    }

    Timer {
        id: pendingTimeout

        interval: 20000
        onTriggered: {
            markFailed(pending);
            pending = "";
        }
    }

    // Open (and enhanced-open) networks connect without a password.
    function needsPassword(network) {
        return network.security !== WifiSecurityType.Open && network.security !== WifiSecurityType.Owe;
    }

    // Signal bars for a network.
    function signalIcon(network) {
        return `network-wireless-signal-${["weak", "ok", "good", "excellent"][Math.max(0, Math.ceil(network.signalStrength * 4) - 1)]}-symbolic`;
    }

    // Wi-Fi alone: signal strength while connected, otherwise whether the radio is off or just unconnected.
    readonly property string wifiIcon: {
        if (wifi)
            return signalIcon(wifi);
        return Networking.wifiEnabled ? "network-wireless-offline-symbolic" : "network-wireless-disabled-symbolic";
    }

    function toggleWifi() {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }

    readonly property string icon: {
        if (wired)
            return "network-wired-symbolic";
        if (wifi)
            return wifiIcon;
        return "network-offline-symbolic";
    }
}
