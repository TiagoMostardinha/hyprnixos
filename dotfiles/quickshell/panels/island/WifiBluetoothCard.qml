import QtQuick

IslandCard {
    id: card

    side: "solo"
    drop: 0
    gap: 0

    readonly property int sideWidth: 210
    readonly property int sideGap: 10
    readonly property real sideHeight: Math.round(center.height * 0.8)
    readonly property real sideTop: Math.round((center.height - sideHeight) / 2)

    readonly property var networks: [
        { name: "HomeNet", detail: "Connected", on: true },
        { name: "Vodafone-5G", detail: "40%", on: false },
        { name: "MEO-WiFi", detail: "22%", on: false },
        { name: "NOS-A3F1", detail: "18%", on: false },
        { name: "eduroam", detail: "12%", on: false },
        { name: "Pastelaria-Guest", detail: "9%", on: false },
        { name: "DIRECT-HP-Printer", detail: "6%", on: false }
    ]
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
        x: 0
        title: "Wi-Fi"

        Item {
            x: 10
            y: 32
            width: parent.width - 26
            height: parent.height - 10 - y
            clip: true

            Column {
                width: parent.width
                spacing: 6

                Repeater {
                    model: card.networks

                    Entry {
                        glyph: lock
                    }
                }
            }
        }

        Scrollbar {
            x: parent.width - 11
            y: 32
        }
    }

    ControlCenterCard {
        id: center

        x: card.sideWidth + card.sideGap
    }

    Panel {
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
