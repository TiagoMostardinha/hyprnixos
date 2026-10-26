pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property color pill: "#050505"
    readonly property color card: "#161616"
    readonly property color card2: "#222222"
    readonly property color line: "#2c2c2c"
    readonly property color fg: "#ffffff"
    readonly property color fg2: "#9a9a9a"
    readonly property color fg3: "#5a5a5a"
    // Hover box: the card grey at 60%, as on the week card.
    readonly property color hover: Qt.rgba(0x16 / 255, 0x16 / 255, 0x16 / 255, 0.6)
    // The one colour so far: a status that is on (e.g. Tailscale connected).
    readonly property color online: "#34c759"
    readonly property string font: "Inter"

    readonly property int tiny: 9
    readonly property int small: 10
    readonly property int body: 11
    readonly property int title: 12
    readonly property int heading: 13
    readonly property int large: 14
    readonly property int display: 20

    readonly property int icon: 12

    readonly property int radiusCard: 20
    readonly property int radiusSection: 12
    readonly property int radiusButton: 10
    readonly property int radiusSmall: 8

    readonly property real shadowOpacity: 0.55
    readonly property real shadowBlur: 0.5
    readonly property int shadowOffset: 2
}
