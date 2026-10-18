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
    readonly property int fontSizeClock: 96

    // Sizes and spacing
    readonly property int spacing: 12
    readonly property int spacingLarge: 24
    readonly property int radius: 0
    readonly property int borderWidth: 2
    readonly property int inputWidth: 280
    readonly property int inputHeight: 40

    // Animation durations (animations are off for now)
    readonly property int durationShort: 0

    // Assets (repo is cloned to ~/nixos-config)
    readonly property string lockWallpaper: "file://" + Quickshell.env("HOME") + "/nixos-config/assets/lock-wallpaper.jpg"
}
