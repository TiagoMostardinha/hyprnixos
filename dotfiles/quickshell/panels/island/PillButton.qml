import QtQuick

Rectangle {
    id: button

    property string label: ""
    property string emphasis: "secondary"
    property int labelSize: IslandTheme.body
    property int labelWeight: Font.DemiBold
    property color labelColor: emphasis === "primary" ? IslandTheme.pill : emphasis === "quiet" ? IslandTheme.fg2 : IslandTheme.fg

    // While held (or hovered, with invertOnHover) the button inverts to white with a black label,
    // like today's mark on the calendar.
    property bool invertOnHover: false
    readonly property bool pressed: area.pressed
    readonly property bool inverted: pressed || (invertOnHover && area.containsMouse)

    signal clicked
    signal rightClicked

    height: 28
    radius: IslandTheme.radiusButton
    color: inverted ? IslandTheme.fg : emphasis === "primary" ? IslandTheme.fg : emphasis === "quiet" ? IslandTheme.card : IslandTheme.card2

    IslandText {
        visible: text !== ""
        anchors.centerIn: parent
        text: button.label
        color: button.inverted ? IslandTheme.pill : button.labelColor
        font.pixelSize: button.labelSize
        font.weight: button.labelWeight
    }

    MouseArea {
        id: area

        anchors.fill: parent
        hoverEnabled: button.invertOnHover
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => mouse.button === Qt.RightButton ? button.rightClicked() : button.clicked()
    }
}
