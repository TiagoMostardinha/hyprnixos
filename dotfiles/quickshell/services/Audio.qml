pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    readonly property PwNode sink: Pipewire.defaultAudioSink

    readonly property bool ready: sink?.ready ?? false
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    function set(volume) {
        if (!sink?.audio)
            return;
        sink.audio.muted = false;
        sink.audio.volume = volume;
    }

    PwObjectTracker {
        objects: [sink]
    }
}
