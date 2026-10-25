import QtQuick

Rectangle {
    id: button

    property string label: ""
    property string emphasis: "secondary"
    property int labelSize: IslandTheme.body
    property int labelWeight: Font.DemiBold
    property color labelColor: emphasis === "primary" ? IslandTheme.pill : emphasis === "quiet" ? IslandTheme.fg2 : IslandTheme.fg

    // While held, the button inverts to white with a black label, like today's mark on the calendar.
    readonly property bool pressed: area.pressed

    signal clicked

    height: 28
    radius: IslandTheme.radiusButton
    color: pressed ? IslandTheme.fg : emphasis === "primary" ? IslandTheme.fg : emphasis === "quiet" ? IslandTheme.card : IslandTheme.card2

    IslandText {
        visible: text !== ""
        anchors.centerIn: parent
        text: button.label
        color: button.pressed ? IslandTheme.pill : button.labelColor
        font.pixelSize: button.labelSize
        font.weight: button.labelWeight
    }

    MouseArea {
        id: area

        anchors.fill: parent
        onClicked: button.clicked()
    }
}
