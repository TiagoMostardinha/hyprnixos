import QtQuick
import Quickshell.Widgets
import "../../services"

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
        interactive: true
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
        level: Audio.muted ? 0 : Math.min(Audio.volume, 1)
        onMoved: level => Audio.set(level)

        SpeakerGlyph {
            color: IslandTheme.fg2
        }
    }

    Slider {
        id: brightness

        y: volume.y + 22
        level: Brightness.level
        onMoved: level => Brightness.set(level)

        SunGlyph {
            color: IslandTheme.fg2
        }
    }

    Rectangle {
        id: notifications

        readonly property int rowStep: 42

        x: card.pad
        y: brightness.y + brightness.height + 10
        width: card.inner
        // Room for two notifications; more scroll.
        height: 28 + 2 * rowStep
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
            visible: Notifications.all.length > 0
            x: parent.width - 10 - width
            line: 18
            text: "Clear all"
            tone: clearArea.containsMouse ? "primary" : "secondary"
            font.pixelSize: IslandTheme.tiny

            MouseArea {
                id: clearArea

                anchors.fill: parent
                anchors.margins: -4
                hoverEnabled: true
                onClicked: Notifications.clear()
            }
        }

        IslandText {
            visible: Notifications.all.length === 0
            anchors.horizontalCenter: parent.horizontalCenter
            line: 28 + notifications.rowStep
            text: "No notifications"
            tone: "muted"
            font.pixelSize: IslandTheme.small
        }

        ListView {
            id: list

            x: 8
            y: 28
            width: parent.width - 22
            height: parent.height - y - 6
            clip: true
            spacing: notifications.rowStep - 36
            boundsBehavior: Flickable.StopAtBounds
            model: Notifications.history

            delegate: ListRow {
                id: row

                required property var modelData

                readonly property string icon: Notifications.icon(modelData)

                width: ListView.view.width
                height: 36
                radius: IslandTheme.radiusButton
                fill: IslandTheme.card2
                textX: 32
                spacing: 1
                overline: modelData.appName
                title: modelData.summary
                titleSize: IslandTheme.body

                // Clicking a notification runs its default action and clears it.
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        row.modelData.actions.find(action => action.identifier === "default")?.invoke();
                        row.modelData.dismiss();
                    }
                }

                Rectangle {
                    visible: row.icon === ""
                    x: 8
                    anchors.verticalCenter: parent.verticalCenter
                    width: 18
                    height: 18
                    radius: 9
                    color: IslandTheme.card

                    IslandText {
                        anchors.centerIn: parent
                        text: (row.modelData.appName || "?")[0].toUpperCase()
                        font.pixelSize: IslandTheme.tiny
                        font.weight: Font.DemiBold
                    }
                }

                IconImage {
                    visible: row.icon !== ""
                    x: 8
                    anchors.verticalCenter: parent.verticalCenter
                    implicitSize: 18
                    source: row.icon
                }

                IslandText {
                    x: parent.width - 8 - width
                    line: 14
                    text: "×"
                    tone: closeArea.containsMouse ? "primary" : "muted"
                    font.pixelSize: IslandTheme.small

                    MouseArea {
                        id: closeArea

                        anchors.fill: parent
                        anchors.margins: -4
                        hoverEnabled: true
                        onClicked: row.modelData.dismiss()
                    }
                }
            }
        }

        // Scroll position, shown only when the list is longer than the box.
        Rectangle {
            visible: list.visibleArea.heightRatio < 1
            x: parent.width - 8
            y: list.y + list.visibleArea.yPosition * list.height
            width: 3
            height: list.visibleArea.heightRatio * list.height
            radius: 1.5
            color: IslandTheme.fg3
        }
    }
}
