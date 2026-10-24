import QtQuick

Rectangle {
    id: card

    readonly property string side: "solo"
    readonly property int drop: 0
    readonly property int gap: 0

    readonly property real mediaScale: (width - 28) / media.width
    readonly property real below: media.height * mediaScale - 130

    readonly property var toggles: [
        { label: "Wi-Fi", on: true },
        { label: "DND", on: false },
        { label: "profile", on: false },
        { label: "BT", on: true }
    ]
    readonly property var sliders: [
        { glyph: speaker, level: 0.36 },
        { glyph: sun, level: 0.45 }
    ]
    readonly property var notifications: [
        { app: "Git", summary: "Committed: add bluetooth feature" },
        { app: "Wallpaper", summary: "Wallpaper changed" }
    ]

    width: 380
    height: below + 470
    radius: 30
    color: IslandTheme.pill

    component Label: Text {
        property real line

        y: line - baselineOffset
        font.family: IslandTheme.font
    }

    Component {
        id: speaker

        SpeakerGlyph {
            color: IslandTheme.fg2
        }
    }

    Component {
        id: sun

        SunGlyph {
            color: IslandTheme.fg2
        }
    }

    MediaCard {
        id: media

        x: 14
        y: 14
        scale: card.mediaScale
        transformOrigin: Item.TopLeft
        color: IslandTheme.card
    }

    Repeater {
        model: card.toggles

        Rectangle {
            required property var modelData
            required property int index

            x: 14 + index * (width + 8)
            y: card.below + 156
            width: (card.width - 28 - 3 * 8) / 4
            height: 40
            radius: 20
            color: modelData.on ? IslandTheme.card2 : IslandTheme.card

            Text {
                anchors.centerIn: parent
                text: parent.modelData.label
                color: parent.modelData.on ? IslandTheme.fg : IslandTheme.fg2
                font.family: IslandTheme.font
                font.pixelSize: 11
                font.weight: Font.DemiBold
            }
        }
    }

    Repeater {
        model: card.sliders

        Item {
            required property var modelData
            required property int index

            y: card.below + 214 + index * 26
            width: card.width
            height: 8

            Loader {
                x: 32 - 8
                y: 4 - 8
                sourceComponent: parent.modelData.glyph
            }

            LevelBar {
                x: 52
                width: card.width - 110
                height: 8
                level: parent.modelData.level
            }

            Label {
                x: card.width - 22 - width
                line: 9
                text: Math.round(parent.modelData.level * 100) + "%"
                color: IslandTheme.fg2
                font.pixelSize: 10
            }
        }
    }

    Rectangle {
        id: notifications

        x: 14
        y: card.below + 270
        width: card.width - 28
        height: card.height - 14 - y
        radius: 18
        color: IslandTheme.card

        Label {
            x: 14
            line: 22
            text: "Notifications"
            color: IslandTheme.fg2
            font.pixelSize: 11
        }

        Label {
            x: parent.width - 14 - width
            line: 22
            text: "Clear all"
            color: IslandTheme.fg2
            font.pixelSize: 10
        }

        Repeater {
            model: card.notifications

            Rectangle {
                required property var modelData
                required property int index

                x: 10
                y: 36 + index * 66
                width: notifications.width - 28
                height: 58
                radius: 12
                color: IslandTheme.card2

                Rectangle {
                    x: 10
                    anchors.verticalCenter: parent.verticalCenter
                    width: 24
                    height: 24
                    radius: 12
                    color: IslandTheme.card
                }

                Label {
                    x: 42
                    line: 22
                    text: parent.modelData.app
                    color: IslandTheme.fg2
                    font.pixelSize: 10
                }

                Label {
                    x: 42
                    line: 38
                    text: parent.modelData.summary
                    color: IslandTheme.fg
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                }

                Label {
                    x: parent.width - 10 - width
                    line: 18
                    text: "×"
                    color: IslandTheme.fg3
                    font.pixelSize: 12
                }
            }
        }

        Rectangle {
            x: parent.width - 8
            y: 36
            width: 3
            height: 60
            radius: 1.5
            color: IslandTheme.fg3
        }
    }
}
