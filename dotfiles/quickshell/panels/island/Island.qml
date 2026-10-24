import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    readonly property string card: "Idle"

    readonly property int orbSize: 28
    readonly property real battery: 0.75
    readonly property int top: 8
    readonly property int shadowRoom: 16

    readonly property Item shown: cardLoader.item
    readonly property bool leftCard: shown?.side === "left"
    readonly property bool solo: shown?.side === "solo"
    readonly property Item center: leftCard ? idleLoader.item : shown
    readonly property Item left: leftCard ? shown : leftOrb

    readonly property real leftExtent: solo ? center.width / 2 : center ? center.width / 2 + (leftCard ? shown.gap : center.gap) + left.width : 0
    readonly property real rightExtent: solo ? center.width / 2 : center ? center.width / 2 + center.gap + orbSize : 0

    screen: Quickshell.screens.find(s => s.name === "eDP-1") ?? null
    anchors.top: true
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "island"

    implicitWidth: scene.width + 2 * shadowRoom
    implicitHeight: top + scene.height + shadowRoom
    color: "transparent"

    mask: Region {
        Region { item: root.solo ? null : root.left }
        Region { item: root.center }
        Region { item: root.solo ? null : rightOrb }
    }

    Item {
        id: scene

        x: root.shadowRoom
        y: root.top
        width: Math.max(1, 2 * Math.max(root.leftExtent, root.rightExtent))
        height: Math.max(root.solo ? 1 : root.orbSize, root.center ? root.center.drop + root.center.height : 0, root.leftCard ? root.shown.drop + root.shown.height : 0)

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

            x: root.leftCard ? scene.width / 2 - root.leftExtent : scene.width / 2 - (item ? item.width : 0) / 2
            y: item ? item.drop : 0
            source: root.card + "Card.qml"
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
            x: scene.width / 2 - root.leftExtent
        }

        StatusOrb {
            id: rightOrb

            visible: !root.solo
            x: scene.width / 2 + root.rightExtent - width
            battery: root.battery
        }
    }
}
