import QtQuick

Item {
    id: card

    readonly property string side: "solo"
    readonly property int drop: 0
    readonly property int gap: 0

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

    component Label: Text {
        property real line

        y: line - baselineOffset
        font.family: IslandTheme.font
    }

    component Panel: Rectangle {
        property alias title: titleLabel.text

        y: card.sideTop
        width: card.sideWidth
        height: 330
        radius: 26
        color: IslandTheme.pill

        Label {
            id: titleLabel

            x: 20
            line: 32
            color: IslandTheme.fg
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }
    }

    component Row: Rectangle {
        id: row

        required property var modelData
        property Component glyph

        height: 54
        radius: 16
        color: modelData.on ? IslandTheme.fg : IslandTheme.card

        Loader {
            active: row.modelData.name !== ""
            x: 22 - 8
            y: 27 - 8
            sourceComponent: row.glyph
            onLoaded: item.color = row.modelData.on ? IslandTheme.pill : IslandTheme.fg2
        }

        Label {
            x: 42
            line: 24
            text: row.modelData.name
            color: row.modelData.on ? IslandTheme.pill : IslandTheme.fg
            font.pixelSize: 13
            font.weight: Font.DemiBold
        }

        Label {
            x: 42
            line: 41
            text: row.modelData.detail
            color: row.modelData.on ? IslandTheme.card2 : IslandTheme.fg2
            font.pixelSize: 10
        }
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

                    Row {
                        width: parent.width
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

        Label {
            x: 20
            line: 56
            text: "saved"
            color: IslandTheme.fg3
            font.pixelSize: 10
        }

        Column {
            x: 14
            y: 64
            width: parent.width - 28
            spacing: 8

            Repeater {
                model: card.saved

                Row {
                    width: parent.width
                    glyph: bluetooth
                }
            }
        }

        Label {
            x: 20
            line: 206
            text: "nearby"
            color: IslandTheme.fg3
            font.pixelSize: 10
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

                    Row {
                        width: parent.width
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
