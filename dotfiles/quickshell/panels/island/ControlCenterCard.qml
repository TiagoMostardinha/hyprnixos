import QtQuick

IslandCard {
    id: card

    side: "solo"
    drop: 0
    gap: 0

    readonly property real mediaScale: (width - 28) / media.width
    readonly property real below: media.height * mediaScale - 130

    readonly property var toggles: [
        { label: "Wi-Fi", on: true },
        { label: "DND", on: false },
        { label: "profile", on: false },
        { label: "BT", on: true }
    ]
    readonly property var notifications: [
        { app: "Git", summary: "Committed: add bluetooth feature" },
        { app: "Wallpaper", summary: "Wallpaper changed" }
    ]

    width: 380
    height: below + 470

    component Slider: LevelRow {
        width: card.width
        height: 8
        glyphX: 24
        barX: 52
        barWidth: card.width - 110
        barHeight: 8
        textMargin: 22
        textSize: 10
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

        PillButton {
            required property var modelData
            required property int index

            x: 14 + index * (width + 8)
            y: card.below + 156
            width: (card.width - 28 - 3 * 8) / 4
            height: 40
            emphasis: modelData.on ? "secondary" : "quiet"
            label: modelData.label
            labelSize: 11
        }
    }

    Slider {
        y: card.below + 214
        level: 0.36

        SpeakerGlyph {
            color: IslandTheme.fg2
        }
    }

    Slider {
        y: card.below + 240
        level: 0.45

        SunGlyph {
            color: IslandTheme.fg2
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

        IslandText {
            x: 14
            line: 22
            text: "Notifications"
            tone: "secondary"
            font.pixelSize: 11
        }

        IslandText {
            x: parent.width - 14 - width
            line: 22
            text: "Clear all"
            tone: "secondary"
            font.pixelSize: 10
        }

        Repeater {
            model: card.notifications

            ListRow {
                required property var modelData
                required property int index

                x: 10
                y: 36 + index * 66
                width: notifications.width - 28
                height: 58
                radius: 12
                fill: IslandTheme.card2
                spacing: 2
                overline: modelData.app
                title: modelData.summary
                titleSize: 12

                Rectangle {
                    x: 10
                    anchors.verticalCenter: parent.verticalCenter
                    width: 24
                    height: 24
                    radius: 12
                    color: IslandTheme.card
                }

                IslandText {
                    x: parent.width - 10 - width
                    line: 18
                    text: "×"
                    tone: "muted"
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
