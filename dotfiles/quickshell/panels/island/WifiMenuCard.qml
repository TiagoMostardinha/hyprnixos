import QtQuick
import Quickshell
import "../../services"

// The Wi-Fi menu (right click on Wi-Fi in the control center): a header that turns Wi-Fi on or off,
// Personal Hotspot and Known networks lists (click to connect or disconnect), and a row into the
// network settings app.
IslandCard {
    id: card

    drop: 0

    readonly property int pad: 12
    readonly property int inner: 340

    // Networks in range, connected first then strongest: personal hotspots (kind 2 in
    // preferred-networks.json) in their own section, the other saved or kind 1 networks under Known.
    readonly property var entries: Network.nearby.map(network => ({
        name: network.name,
        detail: network.connected ? "Connected" : network.name === Network.connecting ? "Connecting…" : network.name === Network.failed ? "Couldn't connect" : Math.round(network.signalStrength * 100) + "%",
        on: network.connected,
        locked: Network.needsPassword(network) && Network.kind(network) !== 2,
        kind: Network.kind(network),
        known: network.known,
        icon: Network.kind(network) === 2 ? "network-wireless-hotspot-symbolic" : Network.signalIcon(network),
        network
    }))
    // Networks listed in preferred-networks.json that aren't in range still show (at 0%), after the ones that are,
    // and so does the last network used before this one (as a known network) unless the file lists it.
    readonly property var remembered: {
        const map = Object.assign({}, Network.kinds);
        if (Network.lastSsid && !(Network.lastSsid in map))
            map[Network.lastSsid] = 1;
        return map;
    }
    readonly property var away: Object.keys(remembered).filter(name => !Network.nearby.some(network => network.name === name)).map(name => ({
        name,
        detail: name === Network.connecting ? "Connecting…" : name === Network.failed ? "Couldn't connect" : "0%",
        on: false,
        locked: (Network.secured[name] ?? false) && card.remembered[name] !== 2,
        kind: card.remembered[name],
        known: true,
        icon: card.remembered[name] === 2 ? "network-wireless-hotspot-symbolic" : "network-wireless-signal-none-symbolic",
        network: null
    }))
    readonly property var hotspots: entries.concat(away).filter(row => row.kind === 2)
    readonly property var known: entries.concat(away).filter(row => row.kind !== 2 && (row.on || row.known || row.kind === 1))

    // Opens the network settings app (also where new networks with a password are joined) and closes the card.
    function openSettings() {
        Quickshell.execDetached(["nm-connection-editor"]);
        card.open("Idle");
    }

    // Keep scanning while the menu is open so the list stays current.
    Binding {
        when: Network.wifiDevice !== null
        target: Network.wifiDevice
        property: "scannerEnabled"
        value: true
    }

    width: inner + 2 * pad
    height: settings.y + settings.height + pad - 4

    function activate(entry) {
        if (entry.network) {
            if (!Network.activate(entry.network))
                card.openSettings();
        } else if (!Network.wifiEnabled)
            Network.turnOnAndConnect(entry.name);
        else
            Network.tryConnect(entry.name);
    }

    // Clicking the title turns Wi-Fi on or off.
    MenuTitle {
        x: card.pad + 4
        y: card.pad
        text: "Wi-Fi"
        on: Network.wifiEnabled
        onClicked: Network.toggleWifi()
    }

    // Empty sections (no hotspot in range, or Wi-Fi off) are left out along with their divider.
    MenuSection {
        id: hotspot

        visible: card.hotspots.length > 0
        x: card.pad
        y: card.pad + 22 + 10
        width: card.inner
        title: "Personal Hotspot"
        model: card.hotspots
        onActivated: entry => card.activate(entry)
    }

    MenuDivider {
        id: hotspotLine

        visible: hotspot.visible && known.visible
        x: card.pad
        y: hotspot.y + hotspot.height + 10
        width: card.inner
    }

    MenuSection {
        id: known

        visible: card.known.length > 0
        x: card.pad
        y: hotspot.visible ? hotspotLine.y + 10 : hotspot.y
        width: card.inner
        title: "Known networks"
        model: card.known
        onActivated: entry => card.activate(entry)
    }

    MenuDivider {
        id: knownLine

        visible: hotspot.visible || known.visible
        x: card.pad
        y: (known.visible ? known.y + known.height : hotspot.y + hotspot.height) + 8
        width: card.inner
    }

    // Other networks and the Wi-Fi settings both live in the network app, so one row opens it.
    MenuLink {
        id: settings

        x: card.pad
        y: knownLine.visible ? knownLine.y + 4 : card.pad + 22 + 6
        width: card.inner
        text: "Network settings"
        onClicked: card.openSettings()
    }
}
