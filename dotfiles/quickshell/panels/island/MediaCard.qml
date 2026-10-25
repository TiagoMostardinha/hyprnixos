import QtQuick
import Quickshell.Widgets
import "../../services"

IslandCard {
    id: card

    readonly property var player: Media.player

    gap: 10

    width: 340
    height: 108

    ClippingRectangle {
        x: 12
        y: 12
        width: 84
        height: 84
        radius: IslandTheme.radiusSmall
        color: IslandTheme.card2

        Image {
            anchors.fill: parent
            source: card.player?.trackArtUrl ?? ""
            sourceSize: Qt.size(width * 2, height * 2)
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }
    }

    IslandText {
        x: 108
        line: 27
        width: card.width - x - 12
        elide: Text.ElideRight
        text: card.player?.trackTitle || "Nothing playing"
        font.pixelSize: IslandTheme.title
        font.weight: Font.DemiBold
    }

    IslandText {
        x: 108
        line: 42
        width: card.width - x - 12
        elide: Text.ElideRight
        text: card.player?.trackArtist ?? ""
        tone: "secondary"
    }

    IslandText {
        x: 108
        line: 56
        width: controls.x - x - 8
        elide: Text.ElideRight
        text: card.player?.trackAlbum ?? ""
        tone: "muted"
        font.pixelSize: IslandTheme.small
    }

    IslandText {
        x: 108
        line: 70
        width: controls.x - x - 8
        elide: Text.ElideRight
        text: card.player?.identity ?? ""
        tone: "muted"
        font.pixelSize: IslandTheme.small
    }

    // Previous / next: a grey circle behind the glyph while hovered.
    component SkipButton: Item {
        id: skip

        property alias fill: glyph.fill
        property bool enabled: true

        signal clicked

        width: 20
        height: 20
        opacity: enabled ? 1 : 0.4

        Rectangle {
            visible: skipArea.containsMouse
            anchors.fill: parent
            radius: width / 2
            color: IslandTheme.card2
        }

        PathGlyph {
            id: glyph

            anchors.centerIn: parent
            width: 8
            height: 8
            view: Qt.size(8, 8)
        }

        MouseArea {
            id: skipArea

            anchors.fill: parent
            enabled: skip.enabled
            hoverEnabled: true
            onClicked: skip.clicked()
        }
    }

    Row {
        id: controls

        anchors.right: parent.right
        anchors.rightMargin: 6
        y: bar.y - height - 4
        spacing: 2

        SkipButton {
            fill: "M 7.8 0 L 1.4 4 L 7.8 8 Z M 0 0 H 1.4 V 8 H 0 Z"
            enabled: card.player?.canGoPrevious ?? false
            onClicked: card.player.previous()
        }

        PillButton {
            id: play

            width: 20
            height: 20
            radius: height / 2
            invertOnHover: true
            onClicked: card.player?.togglePlaying()

            // Pause bars while playing, the play triangle otherwise.
            PathGlyph {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: card.player?.isPlaying ? 0 : 0.5
                width: 7
                height: 9
                view: Qt.size(7, 9)
                color: play.inverted ? IslandTheme.pill : IslandTheme.fg
                fill: card.player?.isPlaying ? "M 0 0 H 2.4 V 9 H 0 Z M 4.6 0 H 7 V 9 H 4.6 Z" : "M 0 0 L 7 4.5 L 0 9 Z"
            }
        }

        SkipButton {
            fill: "M 0 0 L 6.4 4 L 0 8 Z M 6.4 0 H 7.8 V 8 H 6.4 Z"
            enabled: card.player?.canGoNext ?? false
            onClicked: card.player.next()
        }
    }

    LevelBar {
        id: bar

        // While dragging, the bar follows the pointer; the song jumps there on release.
        property real dragLevel: -1

        x: 108
        y: 78
        width: card.width - x - 12
        height: 4
        level: dragLevel >= 0 ? dragLevel : Media.progress

        // Click or drag along the line to move through the song; scroll steps 5 seconds.
        MouseArea {
            anchors.fill: parent
            anchors.topMargin: -6
            anchors.bottomMargin: -6
            enabled: card.player?.canSeek ?? false
            preventStealing: true

            function levelAt(x) {
                return Math.max(0, Math.min(1, x / bar.width));
            }

            onPressed: mouse => bar.dragLevel = levelAt(mouse.x)
            onPositionChanged: mouse => bar.dragLevel = levelAt(mouse.x)
            onReleased: {
                card.player.position = bar.dragLevel * Media.length;
                bar.dragLevel = -1;
            }
            onWheel: wheel => card.player.position = Math.max(0, Math.min(Media.length, Media.position + (wheel.angleDelta.y > 0 ? 5 : -5)))
        }
    }

    IslandText {
        x: 108
        line: 94
        text: Media.time(bar.dragLevel >= 0 ? bar.dragLevel * Media.length : Media.position)
        tone: "secondary"
        font.pixelSize: IslandTheme.tiny
    }

    IslandText {
        x: card.width - 12 - width
        line: 94
        text: Media.time(Media.length)
        tone: "secondary"
        font.pixelSize: IslandTheme.tiny
    }
}
