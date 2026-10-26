import QtQuick
import "../../services"

IslandCard {
    id: card

    side: "solo"
    drop: 0

    readonly property int sideWidth: 210
    readonly property int sideGap: 10
    readonly property real sideHeight: Math.round(center.height * 0.8)
    readonly property real sideTop: Math.round((center.height - sideHeight) / 2)

    // Which side panels show; the card keeps its width either way so the control center stays centred.
    property bool wifiPanel: true
    property bool bluetoothPanel: true

    // Wi-Fi networks in range: the connected one says so, the rest show their signal strength; the lock
    // marks networks that need a password.
    readonly property var networks: Network.nearby.map(network => ({
        name: network.name,
        detail: network.connected ? "Connected" : Math.round(network.signalStrength * 100) + "%",
        on: network.connected,
        secure: Network.needsPassword(network),
        network
    }))

    // Keep scanning while the Wi-Fi panel is open so the list stays current.
    Binding {
        when: card.wifiPanel && Network.wifiDevice !== null
        target: Network.wifiDevice
        property: "scannerEnabled"
        value: true
    }
    readonly property var saved: [
        { name: "AirPods", detail: "Connected", on: true },
        { name: "Keychron K2", detail: "Paired", on: false }
    ]
    readonly property var nearby: [
        { name: "76-54-A3-…", detail: "Not paired", on: false },
        { name: "JBL Flip 5", detail: "Not paired", on: false },
        { name: "Galaxy Buds2", detail: "Not paired", on: false }
    ]

    width: 2 * (sideWidth + sideGap) + center.width
    height: center.height
    radius: 0
    color: "transparent"

    component Panel: Rectangle {
        property alias title: titleText.text

        y: card.sideTop
        width: card.sideWidth
        height: card.sideHeight
        radius: IslandTheme.radiusCard
        color: IslandTheme.pill

        IslandText {
            id: titleText

            x: 14
            line: 22
            font.pixelSize: IslandTheme.heading
            font.weight: Font.DemiBold
        }
    }

    component Entry: ListRow {
        id: entry

        required property var modelData
        property Component glyph

        width: parent.width
        height: 32
        radius: IslandTheme.radiusButton
        fill: IslandTheme.card
        highlight: modelData.on ? "strong" : "none"
        textX: 28
        title: modelData.name
        titleSize: IslandTheme.body
        subtitle: modelData.detail
        subtitleSize: IslandTheme.tiny

        Loader {
            x: 9
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: entry.glyph
            onLoaded: item.color = Qt.binding(() => entry.inverted ? IslandTheme.pill : IslandTheme.fg2)
        }
    }

    component SectionLabel: IslandText {
        x: 14
        tone: "muted"
        font.pixelSize: IslandTheme.tiny
    }

    component Scrollbar: Rectangle {
        width: 3
        height: 60
        radius: 1.5
        color: IslandTheme.fg3
    }

    Component {
        id: lock

        LockGlyph {}
    }

    Component {
        id: bluetooth

        BluetoothGlyph {}
    }

    Panel {
        visible: card.wifiPanel
        x: 0
        title: "Wi-Fi"

        ListView {
            x: 10
            y: 32
            width: parent.width - 20
            height: parent.height - 10 - y
            clip: true
            spacing: 6
            boundsBehavior: Flickable.StopAtBounds
            model: card.networks

            // Left click connects, disconnects or asks for a password.
            delegate: Entry {
                id: wifiEntry

                glyph: modelData.secure ? lock : null
                highlight: modelData.on ? "strong" : entryArea.containsMouse ? "subtle" : "none"

                MouseArea {
                    id: entryArea

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Network.activate(wifiEntry.modelData.network)
                }
            }
        }

        IslandText {
            visible: card.networks.length === 0
            anchors.centerIn: parent
            text: "No networks"
            tone: "muted"
            font.pixelSize: IslandTheme.small
        }
    }

    ControlCenterCard {
        id: center

        x: card.sideWidth + card.sideGap
        wifiOpen: card.wifiPanel
        onOpen: name => card.open(name)
    }

    Panel {
        visible: card.bluetoothPanel
        x: card.width - width
        title: "Bluetooth"

        SectionLabel {
            line: 40
            text: "saved"
        }

        Column {
            x: 10
            y: 46
            width: parent.width - 26
            spacing: 6

            Repeater {
                model: card.saved

                Entry {
                    glyph: bluetooth
                }
            }
        }

        SectionLabel {
            line: 126
            text: "nearby"
        }

        Item {
            x: 10
            y: 132
            width: parent.width - 26
            height: parent.height - 10 - y
            clip: true

            Column {
                width: parent.width
                spacing: 6

                Repeater {
                    model: card.nearby

                    Entry {
                        glyph: bluetooth
                    }
                }
            }
        }

        Scrollbar {
            x: parent.width - 11
            y: 46
        }
    }
}
