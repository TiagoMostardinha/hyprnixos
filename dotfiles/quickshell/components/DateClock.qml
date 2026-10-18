import QtQuick
import "../theme"
import "../services"

// Date above a large 24h clock, centered horizontally. Fills the screen;
// positions are fractions of its height.
Item {
    id: root

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * Theme.login.dateY - height / 2
        text: Qt.locale("en_US").toString(Time.date, "dddd, d MMMM")
        color: Theme.login.text
        font.family: Theme.fontFamily
        font.weight: Font.DemiBold
        font.pixelSize: root.height * Theme.login.dateSize
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * Theme.login.clockY - height / 2
        text: Qt.locale("en_US").toString(Time.date, "HH:mm")
        color: Theme.login.clock
        font.family: Theme.fontFamily
        font.weight: Font.Bold
        font.pixelSize: root.height * Theme.login.clockSize
    }
}
