import QtQuick

IslandCard {
    id: card

    side: "solo"
    drop: 0
    gap: 0

    readonly property int sideWidth: 260
    readonly property int sideGap: 12
    readonly property int sideTop: 60

    readonly property var networks: [
        { name: "HomeNet", detail: "Connected", on: true },
        { name: "Vodafone-5G", detail: "40%", on: false },
        { name: "MEO-WiFi", detail: "22%", on: false },
        { name: "NOS-A3F1", detail: "18%", on: false },
        { name: "eduroam", detail: "12%", on: false }
    ]
    readonly property var saved: [
        { name: "AirPods", detail: "Connected", on: true },
        { name: "Keychron K2", detail: "Paired", on: false }
    ]
    readonly property var nearby: [
        { name: "76-54-A3-…", detail: "Not paired", on: false },
        { name: "", detail: "", on: false }
    ]

    width: 2 * (sideWidth + sideGap) + center.width
    height: center.height
    radius: 0
    color: "transparent"

    component Panel: Rectangle {
        property alias title: titleText.text

        y: card.sideTop
        width: card.sideWidth
        height: 330
        radius: 26
        color: IslandTheme.pill

        IslandText {
            id: titleText

            x: 20
            line: 32
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }
    }

    component Entry: ListRow {
        id: entry

        required property var modelData
        property Component glyph

        width: parent.width
        height: 54
        radius: 16
        fill: IslandTheme.card
        highlight: modelData.on ? "strong" : "none"
        spacing: 4
        title: modelData.name
        subtitle: modelData.detail

        Loader {
            active: entry.title !== ""
            x: 14
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: entry.glyph
            onLoaded: item.color = Qt.binding(() => entry.inverted ? IslandTheme.pill : IslandTheme.fg2)
        }
    }

    component SectionLabel: IslandText {
        x: 20
        tone: "muted"
        font.pixelSize: 10
    }

    component Scrollbar: Rectangle {
        width: 3
        height: 90
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
            x: 14
            y: 50
            width: parent.width - 34
            height: parent.height - 14 - y
            clip: true

            Column {
                width: parent.width
                spacing: 10

                Repeater {
                    model: card.networks

                    Entry {
                        glyph: lock
                    }
                }
            }
        }

        Scrollbar {
            x: parent.width - 14
            y: 50
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
            line: 56
            text: "saved"
        }

        Column {
            x: 14
            y: 64
            width: parent.width - 28
            spacing: 8

            Repeater {
                model: card.saved

                Entry {
                    glyph: bluetooth
                }
            }
        }

        SectionLabel {
            line: 206
            text: "nearby"
        }

        Item {
            x: 14
            y: 214
            width: parent.width - 28
            height: 84
            clip: true

            Column {
                width: parent.width
                spacing: 8

                Repeater {
                    model: card.nearby

                    Entry {
                        glyph: bluetooth
                    }
                }
            }
        }

        Scrollbar {
            x: parent.width - 10
            y: 64
        }
    }
}
