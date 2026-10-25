import QtQuick
import "../../services"

OsdCard {
    level: Audio.muted ? 0 : Math.min(Audio.volume, 1)
    onMoved: level => Audio.set(level)

    SpeakerGlyph {}
}
