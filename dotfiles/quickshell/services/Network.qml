pragma Singleton

import QtQuick
import Quickshell
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

    // Left click on a network: disconnect it if connected, connect if it's saved or open, otherwise ask for
    // its password (the join card shows while `joining` is set).
    property var joining: null
    property string joinError: ""

    function activate(network) {
        if (network.connected)
            network.disconnect();
        else if (network.known || !needsPassword(network))
            network.connect();
        else {
            joinError = "";
            joining = network;
        }
    }

    function join(password) {
        joinError = "";
        joining?.connectWithPsk(password);
    }

    Connections {
        target: joining

        function onConnectedChanged() {
            if (joining.connected)
                joining = null;
        }

        // A failed join drops the profile it saved, so a wrong password isn't remembered.
        function onConnectionFailed(reason) {
            joinError = "Couldn't connect, check the password";
            joining.forget();
        }
    }

    // Open (and enhanced-open) networks connect without a password.
    function needsPassword(network) {
        return network.security !== WifiSecurityType.Open && network.security !== WifiSecurityType.Owe;
    }

    // Wi-Fi alone: signal strength while connected, otherwise whether the radio is off or just unconnected.
    readonly property string wifiIcon: {
        if (wifi)
            return `network-wireless-signal-${["weak", "ok", "good", "excellent"][Math.max(0, Math.ceil(wifi.signalStrength * 4) - 1)]}-symbolic`;
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
