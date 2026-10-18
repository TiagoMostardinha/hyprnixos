pragma Singleton

import QtQuick
import Quickshell

// Single source of truth for colors, fonts, sizes and timings.
// Hyprland's colors live in dotfiles/hypr/colors.lua: keep shared colors in sync.
Singleton {
    // Login and lock screen: white text straight on the wallpaper.
    readonly property url wallpaper: Qt.resolvedUrl("../assets/wallpaper.jpg")
    readonly property string fontFamily: "Inter"
    readonly property color text: "#ffffff"
    readonly property color textClock: "#e6ffffff"  // 90 %
    readonly property color textMuted: "#99ffffff"  // 60 %
    readonly property color outline: "#33ffffff"    // 20 %
    readonly property color error: "#ff8a8a"
    readonly property int failDuration: 2000        // ms "Wrong password" stays

    // Layout as fractions of the screen height, so it looks the same on any
    // resolution. "Y" is the vertical center of the item.
    readonly property real dateY: 0.107
    readonly property real dateSize: 0.0254
    readonly property real clockY: 0.185
    readonly property real clockSize: 0.12
    readonly property real avatarY: 0.86
    readonly property real avatarSize: 0.048
    readonly property real nameY: 0.908
    readonly property real nameSize: 0.0133
    readonly property real promptY: 0.935
    readonly property real promptSize: 0.011
    readonly property real dotSize: 0.007
    readonly property real dotSpacing: 0.005
    readonly property real statusY: 0.968
    readonly property real statusSize: 0.017
    readonly property real statusSpacing: 0.01
}
