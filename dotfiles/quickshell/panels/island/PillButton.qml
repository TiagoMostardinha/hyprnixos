import QtQuick

Rectangle {
    id: button

    property string label: ""
    property string emphasis: "secondary"
    property int labelSize: IslandTheme.body
    property int labelWeight: Font.DemiBold
    property color labelColor: emphasis === "primary" ? IslandTheme.pill : emphasis === "quiet" ? IslandTheme.fg2 : IslandTheme.fg

    height: 28
    radius: IslandTheme.radiusButton
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
