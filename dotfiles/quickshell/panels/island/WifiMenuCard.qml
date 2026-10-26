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
    // Hover grey, the same as the week card's hover box.
    readonly property color hoverFill: Qt.rgba(IslandTheme.card.r, IslandTheme.card.g, IslandTheme.card.b, 0.6)

    // Networks in range, connected first then strongest: personal hotspots (kind 2 in
    // preferred-networks.json) in their own section, the other saved or kind 1 networks under Known.
    readonly property var entries: Network.nearby.map(network => ({
        name: network.name,
        detail: network.connected ? "Connected" : network.name === Network.connecting ? "Connecting…" : network.name === Network.failed ? "Couldn't connect" : Math.round(network.signalStrength * 100) + "%",
        on: network.connected,
        secure: Network.needsPassword(network),
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
        secure: Network.secured[name] ?? false,
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

    // A thin line between sections, like the launcher's.
    component Divider: Rectangle {
        x: card.pad
        width: card.inner
        height: 1
        color: IslandTheme.line
    }

    // A small grey label with its network rows, straight on the card.
    component Section: Item {
        property alias title: sectionTitle.text
        property alias model: rows.model

        x: card.pad
        width: card.inner
        height: rowsColumn.y + rowsColumn.height

        IslandText {
            id: sectionTitle

            x: 4
            line: 12
            tone: "secondary"
            font.pixelSize: IslandTheme.small
        }

        Column {
            id: rowsColumn

            y: 20
            width: parent.width
            spacing: 4

            Repeater {
                id: rows

                ListRow {
                    id: row

                    required property var modelData

                    width: parent.width
                    height: 34
                    radius: IslandTheme.radiusButton
                    highlight: modelData.on ? "strong" : "none"
                    textX: 34
                    fill: rowArea.containsMouse ? card.hoverFill : "transparent"
                    title: modelData.name
                    titleSize: IslandTheme.body
                    subtitle: modelData.detail
                    subtitleSize: IslandTheme.tiny

                    SymbolicIcon {
                        x: 10
                        anchors.verticalCenter: parent.verticalCenter
                        name: row.modelData.icon
                        color: row.inverted ? IslandTheme.pill : IslandTheme.fg
                    }

                    // Personal hotspots leave out the lock.
                    LockGlyph {
                        visible: row.modelData.secure && row.modelData.kind !== 2
                        x: parent.width - 10 - width
                        anchors.verticalCenter: parent.verticalCenter
                        color: row.inverted ? IslandTheme.pill : IslandTheme.fg2
                    }

                    MouseArea {
                        id: rowArea

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (row.modelData.network) {
                                if (!Network.activate(row.modelData.network))
                                    card.openSettings();
                            } else if (!Network.wifiEnabled)
                                Network.turnOnAndConnect(row.modelData.name);
                            else
                                Network.tryConnect(row.modelData.name);
                        }
                    }
                }
            }
        }
    }

    // Title with a dot: green while Wi-Fi is on, grey when off. Clicking it turns Wi-Fi on or off.
    Item {
        x: card.pad + 4
        y: card.pad
        width: dot.x + dot.width
        height: 22

        // Hover box.
        Rectangle {
            id: hoverBox

            visible: titleArea.containsMouse
            x: -6
            y: -2
            width: parent.width + 12
            height: parent.height + 4
            radius: IslandTheme.radiusButton
            color: card.hoverFill
        }

        IslandText {
            id: title

            anchors.verticalCenter: parent.verticalCenter
            text: "Wi-Fi"
            font.pixelSize: IslandTheme.heading
            font.weight: Font.DemiBold
        }

        Rectangle {
            id: dot

            x: title.width + 7
            anchors.verticalCenter: parent.verticalCenter
            width: 7
            height: 7
            radius: 3.5
            color: Network.wifiEnabled ? IslandTheme.online : IslandTheme.fg3
        }

        MouseArea {
            id: titleArea

            anchors.fill: hoverBox
            hoverEnabled: true
            onClicked: Network.toggleWifi()
        }
    }

    // Empty sections (no hotspot in range, or Wi-Fi off) are left out along with their divider.
    Section {
        id: hotspot

        visible: card.hotspots.length > 0
        y: card.pad + 22 + 10
        title: "Personal Hotspot"
        model: card.hotspots
    }

    Divider {
        id: hotspotLine

        visible: hotspot.visible && known.visible
        y: hotspot.y + hotspot.height + 10
    }

    Section {
        id: known

        visible: card.known.length > 0
        y: hotspot.visible ? hotspotLine.y + 10 : hotspot.y
        title: "Known networks"
        model: card.known
    }

    Divider {
        id: knownLine

        visible: hotspot.visible || known.visible
        y: (known.visible ? known.y + known.height : hotspot.y + hotspot.height) + 8
    }

    // Other networks and the Wi-Fi settings both live in the network app, so one row opens it.
    Rectangle {
        id: settings

        x: card.pad
        y: knownLine.visible ? knownLine.y + 4 : card.pad + 22 + 6
        width: card.inner
        height: 28
        radius: IslandTheme.radiusButton
        color: settingsArea.containsMouse ? card.hoverFill : "transparent"

        MouseArea {
            id: settingsArea

            anchors.fill: parent
            hoverEnabled: true
            onClicked: card.openSettings()
        }

        IslandText {
            x: 4
            anchors.verticalCenter: parent.verticalCenter
            text: "Network settings"
            tone: "secondary"
            font.pixelSize: IslandTheme.small
            font.weight: Font.Medium
        }

        SymbolicIcon {
            anchors.right: parent.right
            anchors.rightMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            name: "go-next-symbolic"
            color: IslandTheme.fg2
        }
    }
}
