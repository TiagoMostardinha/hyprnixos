import QtQuick

IslandCard {
    id: card

    side: "solo"
    drop: 0
    gap: 0

    readonly property int pad: 12
    readonly property int inner: media.width

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

    width: inner + 2 * pad
    height: notifications.y + notifications.height + pad

    component Slider: LevelRow {
        x: card.pad
        width: card.inner
        height: 16
        glyphX: 2
        barX: 22
        barWidth: card.inner - 22 - 38
        textMargin: 0
    }

    MediaCard {
        id: media

        x: card.pad
        y: card.pad
        color: IslandTheme.card
        radius: IslandTheme.radiusSection
    }

    Repeater {
        model: card.toggles

        PillButton {
            required property var modelData
            required property int index

            x: card.pad + index * (width + 6)
            y: media.y + media.height + 8
            width: (card.inner - 3 * 6) / 4
            emphasis: modelData.on ? "secondary" : "quiet"
            label: modelData.label
            labelSize: IslandTheme.small
        }
    }

    Slider {
        id: volume

        y: media.y + media.height + 46
        level: 0.36

        SpeakerGlyph {
            color: IslandTheme.fg2
        }
    }

    Slider {
        id: brightness

        y: volume.y + 22
        level: 0.45

        SunGlyph {
            color: IslandTheme.fg2
        }
    }

    Rectangle {
        id: notifications

        x: card.pad
        y: brightness.y + brightness.height + 10
        width: card.inner
        height: 28 + card.notifications.length * 42
        radius: IslandTheme.radiusSection
        color: IslandTheme.card

        IslandText {
            x: 10
            line: 18
            text: "Notifications"
            tone: "secondary"
            font.pixelSize: IslandTheme.small
        }

        IslandText {
            x: parent.width - 10 - width
            line: 18
            text: "Clear all"
            tone: "secondary"
            font.pixelSize: IslandTheme.tiny
        }

        Repeater {
            model: card.notifications

            ListRow {
                required property var modelData
                required property int index

                x: 8
                y: 28 + index * 42
                width: notifications.width - 22
                height: 36
                radius: IslandTheme.radiusButton
                fill: IslandTheme.card2
                textX: 32
                spacing: 1
                overline: modelData.app
                title: modelData.summary
                titleSize: IslandTheme.body

                Rectangle {
                    x: 8
                    anchors.verticalCenter: parent.verticalCenter
                    width: 18
                    height: 18
                    radius: 9
                    color: IslandTheme.card
                }

                IslandText {
                    x: parent.width - 8 - width
                    line: 14
                    text: "×"
                    tone: "muted"
                    font.pixelSize: IslandTheme.small
                }
            }
        }

        Rectangle {
            x: parent.width - 8
            y: 28
            width: 3
            height: 50
            radius: 1.5
            color: IslandTheme.fg3
        }
    }
}
