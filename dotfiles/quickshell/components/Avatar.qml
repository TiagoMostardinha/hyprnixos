import QtQuick
import Quickshell.Widgets
import "../theme"

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
