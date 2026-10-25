import QtQuick
import Quickshell.Hyprland

IslandCard {
    id: card

    // Desktops 1 to 5 in a circle (5 sits left of 1); the carousel starts on the focused one.
    readonly property int count: 5
    property int selected: {
        const id = Hyprland.focusedWorkspace?.id ?? 1;
        return id >= 1 && id <= count ? id - 1 : 0;
    }
    readonly property int pitch: 140

    function rotate(step) {
        selected = (selected + step + count) % count;
    }

    function apply() {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${selected + 1} })`);
        card.open("Idle");
    }

    width: 520
    height: 147

    focus: true
    Component.onCompleted: {
        forceActiveFocus();
        // Window positions for the previews come from the latest Hyprland state.
        Hyprland.refreshToplevels();
    }
    Keys.onLeftPressed: rotate(-1)
    Keys.onRightPressed: rotate(1)
    Keys.onReturnPressed: apply()
    Keys.onEnterPressed: apply()

    IslandText {
        x: 16
        line: 24
        text: "Desktops"
        font.pixelSize: IslandTheme.heading
        font.weight: Font.DemiBold
    }

    IslandText {
        x: card.width - 16 - width
        line: 24
        text: (card.selected + 1) + " / " + card.count
        tone: "secondary"
        font.pixelSize: IslandTheme.small
    }

    Item {
        x: 10
        y: 34
        width: card.width - 20
        height: 89
        clip: true

        // One slot per desktop, created once when the card opens so each preview is captured a single
        // time; the arrows only move the slots around the circle.
        Repeater {
            model: card.count

            Rectangle {
                required property int index

                readonly property int workspace: index + 1
                readonly property int offset: (index - card.selected + card.count + 2) % card.count - 2
                readonly property bool isCurrent: offset === 0

                x: parent.width / 2 + offset * card.pitch - width / 2
                y: 4
                width: 130
                height: 81
                radius: IslandTheme.radiusSection
                color: IslandTheme.card

                WorkspacePreview {
                    anchors.fill: parent
                    workspace: parent.workspace
                    radius: parent.radius
                    opacity: parent.isCurrent ? 1 : 0.45
                }

                Rectangle {
                    x: 6
                    y: parent.height - height - 6
                    width: label.width + 12
                    height: label.height + 4
                    radius: height / 2
                    color: IslandTheme.pill
                    opacity: 0.85

                    IslandText {
                        id: label

                        anchors.centerIn: parent
                        text: "workspace " + parent.parent.workspace
                        tone: parent.parent.isCurrent ? "primary" : "secondary"
                        font.pixelSize: IslandTheme.tiny
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.color: IslandTheme.fg
                    border.width: parent.isCurrent ? 2 : 0
                }
            }
        }
    }

    IslandText {
        x: 16
        line: 137
        text: "← →  rotate"
        tone: "muted"
        font.pixelSize: IslandTheme.tiny
    }

    IslandText {
        x: card.width - 16 - width
        line: 137
        text: "Enter to apply"
        tone: "muted"
        font.pixelSize: IslandTheme.tiny
    }
}
