import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import "../../services"

PanelWindow {
    id: root

    property string card: "Idle"
    // The media card replaces the left orb next to whatever card is in the middle.
    property bool media: false
    // Brightness or Volume, shown briefly over the middle card when the level changes.
    property string osd: ""
    property bool armed: false

    readonly property int orbSize: 28
    readonly property int top: 8
    readonly property int shadowRoom: 16

    readonly property Item center: osd ? osdLoader.item : cardLoader.item
    readonly property bool solo: cardLoader.item?.side === "solo"
    readonly property Item left: media ? mediaLoader.item : leftOrb

    // The orbs sit just outside the centered card, so they spread as it grows.
    readonly property real orbOffset: center ? center.width / 2 + center.gap : 0

    screen: Quickshell.screens.find(s => s.name === "eDP-1") ?? null
    anchors.top: true
    anchors.left: true
    anchors.right: true
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "island"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    implicitHeight: top + scene.height + shadowRoom
    color: "transparent"

    // Solo cards cover the whole island, so they close the media card.
    onSoloChanged: if (solo)
        media = false

    function flash(name) {
        if (!armed || solo)
            return;
        osd = name;
        osdTimer.restart();
    }

    Timer {
        id: osdTimer
        interval: 1500
        // Stay up while the pointer is on the OSD.
        onTriggered: osdLoader.item?.active ? restart() : root.osd = ""
    }

    // Levels settle as the services connect at startup; only react to changes after that.
    Timer {
        running: true
        interval: 1000
        onTriggered: root.armed = true
    }

    Connections {
        target: Brightness

        function onLevelChanged() {
            root.flash("Brightness");
        }
    }

    Connections {
        target: Audio

        function onVolumeChanged() {
            root.flash("Volume");
        }

        function onMutedChanged() {
            root.flash("Volume");
        }
    }

    mask: Region {
        Region { item: root.solo ? null : root.left }
        Region { item: root.center }
        Region { item: root.solo ? null : rightOrb }
    }

    Item {
        id: scene

        y: root.top
        width: root.width
        height: Math.max(root.solo ? 1 : root.orbSize, root.center ? root.center.drop + root.center.height : 0, root.media && root.left ? root.left.drop + root.left.height : 0)

        focus: true
        Keys.onEscapePressed: {
            root.card = "Idle";
            root.media = false;
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "black"
            shadowOpacity: IslandTheme.shadowOpacity
            shadowBlur: IslandTheme.shadowBlur
            shadowVerticalOffset: IslandTheme.shadowOffset
        }

        Loader {
            id: cardLoader

            visible: !root.osd
            x: scene.width / 2 - (item?.width ?? 0) / 2
            y: item ? item.drop : 0
            source: root.card + "Card.qml"

            MouseArea {
                anchors.fill: parent
                enabled: root.card === "Idle"
                onClicked: root.card = "Week"
            }

            Connections {
                target: cardLoader.item
                ignoreUnknownSignals: true

                function onOpen(card) {
                    root.card = card;
                }
            }
        }

        Loader {
            id: osdLoader

            active: root.osd !== ""
            x: scene.width / 2 - (item?.width ?? 0) / 2
            y: item ? item.drop : 0
            source: root.osd + "Card.qml"
        }

        Loader {
            id: mediaLoader

            active: root.media
            x: scene.width / 2 - (root.center?.width ?? 0) / 2 - (item?.gap ?? 0) - (item?.width ?? 0)
            y: item ? item.drop : 0
            source: "MediaCard.qml"
        }

        CoverOrb {
            id: leftOrb

            visible: !root.media && !root.solo
            x: scene.width / 2 - root.orbOffset - width

            MouseArea {
                anchors.fill: parent
                onClicked: root.media = true
            }
        }

        StatusOrb {
            id: rightOrb

            visible: !root.solo
            x: scene.width / 2 + root.orbOffset
            battery: Battery.available ? Battery.percent / 100 : 1
            networkIcon: Network.icon

            MouseArea {
                anchors.fill: parent
                onClicked: root.card = "ControlCenter"
            }
        }
    }
}
