import QtQuick

// A menu card's title with a dot: green while on, grey when off. Grey box on hover; clicking it emits
// clicked() (the cards use it to turn the radio on or off).
Item {
    id: menuTitle

    property alias text: label.text
    property bool on: false

    signal clicked

    width: dot.x + dot.width
    height: 22

    Rectangle {
        id: hoverBox

        visible: area.containsMouse
        x: -6
        y: -2
        width: parent.width + 12
        height: parent.height + 4
        radius: IslandTheme.radiusButton
        color: IslandTheme.hover
    }

    IslandText {
        id: label

        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: IslandTheme.heading
        font.weight: Font.DemiBold
    }

    Rectangle {
        id: dot

        x: label.width + 7
        anchors.verticalCenter: parent.verticalCenter
        width: 7
        height: 7
        radius: 3.5
        color: menuTitle.on ? IslandTheme.online : IslandTheme.fg3
    }

    MouseArea {
        id: area

        anchors.fill: hoverBox
        hoverEnabled: true
        onClicked: menuTitle.clicked()
    }
}
