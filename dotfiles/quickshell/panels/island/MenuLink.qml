import QtQuick

// A plain row at the bottom of a menu card that opens a settings app: grey label and a chevron, grey
// box on hover.
Rectangle {
    id: link

    property alias text: label.text

    signal clicked

    height: 28
    radius: IslandTheme.radiusButton
    color: area.containsMouse ? IslandTheme.hover : "transparent"

    MouseArea {
        id: area

        anchors.fill: parent
        hoverEnabled: true
        onClicked: link.clicked()
    }

    IslandText {
        id: label

        x: 4
        anchors.verticalCenter: parent.verticalCenter
        tone: "secondary"
        font.pixelSize: IslandTheme.small
        font.weight: Font.Medium
    }

    SymbolicIcon {
        anchors.right: parent.right
        anchors.rightMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        name: "go-next-symbolic"
        color: IslandTheme.fg2
    }
}
