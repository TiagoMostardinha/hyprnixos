pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

// The media player the island shows: whichever is playing, else Spotify, else the first one.
Singleton {
    readonly property var players: Mpris.players.values.filter(player => !player.dbusName.includes("playerctld"))
    readonly property MprisPlayer player: players.find(player => player.isPlaying)
        ?? players.find(player => player.dbusName.includes("spotify"))
        ?? players[0]
        ?? null

    readonly property real length: player?.lengthSupported ? player.length : 0
    readonly property real position: player?.positionSupported ? player.position : 0
    readonly property real progress: length > 0 ? Math.min(1, position / length) : 0

    function time(seconds) {
        const total = Math.max(0, Math.floor(seconds));
        return Math.floor(total / 60) + ":" + String(total % 60).padStart(2, "0");
    }

    // MPRIS doesn't push position updates, so ask for a fresh one every second while playing.
    Timer {
        running: player?.isPlaying ?? false
        interval: 1000
        repeat: true
        onTriggered: player.positionChanged()
    }
}
