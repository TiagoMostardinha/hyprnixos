import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import "../../services"

PanelWindow {
    id: root

    property string card: "Idle"

    readonly property int orbSize: 28
    readonly property int top: 8
    readonly property int shadowRoom: 16

    readonly property Item shown: cardLoader.item
    readonly property bool leftCard: shown?.side === "left"
    readonly property bool solo: shown?.side === "solo"
    readonly property Item center: leftCard ? idleLoader.item : shown
    readonly property Item left: leftCard ? shown : leftOrb

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

    mask: Region {
        Region { item: root.solo ? null : root.left }
        Region { item: root.center }
        Region { item: root.solo ? null : rightOrb }
    }

    Item {
        id: scene

        y: root.top
        width: root.width
        height: Math.max(root.solo ? 1 : root.orbSize, root.center ? root.center.drop + root.center.height : 0, root.leftCard ? root.shown.drop + root.shown.height : 0)

        focus: true
        Keys.onEscapePressed: root.card = "Idle"

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

            x: root.leftCard ? scene.width / 2 - root.center.width / 2 - (item?.gap ?? 0) - (item?.width ?? 0) : scene.width / 2 - (item?.width ?? 0) / 2
            y: item ? item.drop : 0
            source: root.card + "Card.qml"

            MouseArea {
                anchors.fill: parent
                enabled: root.card === "Idle"
                onClicked: root.card = "Week"
            }
        }

        Loader {
            id: idleLoader

            active: root.leftCard
            x: scene.width / 2 - width / 2
            source: "IdleCard.qml"
        }

        CoverOrb {
            id: leftOrb

            visible: !root.leftCard && !root.solo
            x: scene.width / 2 - root.orbOffset - width

            MouseArea {
                anchors.fill: parent
                onClicked: root.card = "Media"
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
