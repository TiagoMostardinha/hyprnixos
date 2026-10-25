import QtQuick
import Quickshell.Widgets
import "../../services"

// The playing media's picture in a rounded box: the album cover for Spotify, else the app's icon.
ClippingRectangle {
    id: art

    property real iconSize: 44
    // The cover on screen; it only changes once the next cover has finished loading, so songs switch
    // cover to cover without a blank in between (or during Spotify's brief empty URL).
    property string shown: ""

    color: IslandTheme.card2

    Image {
        visible: false
        source: Media.cover
        sourceSize: Qt.size(art.width * 2, art.height * 2)
        asynchronous: true
        onStatusChanged: if (status === Image.Ready)
            art.shown = source
    }

    Image {
        visible: Media.usesCover && art.shown !== ""
        anchors.fill: parent
        source: art.shown
        sourceSize: Qt.size(width * 2, height * 2)
        fillMode: Image.PreserveAspectCrop
    }

    IconImage {
        visible: !Media.usesCover && Media.player !== null
        anchors.centerIn: parent
        implicitSize: art.iconSize
        source: Media.appIcon
    }
}
