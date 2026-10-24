import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    readonly property string card: "WifiBluetooth"

    readonly property int orbSize: 32
    readonly property real battery: 1.0

    readonly property Item shown: cardLoader.item
    readonly property bool leftCard: shown?.side === "left"
    readonly property bool solo: shown?.side === "solo"
    readonly property Item center: leftCard ? idleLoader.item : shown
    readonly property Item left: leftCard ? shown : leftOrb

    readonly property real leftExtent: solo ? center.width / 2 : center ? center.width / 2 + (leftCard ? shown.gap : center.gap) + left.width : 0
    readonly property real rightExtent: solo ? center.width / 2 : center ? center.width / 2 + center.gap + orbSize : 0

    screen: Quickshell.screens.find(s => s.name === "eDP-1") ?? null
    anchors.top: true
    margins.top: 10
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "island"

    implicitWidth: Math.max(1, 2 * Math.max(leftExtent, rightExtent))
    implicitHeight: Math.max(solo ? 1 : orbSize, center ? center.drop + center.height : 0, leftCard ? shown.drop + shown.height : 0)
    color: "transparent"

    mask: Region {
        Region { item: root.solo ? null : root.left }
        Region { item: root.center }
        Region { item: root.solo ? null : rightOrb }
    }

    Loader {
        id: cardLoader

        x: root.leftCard ? root.width / 2 - root.leftExtent : root.width / 2 - (item ? item.width : 0) / 2
        y: item ? item.drop : 0
        source: root.card + "Card.qml"
    }

    Loader {
        id: idleLoader

        active: root.leftCard
        x: root.width / 2 - width / 2
        source: "IdleCard.qml"
    }

    CoverOrb {
        id: leftOrb

        visible: !root.leftCard && !root.solo
        x: root.width / 2 - root.leftExtent
    }

    StatusOrb {
        id: rightOrb

        visible: !root.solo
        x: root.width / 2 + root.rightExtent - width
        battery: root.battery
    }
}
