pragma Singleton

import QtQuick
import Quickshell

// Single source of truth for colors, fonts, sizes, spacing and durations.
// Colors: keep in sync with dotfiles/hypr/colors.lua.
Singleton {
    // Colors
    readonly property color background: "#0a0e1a"
    readonly property color surface: "#141a2a"
    readonly property color foreground: "#e8ecf1"
    readonly property color foregroundMuted: "#99e8ecf1"
    readonly property color accent: "#7aa2f7"
    readonly property color inactive: "#2a3040"
    readonly property color error: "#ff8a8a"
    readonly property color scrim: "#80000000"

    // Fonts
    readonly property string fontFamily: "Inter"
    readonly property int fontSizeSmall: 12
    readonly property int fontSize: 14
    readonly property int fontSizeLarge: 20

    // Sizes and spacing
    readonly property int spacing: 12
    readonly property int spacingLarge: 24
    readonly property int radius: 0
    readonly property int borderWidth: 2

    // Animation durations (animations are off for now)
    readonly property int durationShort: 0

    // Login screen (greeter and lock): white text straight on the wallpaper.
    // Layout values are fractions of the screen height (h), so it looks the
    // same on any resolution. "Y" is the vertical center of the item.
    readonly property QtObject login: QtObject {
        readonly property color background: "#111111" // behind the wallpaper while it loads
        readonly property color text: "#ffffff"
        readonly property color clock: "#e6ffffff"    // 90 %
        readonly property color muted: "#99ffffff"    // 60 %
        readonly property color hint: "#80ffffff"     // 50 %
        readonly property color outline: "#33ffffff"  // 20 %
        readonly property color error: "#ff8a8a"

        readonly property real dateY: 0.107
        readonly property real dateSize: 0.0254
        readonly property real clockY: 0.185
        readonly property real clockSize: 0.12

        readonly property real capsY: 0.825
        readonly property real avatarY: 0.86
        readonly property real avatarSize: 0.048
        readonly property real nameY: 0.908
        readonly property real nameSize: 0.0133
        readonly property real promptY: 0.935
        readonly property real promptSize: 0.011
        readonly property real dotSize: 0.007
        readonly property real dotSpacing: 0.005
        readonly property real promptWidth: 0.4
        readonly property real statusY: 0.968
        readonly property real statusUnit: 0.0115 // icons are 1.5 units, gaps 0.9

        readonly property int failDuration: 2000 // ms the "Wrong password" state lasts
    }

    // Assets (relative to this file, so they also work from the greeter's store copy).
    // Icons come from the icon theme (Colloid), not from files: Quickshell.iconPath().
    readonly property url wallpaper: Qt.resolvedUrl("../assets/wallpaper.jpg")
}
