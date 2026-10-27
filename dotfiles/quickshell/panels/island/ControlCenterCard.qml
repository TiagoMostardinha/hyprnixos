import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import Quickshell.Widgets
import "../../services"

IslandCard {
    id: card

    side: "solo"
    drop: 0

    readonly property int pad: 12
    readonly property int inner: 340
    // The notifications box takes the whole control center below the screenshot button.
    property bool expanded: false

    // Power profile, cycled eco -> normal -> performance (skipped if the machine has none).
    readonly property var profiles: PowerProfiles.hasPerformanceProfile
        ? [PowerProfile.PowerSaver, PowerProfile.Balanced, PowerProfile.Performance]
        : [PowerProfile.PowerSaver, PowerProfile.Balanced]
    // Each profile's Colloid icon: a leaf (eco), "=" (balanced), a bolt (performance).
    readonly property string profileIcon: ({
        [PowerProfile.PowerSaver]: "emoji-nature-symbolic",
        [PowerProfile.Balanced]: "image-equalize-symbolic",
        [PowerProfile.Performance]: "preferences-system-power-symbolic"
    })[PowerProfiles.profile] ?? ""
    readonly property string profileName: ({
        [PowerProfile.PowerSaver]: "Eco",
        [PowerProfile.Balanced]: "Balanced",
        [PowerProfile.Performance]: "Performance"
    })[PowerProfiles.profile] ?? ""

    width: inner + 2 * pad
    height: notifications.y + notifications.height + pad

    // Screenshot: closes the control center (so it isn't in the shot), then lets you pick an area and
    // opens it in swappy, like the Print key.
    Item {
        id: screenshot

        x: card.pad
        y: 8
        width: card.inner
        height: 20

        Rectangle {
            anchors.centerIn: parent
            width: shotRow.width + 12
            height: parent.height
            radius: height / 2
            color: shotArea.containsMouse ? IslandTheme.card2 : "transparent"
        }

        Row {
            id: shotRow

            anchors.centerIn: parent
            spacing: 5

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 16
                height: 16
                radius: 8
                color: IslandTheme.card2

                SymbolicIcon {
                    anchors.centerIn: parent
                    name: "screenshot-app-symbolic"
                    size: 10
                }
            }

            IslandText {
                anchors.verticalCenter: parent.verticalCenter
                text: "Screenshot"
                font.pixelSize: IslandTheme.small
                font.weight: Font.Medium
            }
        }

        MouseArea {
            id: shotArea

            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                card.open("Idle");
                Quickshell.execDetached(["sh", "-c", 'sleep 0.2; grim -g "$(slurp)" - | swappy -f -']);
            }
        }
    }

    // Toggles, laid out like a two-column control panel: a tall box of rows on the left (Wi-Fi,
    // Bluetooth, one to define later), and on the right a wide Focus tile over two square tiles
    // (power profile, one to define later). A filled white circle means "on".
    readonly property real togglesTop: screenshot.y + screenshot.height + 6
    readonly property real togglesHeight: 120
    readonly property real column: (inner - 6) / 2
    readonly property real tileHeight: (togglesHeight - 6) / 2

    component Circle: Rectangle {
        property string icon
        property bool on

        width: 28
        height: 28
        radius: 14
        color: on ? IslandTheme.fg : IslandTheme.card2

        SymbolicIcon {
            visible: parent.icon !== ""
            anchors.centerIn: parent
            name: parent.icon
            size: 14
            color: parent.on ? IslandTheme.pill : IslandTheme.fg
        }
    }

    component Tile: Rectangle {
        id: tile

        readonly property bool hovered: tileArea.containsMouse

        signal clicked
        signal rightClicked

        radius: IslandTheme.radiusSection
        color: hovered ? IslandTheme.card2 : IslandTheme.card

        MouseArea {
            id: tileArea

            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: mouse => mouse.button === Qt.RightButton ? tile.rightClicked() : tile.clicked()
            // A long press (on the touch screen) counts as a right click.
            onPressAndHold: tile.rightClicked()
        }
    }

    component ToggleRow: Tile {
        property alias icon: circle.icon
        property alias on: circle.on
        property alias title: titleText.text
        property alias subtitle: subtitleText.text

        width: parent.width
        height: 36
        radius: IslandTheme.radiusButton
        color: hovered ? IslandTheme.card2 : "transparent"

        Circle {
            id: circle

            x: 4
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            x: 40
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - x - 6

            IslandText {
                id: titleText

                width: parent.width
                elide: Text.ElideRight
                font.pixelSize: IslandTheme.body
                font.weight: Font.DemiBold
            }

            IslandText {
                id: subtitleText

                visible: text !== ""
                width: parent.width
                elide: Text.ElideRight
                tone: "secondary"
                font.pixelSize: IslandTheme.tiny
            }
        }
    }

    Rectangle {
        visible: !card.expanded
        x: card.pad
        y: card.togglesTop
        width: card.column
        height: card.togglesHeight
        radius: IslandTheme.radiusSection
        color: IslandTheme.card

        Column {
            x: 6
            y: 6
            width: parent.width - 12

            // Wi-Fi: left click turns it on or off; right click opens the Wi-Fi menu.
            ToggleRow {
                icon: Network.wifiIcon
                on: Network.wifi !== null && Network.wifi !== undefined
                title: "Wi-Fi"
                subtitle: Network.wifi?.name ?? (Network.wifiEnabled ? "Not connected" : "Off")
                onClicked: Network.toggleWifi()
                onRightClicked: card.open("WifiMenu")
            }

            // Bluetooth: left click turns it on or off; right click opens the Bluetooth menu.
            ToggleRow {
                icon: Bluetooth.defaultAdapter?.enabled ? "bluetooth-active-symbolic" : "bluetooth-disabled-symbolic"
                on: Bluetooth.defaultAdapter?.enabled ?? false
                title: "Bluetooth"
                subtitle: Bluetooth.defaultAdapter?.enabled ? "On" : "Off"
                onClicked: BluetoothDevices.toggle()
                onRightClicked: card.open("BluetoothMenu")
            }

            // To be defined later.
            ToggleRow {
                title: "—"
            }
        }
    }

    // Focus (do not disturb): a moon; white while notifications are held back.
    Tile {
        visible: !card.expanded
        x: card.pad + card.column + 6
        y: card.togglesTop
        width: card.column
        height: card.tileHeight
        onClicked: Notifications.dnd = !Notifications.dnd

        Circle {
            id: focusCircle

            x: 12
            anchors.verticalCenter: parent.verticalCenter
            icon: "weather-clear-night-symbolic"
            on: Notifications.dnd
        }

        IslandText {
            x: focusCircle.x + focusCircle.width + 10
            anchors.verticalCenter: parent.verticalCenter
            text: "Focus"
            font.pixelSize: IslandTheme.title
            font.weight: Font.DemiBold
        }
    }

    // Power profile: cycles eco -> balanced -> performance.
    Tile {
        visible: !card.expanded
        x: card.pad + card.column + 6
        y: card.togglesTop + card.tileHeight + 6
        width: (card.column - 6) / 2
        height: card.tileHeight
        onClicked: {
            const next = (card.profiles.indexOf(PowerProfiles.profile) + 1) % card.profiles.length;
            PowerProfiles.profile = card.profiles[next];
        }

        Column {
            anchors.centerIn: parent
            spacing: 4

            SymbolicIcon {
                anchors.horizontalCenter: parent.horizontalCenter
                name: card.profileIcon
                size: 16
            }

            IslandText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: card.profileName
                font.pixelSize: IslandTheme.tiny
                font.weight: Font.Medium
            }
        }
    }

    // To be defined later.
    Tile {
        visible: !card.expanded
        x: card.pad + card.column + 6 + (card.column - 6) / 2 + 6
        y: card.togglesTop + card.tileHeight + 6
        width: (card.column - 6) / 2
        height: card.tileHeight

        IslandText {
            anchors.centerIn: parent
            text: "—"
            tone: "muted"
        }
    }

    // Display and Sound: a titled box around each slider.
    component LevelBox: Rectangle {
        property alias title: boxTitle.text

        x: card.pad
        width: card.inner
        height: 44
        radius: IslandTheme.radiusSection
        color: IslandTheme.card

        IslandText {
            id: boxTitle

            x: 12
            line: 16
            tone: "secondary"
            font.pixelSize: IslandTheme.small
            font.weight: Font.Medium
        }
    }

    component Slider: LevelRow {
        x: 12
        y: 22
        width: parent.width - 24
        height: 16
        glyphX: 2
        barX: 22
        barWidth: width - 22 - 38
        textMargin: 0
        interactive: true
    }

    LevelBox {
        id: brightness

        visible: !card.expanded
        y: card.togglesTop + card.togglesHeight + 8
        title: "Display"

        Slider {
            level: Brightness.level
            onMoved: level => Brightness.set(level)

            SunGlyph {
                color: IslandTheme.fg2
            }
        }
    }

    LevelBox {
        id: volume

        visible: !card.expanded
        y: brightness.y + brightness.height + 8
        title: "Sound"

        Slider {
            level: Audio.muted ? 0 : Math.min(Audio.volume, 1)
            onMoved: level => Audio.set(level)

            SpeakerGlyph {
                color: IslandTheme.fg2
            }
        }
    }

    Rectangle {
        id: notifications

        readonly property int rowStep: 50

        // Where it sits collapsed; expanded it starts where the toggles do and ends at the same place.
        readonly property real collapsedY: volume.y + volume.height + 8

        x: card.pad
        y: card.expanded ? card.togglesTop : collapsedY
        width: card.inner
        // Room for two notifications; more scroll.
        height: 28 + 2 * rowStep + (card.expanded ? collapsedY - card.togglesTop : 0)
        radius: IslandTheme.radiusSection
        color: IslandTheme.card

        // Clicking the title expands or collapses the box; on hover an icon beside it shows which.
        IslandText {
            x: 10
            line: 18
            text: "Notifications"
            tone: titleArea.containsMouse ? "primary" : "secondary"
            font.pixelSize: IslandTheme.small

            SymbolicIcon {
                visible: titleArea.containsMouse
                x: parent.width + 6
                anchors.verticalCenter: parent.verticalCenter
                size: 10
                name: card.expanded ? "view-restore-symbolic" : "view-fullscreen-symbolic"
            }

            MouseArea {
                id: titleArea

                anchors.fill: parent
                anchors.leftMargin: -4
                anchors.topMargin: -4
                anchors.bottomMargin: -4
                anchors.rightMargin: -20
                hoverEnabled: true
                onClicked: card.expanded = !card.expanded
            }
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
            // Centred in the space below the header.
            line: (28 + parent.height) / 2 + 4
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
            spacing: notifications.rowStep - 44
            boundsBehavior: Flickable.StopAtBounds
            model: Notifications.history

            delegate: ListRow {
                id: row

                required property var modelData

                readonly property string icon: Notifications.icon(modelData)

                width: ListView.view.width
                // Expanded, rows grow to show up to four lines of the message.
                height: card.expanded ? Math.max(44, textHeight + 14) : 44
                radius: IslandTheme.radiusButton
                fill: IslandTheme.card2
                textX: 32
                spacing: 1
                overline: modelData.appName
                title: modelData.summary
                titleSize: IslandTheme.body
                // The message as a dim line under the title (up to four when expanded).
                subtitle: (modelData.body || "").replace(/\s+/g, " ")
                subtitleSize: IslandTheme.tiny
                subtitleLines: card.expanded ? 4 : 1
                textRight: 44

                // Clicking a notification inverts it while pressed, then opens the app that sent it, clears
                // it and closes the control center.
                highlight: rowArea.pressed ? "strong" : "none"

                MouseArea {
                    id: rowArea

                    anchors.fill: parent
                    onClicked: {
                        const notification = row.modelData;
                        Notifications.openApp(notification);
                        card.open("Idle");
                        notification.dismiss();
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

                // How long ago it arrived, left of the close button.
                IslandText {
                    x: close.x - 6 - width
                    line: (row.height - row.textHeight) / 2 + 10
                    text: Notifications.ago(row.modelData)
                    tone: "muted"
                    font.pixelSize: IslandTheme.tiny
                }

                IslandText {
                    id: close

                    x: parent.width - 8 - width
                    line: (row.height - row.textHeight) / 2 + 10
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
