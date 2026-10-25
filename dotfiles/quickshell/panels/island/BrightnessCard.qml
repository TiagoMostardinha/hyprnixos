import QtQuick
import "../../services"

OsdCard {
    level: Brightness.level
    onMoved: level => Brightness.set(level)

    SunGlyph {}
}
