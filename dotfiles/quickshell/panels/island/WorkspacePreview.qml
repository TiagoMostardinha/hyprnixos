import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

// A miniature of one workspace: the desktop wallpaper with a snapshot of each of its windows
// placed where it sits on the monitor.
Item {
    id: preview

    required property int workspace
    property real radius: IslandTheme.radiusSection

    // The same file hyprpaper shows (dotfiles/hypr/hyprpaper.conf).
    readonly property url wallpaper: "file://" + Quickshell.env("HOME") + "/nixos-config/assets/wallpaper.jpg"

    readonly property var monitor: Hyprland.focusedMonitor?.lastIpcObject ?? {}
    readonly property real monitorX: monitor.x ?? 0
    readonly property real monitorY: monitor.y ?? 0
    readonly property real monitorWidth: (monitor.width ?? 1280) / (monitor.scale ?? 1)
    readonly property real scale: width / monitorWidth

    // Oldest-focused first, so the most recently focused window ends up on top.
    readonly property var windows: Hyprland.toplevels.values
        .filter(window => window.workspace?.id === workspace && window.lastIpcObject?.at)
        .sort((a, b) => (b.lastIpcObject.focusHistoryID ?? 0) - (a.lastIpcObject.focusHistoryID ?? 0))

    Item {
        id: content

        anchors.fill: parent
        visible: false
        layer.enabled: true

        Image {
            anchors.fill: parent
            source: preview.wallpaper
            fillMode: Image.PreserveAspectCrop
            sourceSize: Qt.size(width * 2, height * 2)
            asynchronous: true
        }

        // ScriptModel keeps each window's delegate as Hyprland updates its data, so a window is
        // captured once instead of on every update.
        Repeater {
            model: ScriptModel {
                values: preview.windows
            }

            ScreencopyView {
                required property var modelData

                x: (modelData.lastIpcObject.at[0] - preview.monitorX) * preview.scale
                y: (modelData.lastIpcObject.at[1] - preview.monitorY) * preview.scale
                width: modelData.lastIpcObject.size[0] * preview.scale
                height: modelData.lastIpcObject.size[1] * preview.scale
                captureSource: modelData.wayland
                live: false
            }
        }
    }

    Rectangle {
        id: mask

        anchors.fill: parent
        radius: preview.radius
        visible: false
        layer.enabled: true
    }

    MultiEffect {
        anchors.fill: parent
        source: content
        maskEnabled: true
        maskSource: mask
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1.0
    }
}
