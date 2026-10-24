import QtQuick

Rectangle {
    id: button

    property string label: ""
    property string emphasis: "secondary"
    property int labelSize: 13
    property int labelWeight: Font.DemiBold
    property color labelColor: emphasis === "primary" ? IslandTheme.pill : emphasis === "quiet" ? IslandTheme.fg2 : IslandTheme.fg

    height: 31
    radius: height / 2
    color: emphasis === "primary" ? IslandTheme.fg : emphasis === "quiet" ? IslandTheme.card : IslandTheme.card2

    IslandText {
        visible: text !== ""
        anchors.centerIn: parent
        text: button.label
        color: button.labelColor
        font.pixelSize: button.labelSize
        font.weight: button.labelWeight
    }
}
