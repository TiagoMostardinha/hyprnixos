import QtQuick
import Quickshell.Widgets
import "../theme"

// Round avatar with a thin light outline, cropped to fill.
ClippingRectangle {
    id: root

    required property url source

    radius: width / 2
    color: "transparent"
    border.width: 1
    border.color: Theme.outline

    Image {
        anchors.fill: parent
        source: root.source
        fillMode: Image.PreserveAspectCrop
    }
}
